#!/bin/bash

driver_version=390.46
cuda_version=9.0.176
cuda_driver_url=http://mirrors.myhuaweicloud.com/ecs/script/linux/cloudinit-centos-cuda-driver.sh

script_file=/var/nvidia-cuda-driver-install.sh
curl -o ${script_file} ${cuda_driver_url}
sed -i 's/^driver_version=.*/driver_version='${driver_version}'/g' ${script_file}
sed -i 's/^cuda_version=.*/cuda_version='${cuda_version}'/g' ${script_file}
chmod +x ${script_file}
bash ${script_file} &

