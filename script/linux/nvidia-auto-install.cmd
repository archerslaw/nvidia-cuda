rem cmd
echo %DATE% %TIME% Logs: Try to auto install nvidia cuda and driver package>>C:\nvidia_install_log.txt
start /high /wait C:\nvidia_driver.exe -s>>C:\nvidia_install_log.txt
if %errorlevel% == 0 (
    echo %DATE% %TIME% Logs: Auto install nvidia driver package>>C:\nvidia_install_log.txt
    del /a/f C:\nvidia_cuda.exe>>C:\nvidia_install_log.txt
    echo %DATE% %TIME% Logs: Remove nvidia cuda package>>C:\nvidia_install_log.txt
) else (
    echo %DATE% %TIME% Logs: Fail to auto install nvidia driver package, you could install the C:\nvidia_driver.exe manually>>C:\nvidia_install_log.txt
)
ping 127.0.0.1 -n 1 >nul
start /high /wait C:\nvidia_cuda.exe -s>>C:\nvidia_install_log.txt
if %errorlevel% == 0 (
    echo %DATE% %TIME% Logs: Auto install nvidia cuda package>>C:\nvidia_install_log.txt
    del /a/f C:\nvidia_driver.exe>>C:\nvidia_install_log.txt
    echo %DATE% %TIME% Logs: Remove nvidia driver package>>C:\nvidia_install_log.txt
) else (
    echo %DATE% %TIME% Logs: Fail to auto install nvidia cuda package, you could install the C:\nvidia_cuda.exe manually>>C:\nvidia_install_log.txt
)
del /a/f C:\nvidia-download.py>>C:\nvidia_install_log.txt
echo %DATE% %TIME% Logs: Remove nvidia-download.py script>>C:\nvidia_install_log.txt
exit
