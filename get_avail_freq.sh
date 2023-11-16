#!/system/bin/sh
# Read available CPU (8 core) freq and save to file

#Little cluster 0-3
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies > /data/local/tmp/cpu0.txt
#Big cluster 4-6
cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_available_frequencies > /data/local/tmp/cpu4.txt
#Prime cluster 7
cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_available_frequencies > /data/local/tmp/cpu7.txt
