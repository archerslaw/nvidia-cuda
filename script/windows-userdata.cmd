rem cmd

set driver_version={replace_driver_version}
set cuda_version={replace_cuda_version}
set os_version={replace_os_version}
set repo_url={replace_repo_url}

echo cuda_url="%repo_url%/ecs/windows/exe/%os_version%/cuda/cuda_%cuda_version%_windows.exe">C:\nvidia-download.py
echo driver_url="%repo_url%/ecs/windows/exe/%os_version%/driver/%driver_version%-tesla-desktop-winserver-international.exe">>C:\nvidia-download.py
echo script_url="%repo_url%/ecs/windows/script/nvidia-auto-install.cmd">>C:\nvidia-download.py
echo cer_url="%repo_url%/ecs/windows/NvidiaDisplay.cer">>C:\nvidia-download.py
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
echo nvidia_download(cer_url, 'C:\\NvidiaDisplay.cer')>>C:\nvidia-download.py
echo nvidia_download(cuda_url, 'C:\\nvidia_cuda.exe')>>C:\nvidia-download.py
echo nvidia_download(driver_url, 'C:\\nvidia_driver.exe')>>C:\nvidia-download.py
rem ===================================
echo %DATE% %TIME% Logs: Start to download nvidia cuda and driver package>C:\nvidia_install_log.txt
"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\python.exe" C:\nvidia-download.py>>C:\nvidia_install_log.txt
echo %DATE% %TIME% Logs: Download nvidia cuda and driver package>>C:\nvidia_install_log.txt
rem ===================================
exit 0
