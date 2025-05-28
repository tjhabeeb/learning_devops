#!/bin/bash

#a new change

#LIMITS 
CPU_LIMIT=70
RAM_LIMIT=70
DISK_LIMIT=70

#LOG FILE
SYS_LOG_FILE=sys_health_monitor.log

#TIMESTAMP
DATE=date
echo "+++ System Monitor Report - $date +++" >> "$SYS_LOG_FILE"

#CPU_USAGE
CPU_USAGE=top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}'
CPU_USAGE_INT=${CPU_USAGE%.*}

if [ $CPU_USAGE_INT -gt $CPU_LIMIT ]; 
then 
 echo "WARNING: High CPU usage ($CPU_USAGE_INT). Check processes." | tee -a "SYS_LOG_FILE"
else 
 echo "[OK] CPU utilization is nominal ($CPU_USAGE_INT)." | tee -a "SYS_LOG_FILE"
fi

#RAM_USAGE
MEM_TOTAL=$(free | awk '/Mem/ {print $2}')
MEM_USED=$(free | awk '/Mem/ {print $3}')
MEM_USAGE=$((100 * MEM_USED / MEM_TOTAL))
MEM_USAGE_INT=${MEM_USAGE%.*}

if [ $MEM_USAGE_INT -gt $RAM_LIMIT ]; 
then 
 echo "MEMORY WARNING: Available RAM low: $MEM_USAGE_INT remaining." | tee -a "SYS_LOG_FILE"
else 
 echo "[OK] Memory usage: $MEM_USAGE_INT (plenty of free RAM available)." | tee -a "SYS_LOG_FILE"
fi

#DISK_USAGE
DISK_USAGE=$(df -h --total | grep total | awk '{print $5}')
DISK_USAGE_INT=$(DISK_USAGE%/%)

if [ $DISK_USAGE_INT -gt $DISK_LIMIT ]; 
then 
 echo "ALERT: Disk usage: $DISK_USAGE_INT% - CRITICAL DISK SPACE! Services may fail." | tee -a "SYS_LOG_FILE"
else 
 echo "[OK] Disk space usage: All filesystems below $DISK_LIMIT." | tee -a "SYS_LOG_FILE"
fi




