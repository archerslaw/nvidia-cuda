rem cmd

echo cuda_url="http://mirrors.myhuaweicloud.com/ecs/windows/exe/win2012r2/cuda/cuda_9.2.148_windows.exe">C:\nvidia-download.py
echo driver_url="http://mirrors.myhuaweicloud.com/ecs/windows/exe/win2012r2/driver/398.75-tesla-desktop-winserver2008-2012r2-64bit-international.exe">>C:\nvidia-download.py

echo import requests>>C:\nvidia-download.py
echo def nvidia_download(file_url, localfile_name):>>C:\nvidia-download.py
echo     r = requests.get(file_url, stream=True)>>C:\nvidia-download.py
echo     with open(localfile_name, 'wb') as downloadfile:>>C:\nvidia-download.py
echo         for chunk in r.iter_content(chunk_size=10240):>>C:\nvidia-download.py
echo             if chunk:>>C:\nvidia-download.py
echo                 downloadfile.write(chunk)>>C:\nvidia-download.py

echo nvidia_download(cuda_url, 'C:\\nvidia_cuda.exe')>>C:\nvidia-download.py
echo nvidia_download(driver_url, 'C:\\nvidia_driver.exe')>>C:\nvidia-download.py

echo %DATE% %TIME% Logs: Start to download nvidia cuda and driver package>C:\nvidia_install_log.txt
"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\python.exe" C:\nvidia-download.py>>C:\nvidia_install_log.txt
echo %DATE% %TIME% Logs: Download nvidia cuda and driver package success>>C:\nvidia_install_log.txt

echo rem cmd>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
echo echo %%DATE%% %%TIME%% Logs: Install nvidia driver package>>C:\nvidia_install_log.txt>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts""\nvidia-install.cmd
echo start /wait C:\nvidia_driver.exe -s>>C:\nvidia_install_log.txt>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
echo ping 127.0.0.1 -n 1 >nul>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
echo echo %%DATE%% %%TIME%% Logs: Install nvidia cuda package>>C:\nvidia_install_log.txt>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
echo start /wait C:\nvidia_cuda.exe -s>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
echo ping 127.0.0.1 -n 1 >nul>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
echo echo %%DATE%% %%TIME%% Logs: Install nvidia driver and cuda package success>>C:\nvidia_install_log.txt>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd

echo echo %%DATE%% %%TIME%% Logs: Remove nvidia cuda and driver package>>C:\nvidia_install_log.txt>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd

echo del /a/f C:\nvidia-download.py>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
echo echo %%DATE%% %%TIME%% Logs: Remove nvidia-download.py script>>C:\nvidia_install_log.txt

echo del /a/f C:\nvidia_cuda.exe>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
echo echo %%DATE%% %%TIME%% Logs: Remove nvidia cuda package.>>C:\nvidia_install_log.txt>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd

echo del /a/f C:\nvidia_driver.exe>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
echo echo %%DATE%% %%TIME%% Logs: Remove nvidia driver package.>>C:\nvidia_install_log.txt>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd

echo exit 0>>"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts"\nvidia-install.cmd
exit 0
