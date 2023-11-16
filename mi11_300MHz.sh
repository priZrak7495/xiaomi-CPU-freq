#!/system/bin/sh
#
# This script do downscale CPU cores to minimal value without lag
# All available freqs on stock kernel (A12 xiaomi.eu) see below
# Author : priZrak495 4pda.to
#

#Available Freqs in stock Mi11 kernel
#Little: 300000 403200 499200 595200 691200 806400 902400 998400 1094400 1209600 1305600 1401600 1497600 1612800 1708800 1804800
#Big   : 710400 844800 960000 1075200 1209600 1324800 1440000 1555200 1670400 1766400 1881600 1996800 2112000 2227200 2342400 2419200
#Prime : 844800 960000 1075200 1190400 1305600 1420800 1555200 1670400 1785600 1900800 2035200 2150400 2265600 2380800 2496000 2592000 2688000 2764800 2841600

while [ "$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do sleep 1; done
sleep 5

little_min=300000
big_min=710400
prime_min=844800

little_max=1804800
big_max=2419200
prime_max=2841600

#Set min CPU freq
chmod 0744 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 0744 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
chmod 0744 /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
echo $little_min > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo $big_min > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo $prime_min > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq

#Set max CPU freq
chmod 0744 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 0744 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
chmod 0744 /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
echo $little_max > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo $big_max > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo $prime_max > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq

#msm_performance
chmod 0744 /sys/module/msm_performance/parameters/cpu_min_freq
chmod 0744 /sys/module/msm_performance/parameters/cpu_max_freq
echo "0:$little_min 1:$little_min 2:$little_min 3:$little_min 4:$big_min 5:$big_min 6:$big_min 7:$prime_min" > /sys/module/msm_performance/parameters/cpu_min_freq
echo "0:$little_max 1:$little_max 2:$little_max 3:$little_max 4:$big_max 5:$big_max 6:$big_max 7:$prime_max" > /sys/module/msm_performance/parameters/cpu_max_freq
chmod 0444 /sys/module/msm_performance/parameters/cpu_min_freq
chmod 0444 /sys/module/msm_performance/parameters/cpu_max_freq

while true
do
cat /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state > /data/local/tmp/300MHz_10s.txt
sleep 10
done
