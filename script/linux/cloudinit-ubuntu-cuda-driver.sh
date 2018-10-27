#!/bin/bash

log="/var/log/nvidia_install.log"

driver_version="384.66"
cuda_version="8.0.61"

cuda_big_version=$(echo $cuda_version | awk -F'.' '{print $1"."$2}')

echo "install nvidia driver and cuda begin ......" >> $log 2>&1
echo "driver version: $driver_version" >> $log 2>&1
echo "cuda version: $cuda_version" >> $log 2>&1

######Ubuntu##########
create_nvidia_repo_ubuntu()
{
    url="http://mirrors.myhuaweicloud.com"
    repo_file="/etc/apt/sources.list"
    url1="deb $url/ecs/linux/apt/ ecs cuda"
    url2="deb $url/ecs/linux/apt/ ecs driver"
    sed -i "/ecs driver/d" $repo_file
    sed -i "/ecs driver/d" $repo_file
    echo $url1 >> $repo_file
    echo $url2 >> $repo_file
    
    wget -O - http://mirrors.myhuaweicloud.com/ecs/linux/apt/huaweicloud.ubuntu.gpg.key | apt-key add -
    rm -fr /var/cache/apt/archives/lock
    rm -fr /var/lib/dpkg/lock
    rm -fr /var/lib/apt/lists/lock
    apt-get update --fix-missing >> $log 2>&1
}

update_ubuntu1404_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#14.04
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty-backports main restricted universe multiverse
EOF
apt-get update --fix-missing
}

update_ubuntu1604_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#16.04
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial-backports main restricted universe multiverse
EOF
apt-get update --fix-missing
}

update_ubuntu1804_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#18.04
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF
apt-get update --fix-missing
}

install_kernel_devel_ubuntu()
{
    #install linux-headers
    kernel_version=$(uname -r)
    echo "******exec \"uname -r\": $kernel_version"
    echo "******exec \"dpkg --list |grep linux-headers | grep $kernel_version | wc -l\""
    linux_headers_num=$(dpkg --list |grep linux-headers | grep $kernel_version | wc -l)
    echo "******linux_headers_num=$linux_headers_num"
    if [ $linux_headers_num -eq 0 ];then
        echo "******exec \"apt-get install -y --allow-unauthenticated linux-headers-$kernel_version\""
        apt-get install -y --allow-unauthenticated linux-headers-$kernel_version
        if [ $? -ne 0 ]; then
            echo "error: install linux-headers fail!!!"
            return 1
        fi
    fi
}

