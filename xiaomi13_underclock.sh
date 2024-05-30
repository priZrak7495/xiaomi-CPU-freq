#!/system/bin/sh
#
# This script do downscale CPU cores to minimal value without lag
# All available freqs on stock kernel (A12 xiaomi.eu) see below
# Author : priZrak495 4pda.to
#

#Available Freqs in stock Mi11 kernel
#Little: 307200 441600 556800 672000 787200 902400 1017600 1113600 1228800 1344000 1459200 1555200 1670400 1785600 1900800 2016000 
#Big   : 499200 614400 729600 844800 940800 1056000 1171200 1286400 1401600 1536000 1651200 1785600 1920000 2054400 2188800 2323200 2457600 2592000 2707200 
#Prime : 595200 729600 864000 998400 1132800 1248000 1363200 1478400 1593600 1708800 1843200 1977600 2092800 2227200 2342400 2476800 2592000 2726400 2841600 2956800

while [ "$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do sleep 1; done
sleep 5

little_min=307200
big_min=499200
prime_min=595200

little_max=1555200
big_max=2188800
prime_max=2476800

#Set min CPU freq
chmod 0744 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 0744 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
chmod 0744 /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
echo $little_min > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo $big_min > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
echo $prime_min > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq

#Set max CPU freq
chmod 0744 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 0744 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
chmod 0744 /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
echo $little_max > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo $big_max > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
echo $prime_max > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq

#msm_performance
chmod 0744 /sys/module/msm_performance/parameters/cpu_min_freq
chmod 0744 /sys/module/msm_performance/parameters/cpu_max_freq
echo "0:$little_min 1:$little_min 2:$little_min 3:$big_min 4:$big_min 5:$big_min 6:$big_min 7:$prime_min" > /sys/module/msm_performance/parameters/cpu_min_freq
echo "0:$little_max 1:$little_max 2:$little_max 3:$big_max 4:$big_max 5:$big_max 6:$big_max 7:$prime_max" > /sys/module/msm_performance/parameters/cpu_max_freq
chmod 0444 /sys/module/msm_performance/parameters/cpu_min_freq
chmod 0444 /sys/module/msm_performance/parameters/cpu_max_freq

while true
do
cat /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state > /data/local/tmp/little_10s.txt
cat /sys/devices/system/cpu/cpu3/cpufreq/stats/time_in_state > /data/local/tmp/big_10s.txt
cat /sys/devices/system/cpu/cpu7/cpufreq/stats/time_in_state > /data/local/tmp/prime_10s.txt
sleep 10
done
