#!/bin/sh

log="/var/log/nvidia_install.log"

driver_version="390.46"
cuda_version="9.0.176"

cuda_big_version=$(echo $cuda_version | awk -F'.' '{print $1"."$2}')

echo "install nvidia driver and cuda begin ......" >> $log 2>&1
echo "driver version: $driver_version" >> $log 2>&1
echo "cuda version: $cuda_version" >> $log 2>&1

##Centos
create_nvidia_repo_centos()
{
    curl -o /etc/yum.repos.d/hwCentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-${version}.repo
    curl -o /etc/yum.repos.d/hwepel.repo http://mirrors.myhuaweicloud.com/repo/epel-${version}.repo
    url="http://119.3.60.246"
    cudaurl=$url"/ecs/linux/rpm/cuda/${version}/\$basearch/"
    driverurl=$url"/ecs/linux/rpm/driver/${version}/\$basearch/"
    packageurl=$url"/ecs/linux/rpm/package/${version}/\$basearch/"

    echo "[ecs-cuda]" |tee /etc/yum.repos.d/nvidia-centos.repo
    echo "name=ecs-cuda-\$basearch" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "baseurl=$cudaurl" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "enabled=1" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nvidia-centos.repo	
    echo " " | tee -a /etc/yum.repos.d/nvidia-centos.repo	
    echo "[ecs-driver]" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "name=ecs-driver-\$basearch" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "baseurl=$driverurl" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "enabled=1" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo " " | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "[ecs-package]" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "name=ecs-package-\$basearch" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "baseurl=$packageurl" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "enabled=1" | tee -a /etc/yum.repos.d/nvidia-centos.repo
    echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nvidia-centos.repo

    yum clean all >> $log 2>&1
    yum makecache >> $log 2>&1
}

install_kernel_devel_centos()
{
    #install kernel-devel
    kernel_version=$(uname -r)
    echo "******exec \"uname -r\": $kernel_version"

    echo "******exec \"rpm -qa | grep kernel-devel | grep $kernel_version | wc -l\""
    kernel_devel_num=$(rpm -qa | grep kernel-devel | grep $kernel_version | wc -l)
    echo "******kernel_devel_num=$kernel_devel_num"
    if [ $kernel_devel_num -eq 0 ];then
        echo "******exec \"yum install -y kernel-devel-$kernel_version\""
        yum install -y kernel-devel-$kernel_version
        if [ $? -ne 0 ]; then
            echo "error: install kernel-devel fail!!!"
            return 1
        fi
    fi

    #echo "******exec \"rpm -qa | grep kernel-headers | grep $kernel_version | wc -l\""
    #kernel_headers_num=$(rpm -qa | grep kernel-headers | grep $kernel_version | wc -l)
    #echo "******kernel_headers_num="$kernel_headers_num
    #if [ $kernel_headers_num -eq 0 ];then
    #    echo "******exec \"yum install -y kernel-headers-$kernel_version\""
    #    yum install -y kernel-headers-$kernel_version
    #fi

}


install_nvidia_driver_centos()
{
    #install driver
    driver_file_num=$(yum list | grep nvidia | grep driver | grep $release | grep $driver_version | wc -l)
    if [ $driver_file_num -eq 1 ];then
        driver_file=$(yum list | grep nvidia | grep driver | grep $release | grep $driver_version | awk -F' ' '{print $1}')
        echo "******exec \"yum list |grep nvidia | grep driver |grep $release |grep $driver_version | awk -F' ' '{print \$1}'\":"
        echo $driver_file
    else
        echo "error: driver_file_num = $driver_file_num , get driver file failed, exit"
        return 1
    fi

    echo "******exec \"yum install -y $driver_file\" "
    yum install -y $driver_file

    echo "******exec \"yum clean all && yum install -y cuda-drivers\" "
    yum clean all && yum install -y cuda-drivers
    if [ $? -ne 0 ]; then
        echo "error: driver install fail!!!"
        return 1
    fi
}