install_nvidia_driver_ubuntu()
{
    #install driver
    driver_file_num=$(apt-cache search nvidia | grep driver | grep $release | grep $driver_version | wc -l)
    if [ $driver_file_num -eq 1 ];then
        driver_file=$(apt-cache search nvidia | grep driver | grep $release | grep $driver_version | awk -F' ' '{print $1}')
        echo "******exec \"apt-cache search nvidia | grep driver |grep $release |grep $driver_version | awk -F' ' '{print \$1}'\":"
        echo $driver_file
    else
        echo "error: driver_file_num = $driver_file_num , get driver file failed, exit"
        return 1
    fi

    echo "******exec \"apt-get install -y --allow-unauthenticated $driver_file\" "
    apt-get install -y --allow-unauthenticated $driver_file

    echo "******exec \"apt-key add /var/nvidia*driver*$driver_version/*.pub\""
    apt-key add /var/nvidia*driver*$driver_version/*.pub

    echo "******exec \"apt-get update && apt-get install -y --allow-unauthenticated cuda-drivers\" "
    apt-get update && apt-get install -y --allow-unauthenticated cuda-drivers

    if [ $? -ne 0 ]; then
        echo "error: driver install fail!!!"
        return 1
    fi
}

install_nvidia_cuda_ubuntu()
{
    begin_cuda=$(date '+%s')
    cuda_file_num=$(apt-cache search cuda | grep $release | grep $cuda_big_version |grep -v update | grep -v patch | wc -l)
    if [ $cuda_file_num -eq 1 ];then
        cuda_file=$(apt-cache search cuda | grep $release | grep $cuda_big_version |grep -v update | grep -v patch | awk -F' ' '{print $1}')
        echo "******exec \"apt-cache search cuda| grep $release| grep $cuda_big_version |grep -v update | grep -v patch | awk -F' ' '{print \$1}'\""
        echo $cuda_file
    else
        echo "error: cuda_file_num = $cuda_file_num , get cuda file failed, exit"
        return 1
    fi

    #install cuda
    echo "******exec \"apt-get install -y --allow-unauthenticated $cuda_file\" "
    apt-get install -y --allow-unauthenticated $cuda_file

    end_cuda_unpack=$(date '+%s')
    time_cuda_unpack=$((end_cuda_unpack-begin_cuda))
    echo "******download and unpack cuda file end, end time: $end_cuda_unpack, use time $time_cuda_unpack s"

    echo "******exec \"apt-cache search cuda | grep $release | grep $cuda_big_version | grep update | awk -F' ' '{print \$1}'\" "
    cuda_patch_filelist=$(apt-cache search cuda | grep $release | grep $cuda_big_version | grep update | awk -F' ' '{print $1}')

    echo "****** cuda_patch_filelist"
    echo $cuda_patch_filelist
    for cuda_patch_file in $cuda_patch_filelist
    do
        echo "******exec \"apt-get install -y --allow-unauthenticated $cuda_patch_file\" "
        apt-get install -y --allow-unauthenticated $cuda_patch_file
    done

    echo "******exec \"apt-get update && apt-get install -y --allow-unauthenticated cuda\" "
    apt-get update && apt-get install -y --allow-unauthenticated cuda
    if [ $? -ne 0 ]; then
        echo "error: cuda install fail!!!"
        return 1
    fi

    end_cuda=$(date '+%s')
    time_cuda=$((end_cuda-begin_cuda))
    echo "******install cuda begin time: $begin_cuda, end time $end_cuda, use time $time_cuda s"
}

enable_pm()
{
    echo "#!/bin/bash" | tee /etc/init.d/enable_pm.sh
    echo "nvidia-smi -pm 1" | tee -a /etc/init.d/enable_pm.sh
    echo "exit 0" | tee -a /etc/init.d/enable_pm.sh

    chmod +x /etc/init.d/enable_pm.sh

    grep -q "exit 0" $filename
    if [ $? -eq 0 ]; then
        sed -i "/enable_pm.sh/d" $filename
        sed -i '/exit 0/i\bash /etc/init.d/enable_pm.sh' $filename
    else
        sed -i "/enable_pm.sh/d" $filename
        sed -i '$a\bash /etc/init.d/enable_pm.sh' $filename
    fi
    chmod +x $filename
}

os_release=$(grep -i "ubuntu" /etc/issue 2>/dev/null)
os_release_2=$(grep -i "ubuntu" /etc/lsb-release 2>/dev/null)
if [ "$os_release" ] && [ "$os_release_2" ]; then
    if echo "$os_release"|grep "Ubuntu 14.04"; then
        update_ubuntu1404_apt_source >> $log 2>&1
    elif echo "$os_release"|grep "Ubuntu 16.04"; then
        update_ubuntu1604_apt_source >> $log 2>&1
    elif echo "$os_release"|grep "Ubuntu 18.04"; then
        update_ubuntu1804_apt_source >> $log 2>&1
    else
        echo "ERROR: There is no any Repo match the OS."
        exit 1
    fi
fi

if [ ! -f "/usr/bin/lsb_release" ]; then
    apt-get install -y lsb-release
fi

str=$(lsb_release -i | awk -F':' '{print $2}')
os=$(echo $str | sed 's/ //g')
if [ "$os" = "Ubuntu" ]; then
    os="ubuntu"
    str=$(lsb_release -r | awk -F'[:.]' '{print $2$3}')
    version=$(echo $str | sed 's/ //g')
    release="ubuntu${version}"
    filename="/etc/rc.local"
else
    echo "ERROR: OS ($os) is invalid!" >> $log 2>&1
    exit 1
fi

echo "os:$os release:$release version:$version" >> $log 2>&1

create_nvidia_repo_ubuntu >> $log 2>&1

begin=$(date '+%s')
install_kernel_devel_ubuntu >> $log 2>&1 
if [ $? -ne 0 ]; then
    echo "error:  kernel install fail!!!" >> $log 2>&1
    exit 1
fi

end=$(date '+%s')
time_kernel=$((end-begin))
echo "******install kernel-devel begin time: $begin, end time: $end, use time: $time_kernel s" >> $log 2>&1

begin_driver=$(date '+%s')
install_nvidia_driver_ubuntu >> $log 2>&1 
if [ $? -ne 0 ]; then
    echo "error:  driver install fail!!!" >> $log 2>&1
    exit 1
fi

end_driver=$(date '+%s')
time_driver=$((end_driver-begin_driver))
echo "******install driver begin time: $begin_driver, end time: $end_driver,  use time: $time_driver s" >> $log 2>&1

install_nvidia_cuda_ubuntu >> $log 2>&1 
if [ $? -ne 0 ]; then
    echo "error:  cuda install fail!!!" >> $log 2>&1
    exit 1
fi

echo "******install kernel-devel use time $time_kernel s" >> $log 2>&1
echo "******install nvidia driver use time $time_driver s" >> $log 2>&1
echo "******install nvidia cuda use time $time_cuda s" >> $log 2>&1

echo "add auto enable Persistence Mode when start vm..." >> $log 2>&1
enable_pm >> $log 2>&1

echo "reboot......" >> $log 2>&1
reboot
