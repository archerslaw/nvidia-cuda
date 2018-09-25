rem cmd

set PATH="C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python"
echo import requests >C:\nvidia-cuda-download.py
echo file_url = "http://mirrors.myhuaweicloud.com/ecs/windows/exe/win2008r2/cuda/cuda_8.0.61_windows.exe" >>C:\nvidia-cuda-download.py
echo r = requests.get(file_url, stream=True) >>C:\nvidia-cuda-download.py
echo with open("C:\cuda_8.0.61_windows.exe", "wb") as downloadfile: >>C:\nvidia-cuda-download.py
echo     for chunk in r.iter_content(chunk_size=1024): >>C:\nvidia-cuda-download.py
echo         if chunk: >>C:\nvidia-cuda-download.py
echo             downloadfile.write(chunk) >>C:\nvidia-cuda-download.py
python C:\nvidia-cuda-download.py
start /wait C:\cuda_8.0.61_windows.exe /s /v
  
echo import requests >C:\nvidia-driver-download.py
echo file_url = "http://mirrors.myhuaweicloud.com/ecs/windows/exe/win2008r2/driver/398.75-tesla-desktop-winserver2008-2012r2-64bit-international.exe" >>C:\nvidia-driver-download.py
echo r = requests.get(file_url, stream=True) >>C:\nvidia-driver-download.py
echo with open("C:\398.75-tesla-desktop-winserver2008-2012r2-64bit-international.exe", "wb") as downloadfile: >>C:\nvidia-driver-download.py
echo     for chunk in r.iter_content(chunk_size=1024): >>C:\nvidia-driver-download.py
echo         if chunk: >>C:\nvidia-driver-download.py
echo             downloadfile.write(chunk) >>C:\nvidia-driver-download.py
python C:\nvidia-driver-download.py
start /wait C:\398.75-tesla-desktop-winserver2008-2012r2-64bit-international.exe /s /v
start /wait C:\NVIDIA\398.75\international\setup.exe /s /v

rem "remove the file"
del C:\cuda_8.0.61_windows.exe
del C:\398.75-tesla-desktop-winserver2008-2012r2-64bit-international.exe
del C:\nvidia-cuda-download.py
del /a/f C:\nvidia-driver-download.py
rmdir /s/q C:\NVIDIA

rem "install nvidia cuda and driver success"
exit 0
