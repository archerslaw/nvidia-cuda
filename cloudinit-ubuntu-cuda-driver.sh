#!/bin/sh

log="/var/log/nvidia_install.log"

driver_version="390.46"
cuda_version="9.0.176"

cuda_big_version=$(echo $cuda_version | awk -F'.' '{print $1"."$2}')

echo "install nvidia driver and cuda begin ......" >> $log 2>&1
echo "driver version: $driver_version" >> $log 2>&1
echo "cuda version: $cuda_version" >> $log 2>&1
