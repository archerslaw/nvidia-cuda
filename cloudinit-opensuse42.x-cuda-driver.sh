#!/bin/bash

log="/var/log/nvidia_install.log"

driver_version="384.145"
cuda_version="9.0.176"

cuda_big_version=$(echo $cuda_version | awk -F'.' '{print $1"."$2}')

echo "install nvidia driver and cuda begin ......" >> $log 2>&1
echo "driver version: $driver_version" >> $log 2>&1
echo "cuda version: $cuda_version" >> $log 2>&1

##OpenSUSE42.x
create_nvidia_repo_opensuse()
{
    baseurl="http://119.3.60.246"
    echo "baseurl: $baseurl" >> $log 2>&1
    zypper addrepo -G -f ${baseurl}/ecs/linux/zypper/${release}/driver HWnvidia-driver
    zypper addrepo -G -f ${baseurl}/ecs/linux/zypper/${release}/cuda HWnvidia-cuda

    zypper refresh >> $log 2>&1
}

update_opensuse_source4202()
{
  mv /etc/zypp/repos.d/* /tmp/
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/leap/42.2/repo/oss HWCloud:42.2:OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/leap/42.2/repo/non-oss HWCloud:42.3:NON-OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/update/leap/42.2/oss HWCloud:42.2:UPDATE-OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/update/leap/42.2/non-oss HWCloud:42.2:UPDATE-NON-OSS
}

update_opensuse_source4203()
{
  mv /etc/zypp/repos.d/* /tmp/
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/leap/42.3/repo/oss HWCloud:42.3:OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/leap/42.3/repo/non-oss HWCloud:42.3:NON-OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/update/leap/42.3/oss HWCloud:42.3:UPDATE-OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/update/leap/42.3/non-oss HWCloud:42.3:UPDATE-NON-OSS
}

install_kernel_devel_opensuse()
{
    #install kernel-devel
    kernel_version=$(uname -r|awk -F'-' '{print $1"-"$2}')
    echo "******exec \"uname -r\": $kernel_version"

    echo "******exec \"rpm -qa | grep kernel-default-devel | wc -l\""
    kernel_devel_num=$(rpm -qa | grep kernel-default-devel | wc -l)
    echo "******kernel_devel_num=$kernel_devel_num"
    if [ $kernel_devel_num -eq 0 ];then
        echo "******exec \"zypper install -y kernel-default-devel=$kernel_version\""
        zypper install -y kernel-default-devel=$kernel_version
        if [ $? -ne 0 ]; then
            echo "error: install kernel-default-devel fail!!!"
            return 1
        fi
    fi
}

install_nvidia_driver_suse()
{
    #install driver
    driver_file_num=$(zypper se nvidia | grep driver | grep $release | grep $driver_version | wc -l)
    if [ $driver_file_num -eq 1 ];then
        driver_file=$(zypper se nvidia | grep driver | grep $release | grep $driver_version | awk -F'|' '{print $2}')
        echo "******exec \"zypper se nvidia | grep driver |grep $release |grep $driver_version | awk -F'|' '{print \$2}'\":"
        echo $driver_file
    else
        echo "error: driver_file_num = $driver_file_num , get driver file failed, exit"
        return 1
    fi

    echo "******exec \"zypper --no-gpg-checks install -y $driver_file\" "
    zypper --no-gpg-checks install -y $driver_file

    echo "******exec \"zypper --gpg-auto-import-keys refresh && zypper install -y cuda-drivers\" "

    zypper --gpg-auto-import-keys refresh && zypper install -y cuda-drivers
    if [ $? -ne 0 ]; then
        echo "error: driver install fail!!!"
        return 1
    fi
}

install_nvidia_cuda_suse()
{
    begin_cuda=$(date '+%s')
    cuda_file_num=$(zypper se cuda | grep $release | grep $cuda_big_version | grep -v update | grep -v patch | wc -l)
    if [ $cuda_file_num -eq 1 ];then
        cuda_file=$(zypper se cuda | grep $release | grep $cuda_big_version | grep -v update | grep -v patch | awk -F'|' '{print $2}')
        echo "******exec \"zypper se cuda |grep $release |grep $cuda_big_version|grep -v update | grep -v patch | awk -F'|' '{print \$2}'\":"
        echo $cuda_file
    else
        echo "error: cuda_file_num = $cuda_file_num , get cuda file failed, exit"
        return 1
    fi

    #install cuda
    echo "******exec \"zypper --no-gpg-checks install -y $cuda_file\" "
    zypper --no-gpg-checks install -y $cuda_file

    end_cuda_unpack=$(date '+%s')
    time_cuda_unpack=$((end_cuda_unpack-begin_cuda))
    echo "******download and unpack cuda file end, end time: $end_cuda_unpack, use time $time_cuda_unpack s"

    echo "******exec \"zypper se cuda | grep $release | grep $cuda_big_version | grep update | awk -F'|' '{print \$2}'\" "
    cuda_patch_filelist=$(zypper se cuda | grep $release | grep $cuda_big_version | grep update | awk -F'|' '{print $2}')

    echo "****** cuda_patch_filelist"
    echo $cuda_patch_filelist
    for cuda_patch_file in $cuda_patch_filelist
    do
        echo "******exec \"zypper --no-gpg-checks install -y $cuda_patch_file\" "
        zypper --no-gpg-checks install -y $cuda_patch_file
    done

    echo "******exec \"zypper --gpg-auto-import-keys refresh && zypper install -y cuda\" "
    zypper --gpg-auto-import-keys refresh && zypper install -y cuda
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

if [ ! -f "/usr/bin/lsb_release" ]; then
    zypper install -y lsb-release
fi

str=$(lsb_release -i | awk -F':' '{print $2}')
os=$(echo $str | sed 's/ //g')
if [ "$os" = "openSUSEproject" ]; then
    os="opensuse"
    str=$(lsb_release -r | awk -F'[:.]' '{print $2$3}')
    version=$(echo $str | sed 's/ //g')
    release="opensuse${version}"
    filename="/etc/init.d/after.local"
else
    echo "ERROR: OS ($os) is invalid!" >> $log 2>&1
    exit 1
fi

echo "os:$os release:$release version:$version" >> $log 2>&1

if [ "$release" = "opensuse422" ]; then
    update_opensuse_source4202 >> $log 2>&1
elif [ "$release" = "opensuse423" ]; then
    update_opensuse_source4203 >> $log 2>&1
else
    echo "ERROR: There is no any Repo match the OS."
    exit 1
fi

create_nvidia_repo_opensuse >> $log 2>&1 

begin=$(date '+%s')
install_kernel_devel_opensuse >> $log 2>&1 
if [ $? -ne 0 ]; then
    exit 1
fi

end=$(date '+%s')
time_kernel=$((end-begin))
echo "******install kernel-devel begin time: $begin, end time: $end, use time: $time_kernel s" >> $log 2>&1

begin_driver=$(date '+%s')
install_nvidia_driver_suse >> $log 2>&1 
if [ $? -ne 0 ]; then
    echo "error: driver install fail!!!" >> $log 2>&1
    exit 1
fi

end_driver=$(date '+%s')
time_driver=$((end_driver-begin_driver))
echo "******install driver begin time: $begin_driver, end time: $end_driver,  use time: $time_driver s" >> $log 2>&1

install_nvidia_cuda_suse >> $log 2>&1 
if [ $? -ne 0 ]; then
    echo "error: cuda install fail!!!" >> $log 2>&1
    exit 1
fi

echo "******install kernel-devel use time $time_kernel s" >> $log 2>&1
echo "******install nvidia driver use time $time_driver s" >> $log 2>&1
echo "******install nvidia cuda use time $time_cuda s" >> $log 2>&1

echo "add auto enable Persistence Mode when start vm..."  >> $log 2>&1
enable_pm

echo "reboot......"  >> $log 2>&1
reboot