install_nvidia_cuda_centos()
{
    begin_cuda=$(date '+%s')
    cuda_file_num=$(yum list | grep cuda | grep $release | grep $cuda_big_version |grep -v update | wc -l)
    if [ $cuda_file_num -eq 1 ];then
        cuda_file=$(yum list | grep cuda | grep $release | grep $cuda_big_version | grep -v update | awk -F' ' '{print $1}')
        echo "******exec \"yum list |grep cuda |grep $release |grep $cuda_big_version|grep -v update| awk -F' ' '{print \$1}'\":"
        echo $cuda_file
    else
        echo "error: cuda_file_num = $cuda_file_num , get cuda file failed, exit"
        return 1
    fi

    #install cuda
    echo "******exec \"yum install -y $cuda_file\" "
    yum install -y $cuda_file

    end_cuda_unpack=$(date '+%s')
    time_cuda_unpack=$((end_cuda_unpack-begin_cuda))
    echo "******download and unpack cuda file end, end time: $end_cuda_unpack, use time $time_cuda_unpack s"


    echo "******exec \"yum list | grep cuda | grep $release | grep $cuda_big_version | grep update | awk -F' ' '{print \$1}'\" "
    cuda_patch_filelist=$(yum list | grep cuda | grep $release | grep $cuda_big_version | grep update | awk -F' ' '{print $1}')

    echo "****** cuda_patch_filelist"
    echo $cuda_patch_filelist
    for cuda_patch_file in $cuda_patch_filelist
    do
        echo "******exec \"yum install -y $cuda_patch_file\" "
        yum install -y $cuda_patch_file
    done

    echo "******exec \"yum clean all && yum install -y cuda\" "
    yum clean all && yum install -y cuda
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
        sed -i '$a\bash /etc/init.d/enable_pm.sh' /etc/rc.d/rc.local
    fi
    chmod +x $filename
}

if [ ! -f "/usr/bin/lsb_release" ]; then
    pkgname=$(yum provides /usr/bin/lsb_release |grep centos|grep x86_64 |head -1 |awk -F: '{print $1}')
    yum install -y $pkgname
fi

str=$(lsb_release -i | awk -F':' '{print $2}')
os=$(echo $str | sed 's/ //g')
if [ "$os" = "CentOS" ]; then
    os="centos"
    str=$(lsb_release -r | awk -F'[:.]' '{print $2}')
    version=$(echo $str | sed 's/ //g')
    release="rhel${version}"
    filename="/etc/rc.d/rc.local"
else
    echo "ERROR: OS ($os) is invalid!" >> $log 2>&1
    exit 1
fi


echo "release:$release" >> $log 2>&1
echo "version:$version" >> $log 2>&1

create_nvidia_repo_centos >> $log 2>&1

#curl -o /etc/yum.repos.d/hwCentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-7.repo
#curl -o /etc/yum.repos.d/nvidia-CentOS.repo http://119.3.60.246/ecs/linux/nvidia-CentOS.repo

#curl -o /etc/yum.repos.d/hwCentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-7.repo
#curl -o /etc/yum.repos.d/nvidia-RHEL.repo http://119.3.60.246/ecs/linux/nvidia-RHEL.repo
yum install epel-release -y >> $log 2>&1

#cp /etc/yum.repos.d/epel.repo /etc/yum.repos.d/hwepel.repo
#cp /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/hwepel-testing.repo
#sed -e 's!^mirrorlist=!#mirrorlist=!g' -e 's!^#baseurl=!baseurl=!g' -e 's!//download\.fedoraproject\.org/pub!//mirrors.myhuaweicloud.com!g' -i /etc/yum.repos.d/hwepel.repo /etc/yum.repos.d/hwepel-testing.repo

yum clean all >> $log 2>&1
yum makecache >> $log 2>&1

begin=$(date '+%s')
install_kernel_devel_centos >> $log 2>&1 
if [ $? -ne 0 ]; then
    exit 1
fi
end=$(date '+%s')
time_kernel=$((end-begin))
echo "******install kernel-devel begin time: $begin, end time: $end, use time: $time_kernel s" >> $log 2>&1


begin_driver=$(date '+%s')
install_nvidia_driver_centos >> $log 2>&1 
if [ $? -ne 0 ]; then
    echo "error: driver download fail!!!" >> $log 2>&1
    exit 1
fi
end_driver=$(date '+%s')
time_driver=$((end_driver-begin_driver))
echo "******install driver begin time: $begin_driver, end time: $end_driver,  use time: $time_driver s" >> $log 2>&1

install_nvidia_cuda_centos >> $log 2>&1 
if [ $? -ne 0 ]; then
    echo "error: cuda download fail!!!" >> $log 2>&1
    exit 1
fi

echo "******install kernel-devel use time $time_kernel s" >> $log 2>&1
echo "******install nvidia driver use time $time_driver s" >> $log 2>&1
echo "******install nvidia cuda use time $time_cuda s" >> $log 2>&1

echo "add auto enable Persistence Mode when start vm..." >> $log 2>&1
enable_pm

echo "reboot......" >> $log 2>&1
reboot
