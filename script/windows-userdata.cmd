rem cmd

set driver_version=398.75
set cuda_version=9.2.148
set os_version=win2016
set repo_url=http://mirrors.myhuaweicloud.com

echo cuda_url="%repo_url%/ecs/windows/exe/%os_version%/cuda/cuda_%cuda_version%_windows.exe">C:\nvidia-download.py
echo driver_url="%repo_url%/ecs/windows/exe/%os_version%/driver/%driver_version%-tesla-desktop-winserver-international.exe">>C:\nvidia-download.py
echo script_url="http://mirrors.myhuaweicloud.com/ecs/windows/script/nvidia-auto-install.cmd">>C:\nvidia-download.py
rem ===================================
echo import requests>>C:\nvidia-download.py
echo def nvidia_download(file_url, localfile_name):>>C:\nvidia-download.py
echo     r = requests.get(file_url, stream=True)>>C:\nvidia-download.py
echo     with open(localfile_name, 'wb') as downloadfile:>>C:\nvidia-download.py
echo         for chunk in r.iter_content(chunk_size=10240):>>C:\nvidia-download.py
echo             if chunk:>>C:\nvidia-download.py
echo                 downloadfile.write(chunk)>>C:\nvidia-download.py
echo                 downloadfile.flush()>>C:\nvidia-download.py
rem ===================================
echo nvidia_download(script_url, 'C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\LocalScripts\\nvidia-auto-install.cmd')>>C:\nvidia-download.py
echo nvidia_download(cuda_url, 'C:\\nvidia_cuda.exe')>>C:\nvidia-download.py
echo nvidia_download(driver_url, 'C:\\nvidia_driver.exe')>>C:\nvidia-download.py
rem ===================================
echo %DATE% %TIME% Logs: Start to download nvidia cuda and driver package>C:\nvidia_install_log.txt
"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\python.exe" C:\nvidia-download.py>>C:\nvidia_install_log.txt
echo %DATE% %TIME% Logs: Download nvidia cuda and driver package success>>C:\nvidia_install_log.txt
rem ===================================
exit 0
