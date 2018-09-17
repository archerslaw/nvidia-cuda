rem cmd
set PATH="C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python"

echo import requests >C:\download.py

echo file_url = "http://119.3.60.246/ecs/windows/exe/win2008r2/cuda/cuda_8.0.61_windows.exe" >>C:\download.py

echo r = requests.get(file_url, stream=True) >>C:\download.py

echo with open("python.pdf", "wb") as pdf: >>C:\download.py
echo     for chunk in r.iter_content(chunk_size=1024): >>C:\download.py
echo         if chunk: >>C:\download.py
echo             pdf.write(chunk) >>C:\download.py

python C:\download.py
