# Nvidia CUDA toolkit and driver support #
------------------------------------------
Nvidia cuda toolkit and driver automatically install with cloud-init user-data.

Install CUDA and cuDNN on Red Hat
http://kehang.github.io/tools/2017/03/31/install-CUDA-cuDNN-on-Red-Hat/

#### Nvidia cuda toolkit and driver supporting with the OS verison:

#### Centos7.x | RHEL7.x | EulerOS2.x - cuda*driver
  - {9.1.85}*{390.46}
  - {9.0.176}*{390.46，384.125，384.111}
  - {8.0.61}*{390.46，384.125，384.111}

#### Centos6.x | RHEL6.x - cuda*driver
  - {9.1.85}*{390.46}
  - {9.0.176}*{390.46，384.125，384.111}
  - {8.0.61}*{390.46，384.125，384.111}

#### Ubuntu16.04 - cuda*driver
  - {9.1.85}*{390.46}
  - {9.0.176}*{390.46，384.125，384.111}
  - {8.0.61}*{390.46，384.125，384.111}

#### Ubuntu14.04 - cuda*driver
  - {8.0.61}*{384.111，384.66}

#### OpenSUSE42.2 - cuda*driver
  - {9.0.176}*{384.145，396.66}

#### OpenSUSE42.3 - cuda*driver
  - {9.1.85}*{396.44，390.30}
  - {9.2.148}*{396.44，390.30}

#### Windows Server 2008 R2 x86_64-cuda*driver:
  - {8.0.61}*{385.08，386.45，391.29，398.75}
  - {8.0.44}*{385.08，386.45，391.29，398.75}
  - {7.5.18}*{385.08，386.45，391.29，398.75}

#### Windows Server 2012 R2 x86_64-cuda*driver:
  - {9.2.148}*{385.08，386.45，391.29，398.75}
  - {9.1.85}*{385.08，386.45，391.29，398.75}
  - {9.0.176}*{385.08，386.45，391.29，398.75}

#### Windows Server 2016 x86_64-cuda*driver:
  - {9.2.148}*{385.08，386.45，391.29，398.75}
  - {9.1.85}*{385.08，386.45，391.29，398.75}
  - {9.0.176}*{385.08，386.45，391.29，398.75}
 
CUDA+Driver install script for Linux：
https://github.com/archerslaw/nvidia-cuda/tree/master/script/linux/
	
CentOS  ====> cloudinit-centos-cuda-driver.sh
EulerOS ====> cloudinit-euleros-cuda-driver.sh
OpenSUSE====> cloudinit-opensuse-cuda-driver.sh
RHEL    ====> cloudinit-rhel-cuda-driver.sh
Ubuntu  ====> cloudinit-ubuntu-cuda-driver.sh

#### Results for Widows2k8R2:
![image](https://github.com/archerslaw/nvidia-cuda/blob/master/windows2k8r2-nvidia-cuda-driver-install-result.JPG)
