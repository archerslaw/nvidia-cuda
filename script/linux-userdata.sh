#!/bin/bash

echo 'root:$6$I63DBVKK$Zh4lchiJR7NuZvtJHsYBQJIg5RoQCRLS1X2Hsgj2s5JwXI7KUO1we8WYcwbzeaS2VNpRmNo28vmxxCyU6LwoD0' | chpasswd -e
driver_version=390.46
cuda_version=9.0.176
os_type=centos

cuda_driver_url=http://mirrors.myhuaweicloud.com/ecs/script/linux/cloudinit-${os_type}-cuda-driver.sh
script_file=/var/nvidia-cuda-driver-install.sh
curl -o ${script_file} ${cuda_driver_url}
sed -i 's/^driver_version=.*/driver_version='${driver_version}'/g' ${script_file}
sed -i 's/^cuda_version=.*/cuda_version='${cuda_version}'/g' ${script_file}
chmod +x ${script_file}
bash ${script_file} &
