#!/system/bin/sh
#
# Xiaomi 13 / Snapdragon 8 Gen 2
# Policy-based CPU freq limiter
# Balanced profile: battery / smoothness
#

#Available Freqs in stock Mi11 kernel
#Little: 307200 441600 556800 672000 787200 902400 1017600 1113600 1228800 1344000 1459200 1555200 1670400 1785600 1900800 2016000 
#Big   : 499200 614400 729600 844800 940800 1056000 1171200 1286400 1401600 1536000 1651200 1785600 1920000 2054400 2188800 2323200 2457600 2592000 2707200 
#Prime : 595200 729600 864000 998400 1132800 1248000 1363200 1478400 1593600 1708800 1843200 1977600 2092800 2227200 2342400 2476800 2592000 2726400 2841600 2956800

while [ "$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do
    sleep 1
done
sleep 5

CPUFREQ_DIR="/sys/devices/system/cpu/cpufreq"

# ========= PROFILE =========
# Проверь свои реальные частоты в:
#   policyX/scaling_available_frequencies
# и подстрой под свой kernel.
#
# Рекомендованный balanced-профиль:

little_min=556800
little_max=1459200

big_min=729600
big_max=1920000

prime_min=864000
prime_max=2342400

# ========= HELPERS =========

find_policy_by_cpu() {
    target_cpu="$1"

    for p in "$CPUFREQ_DIR"/policy*; do
        [ -d "$p" ] || continue

        if [ -f "$p/affected_cpus" ]; then
            cpus="$(cat "$p/affected_cpus" 2>/dev/null)"
        elif [ -f "$p/related_cpus" ]; then
            cpus="$(cat "$p/related_cpus" 2>/dev/null)"
        else
            continue
        fi

        for c in $cpus; do
            if [ "$c" = "$target_cpu" ]; then
                echo "$p"
                return 0
            fi
        done
    done

    return 1
}

write_node() {
    node="$1"
    value="$2"

    [ -e "$node" ] || return 1

    chmod 0744 "$node" 2>/dev/null
    echo "$value" > "$node" 2>/dev/null
    chmod 0644 "$node" 2>/dev/null

    return 0
}

set_policy_limits() {
    policy_path="$1"
    min_freq="$2"
    max_freq="$3"

    [ -d "$policy_path" ] || return 1

    # Сначала max, потом min — так меньше шанс словить "Invalid argument"
    write_node "$policy_path/scaling_max_freq" "$max_freq"
    write_node "$policy_path/scaling_min_freq" "$min_freq"

    return 0
}

# ========= DETECT POLICIES =========
# Используем репрезентативные CPU:
# cpu0  -> little
# cpu3  -> big/middle cluster
# cpu7  -> prime
#
# Если на твоём ядре расклад другой — просто поменяй номера тут.

little_policy="$(find_policy_by_cpu 0)"
big_policy="$(find_policy_by_cpu 3)"
prime_policy="$(find_policy_by_cpu 7)"

log_file="/data/local/tmp/cpu_policy_apply.log"

{
    echo "=== $(date) ==="
    echo "little_policy=$little_policy"
    echo "big_policy=$big_policy"
    echo "prime_policy=$prime_policy"
} > "$log_file"

# ========= APPLY LIMITS =========

if [ -n "$little_policy" ]; then
    set_policy_limits "$little_policy" "$little_min" "$little_max"
fi

if [ -n "$big_policy" ]; then
    set_policy_limits "$big_policy" "$big_min" "$big_max"
fi

if [ -n "$prime_policy" ]; then
    set_policy_limits "$prime_policy" "$prime_min" "$prime_max"
fi

# ========= OPTIONAL: msm_performance =========
# Не на всех ядрах / прошивках есть.
# Если есть — синхронизируем и его тоже.

if [ -e /sys/module/msm_performance/parameters/cpu_min_freq ] && \
   [ -e /sys/module/msm_performance/parameters/cpu_max_freq ]; then

    chmod 0744 /sys/module/msm_performance/parameters/cpu_min_freq 2>/dev/null
    chmod 0744 /sys/module/msm_performance/parameters/cpu_max_freq 2>/dev/null

    echo "0:$little_min 1:$little_min 2:$little_min 3:$big_min 4:$big_min 5:$big_min 6:$big_min 7:$prime_min" \
        > /sys/module/msm_performance/parameters/cpu_min_freq 2>/dev/null

    echo "0:$little_max 1:$little_max 2:$little_max 3:$big_max 4:$big_max 5:$big_max 6:$big_max 7:$prime_max" \
        > /sys/module/msm_performance/parameters/cpu_max_freq 2>/dev/null

    chmod 0444 /sys/module/msm_performance/parameters/cpu_min_freq 2>/dev/null
    chmod 0444 /sys/module/msm_performance/parameters/cpu_max_freq 2>/dev/null
fi

LOG_FILE="/data/local/tmp/cpu_freq.log"
echo "[$(date)] Script started" >> $LOG_FILE

exit 0