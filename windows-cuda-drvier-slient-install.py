rem cmd

echo set cuda_url="%mirrorsurl%/win2012r2/cuda/cuda_9.2.148_windows.exe">C:\nvidia-download.py
echo set driver_url="%mirrorsurl%/win2012r2/driver/398.75-tesla-desktop-winserver2008-2012r2-64bit-international.exe">>C:\nvidia-download.py
echo set mirrorsurl="http://mirrors.myhuaweicloud.com/ecs/windows/exe">>C:\nvidia-download.py
echo set Cloudbase-Init-Url="C:\Program Files\Cloudbase Solutions\Cloudbase-Init">>C:\nvidia-download.py
echo import requests>>C:\nvidia-download.py
echo def nvidia_download(file_url, localfile_name):>>C:\nvidia-download.py
echo     r = requests.get(file_url, stream=True)>>C:\nvidia-download.py
echo     with open(localfile_name, "wb") as downloadfile:>>C:\nvidia-download.py
echo 	       for chunk in r.iter_content(chunk_size=10240):>>C:\nvidia-download.py
echo  		       if chunk:>>C:\nvidia-download.py
echo  			         downloadfile.write(chunk)>>C:\nvidia-download.py
echo nvidia_download(cuda_url, "C:\\nvidia_cuda.exe")>>C:\nvidia-download.py
echo nvidia_download(driver_url, "C:\\nvidia_driver.exe")>>C:\nvidia-download.py

echo %date:~0,4%-%date:~5,2%-%date:~8,2%%time% Logs: Download nvidia cuda and driver package.>C:\nvidia_install_log.txt
"%Cloudbase-Init-Url%\Python\python.exe" C:\nvidia-download.py>>C:\nvidia_install_log.txt

echo "rem cmd">"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "echo %date:~0,4%-%date:~5,2%-%date:~8,2%%time% Logs: Install nvidia driver package.>>C:\nvidia_install_log.txt">>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "start /wait C:\nvidia_driver.exe -s>>C:\nvidia_install_log.txt>>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "ping 127.0.0.1 -n 1 >nul>>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "echo %date:~0,4%-%date:~5,2%-%date:~8,2%%time% Logs: Install nvidia cuda package.>>C:\nvidia_install_log.txt>>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "start /wait C:\nvidia_cuda.exe -s>>C:\nvidia_install_log.txt>>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "ping 127.0.0.1 -n 1 >nul>>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "echo %date:~0,4%-%date:~5,2%-%date:~8,2%%time% Logs: Install nvidia driver and cuda package success.>>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "echo %date:~0,4%-%date:~5,2%-%date:~8,2%%time% Logs: Remove nvidia cuda and driver echo package.>>C:\nvidia_install_log.txt>>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "del /a/f >>C:\nvidia_install_log.txt>>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "echo %date:~0,4%-%date:~5,2%-%date:~8,2%%time% Logs: Remove nvidia-download.py script.>>C:\nvidia_install_log.txt">>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "del /a/f C:\nvidia-download.py">>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "echo %date:~0,4%-%date:~5,2%-%date:~8,2%%time% Logs: Remove nvidia cuda package.>>C:\nvidia_install_log.txt">>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "del /a/f C:\nvidia_cuda.exe>>C:\nvidia_install_log.txt">>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "echo %date:~0,4%-%date:~5,2%-%date:~8,2%%time% Logs: Remove nvidia driver package.>>C:\nvidia_install_log.txt">>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "del /a/f C:\nvidia_driver.exe>>C:\nvidia_install_log.txt">>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
echo "exit 0">>"%Cloudbase-Init-Url%"\LocalScripts\nvidia-install.cmd
exit 0
