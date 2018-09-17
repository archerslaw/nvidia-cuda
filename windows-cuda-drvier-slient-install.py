rem cmd

set PATH="C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python"
echo import requests >C:\download.py
echo file_url = "http://192.168.0.91/ecs/windows/exe/win2008r2/cuda/cuda_8.0.61_windows.exe" >>C:\download.py
echo r = requests.get(file_url, stream=True) >>C:\download.py
echo with open("C:\cuda_8.0.61_windows.exe", "wb") as pdf: >>C:\download.py
echo     for chunk in r.iter_content(chunk_size=1024): >>C:\download.py
echo         if chunk: >>C:\download.py
echo             pdf.write(chunk) >>C:\download.py
python C:\download.py
start /wait C:\cuda_8.0.61_windows.exe /s /v
