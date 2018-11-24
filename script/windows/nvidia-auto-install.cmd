rem cmd
echo %DATE% %TIME% Logs: Begin to import the nvidia certificate>>C:\nvidia_install_log.txt
certutil -addstore -f "TrustedPublisher" C:\NvidiaDisplay.cer>>C:\nvidia_install_log.txt
if %errorlevel%==0 (
    echo %DATE% %TIME% Logs: End to import the nvidia certificate>>C:\nvidia_install_log.txt
    del /a/f C:\NvidiaDisplay.cer>>C:\nvidia_install_log.txt
    echo %DATE% %TIME% Logs: Remove the nvidia certificate>>C:\nvidia_install_log.txt
) else (
    echo %DATE% %TIME% Logs: Fail to import the nvidia certificate, you could install the C:\nvidia_driver.exe and C:\nvidia_cuda.exe manually>>C:\nvidia_install_log.txt
    del /a/f C:\nvidia-download.py>>C:\nvidia_install_log.txt
    echo %DATE% %TIME% Logs: Remove nvidia-download.py script>>C:\nvidia_install_log.txt
    exit
)
ping 127.0.0.1 -n 1 >nul
echo %DATE% %TIME% Logs: Begin to auto install nvidia driver package>>C:\nvidia_install_log.txt
start /high /wait C:\nvidia_driver.exe -s>>C:\nvidia_install_log.txt
if %errorlevel%==0 (
    echo %DATE% %TIME% Logs: End to auto install nvidia driver package>>C:\nvidia_install_log.txt
    del /a/f C:\nvidia_driver.exe>>C:\nvidia_install_log.txt
    echo %DATE% %TIME% Logs: Remove nvidia driver package>>C:\nvidia_install_log.txt
) else (
    echo %DATE% %TIME% Logs: Fail to auto install nvidia driver package, you could install the C:\nvidia_driver.exe and C:\nvidia_cuda.exe manually>>C:\nvidia_install_log.txt
    del /a/f C:\nvidia-download.py>>C:\nvidia_install_log.txt
    echo %DATE% %TIME% Logs: Remove nvidia-download.py script>>C:\nvidia_install_log.txt
    exit
)
ping 127.0.0.1 -n 1 >nul
echo %DATE% %TIME% Logs: Begin to auto install nvidia cuda package>>C:\nvidia_install_log.txt
start /high /wait C:\nvidia_cuda.exe -s>>C:\nvidia_install_log.txt
if %errorlevel%==0 (
    echo %DATE% %TIME% Logs: End to auto install nvidia cuda package>>C:\nvidia_install_log.txt
    del /a/f C:\nvidia_cuda.exe>>C:\nvidia_install_log.txt
    echo %DATE% %TIME% Logs: Remove nvidia cuda package>>C:\nvidia_install_log.txt
) else (
    echo %DATE% %TIME% Logs: Fail to auto install nvidia cuda package, you could install the C:\nvidia_cuda.exe manually>>C:\nvidia_install_log.txt
)
del /a/f C:\nvidia-download.py>>C:\nvidia_install_log.txt
echo %DATE% %TIME% Logs: Remove nvidia-download.py script>>C:\nvidia_install_log.txt
exit
