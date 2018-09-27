rem cmd

set PATH="C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python"
echo cuda_url="http://mirrors.myhuaweicloud.com/ecs/windows/exe/win2008r2/cuda/cuda_8.0.61_windows.exe" >C:\nvidia-download.py
echo driver_url="http://mirrors.myhuaweicloud.com/ecs/windows/exe/win2008r2/driver/398.75-tesla-desktop-winserver2008-2012r2-64bit-international.exe" >>C:\nvidia-download.py
echo import requests >>C:\nvidia-download.py
echo def nvidia_download(file_url, localfile_name): >>C:\nvidia-download.py
echo 	r = requests.get(file_url, stream=True) >>C:\nvidia-download.py
echo 	with open(localfile_name, "wb") as downloadfile: >>C:\nvidia-download.py
echo 		for chunk in r.iter_content(chunk_size=10240): >>C:\nvidia-download.py
echo 			if chunk: >>C:\nvidia-download.py
echo 				downloadfile.write(chunk) >>C:\nvidia-download.py
echo nvidia_download(cuda_url, "C:\\nvidia_cuda.exe") >>C:\nvidia-download.py
echo nvidia_download(driver_url, "C:\\nvidia_driver.exe") >>C:\nvidia-download.py
python C:\nvidia-download.py

rem "install nvidia driver"
start /wait C:\nvidia_driver.exe -s
rem "install nvidia cuda"
start /wait C:\nvidia_cuda.exe /s /v

rem "remove the file"
del /a/f C:\nvidia-download.py
del /a/f C:\nvidia_cuda.exe
del /a/f C:\nvidia_driver.exe

rem "install nvidia driver and cuda success"
exit 0
