rem cmd

set PATH="C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python"
echo import requests >C:\nvidia-download.py
echo file_url = "http://192.168.0.91/ecs/windows/exe/win2008r2/cuda/cuda_8.0.61_windows.exe" >>C:\nvidia-download.py
echo r = requests.get(file_url, stream=True) >>C:\nvidia-download.py
echo with open("C:\cuda_8.0.61_windows.exe", "wb") as downloadfile: >>C:\nvidia-download.py
echo     for chunk in r.iter_content(chunk_size=1024): >>C:\nvidia-download.py
echo         if chunk: >>C:\nvidia-download.py
echo             downloadfile.write(chunk) >>C:\nvidia-download.py
python C:\nvidia-download.py
start /wait C:\cuda_8.0.61_windows.exe /s /v
