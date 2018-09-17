rem cmd
set PATH=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python

echo import urllib2 >C:\download.py
echo print "downloading with urllib2" >>C:\download.py
echo url = 'http://119.3.60.246/ecs/windows/exe/win2008r2/cuda/cuda_8.0.61_windows.exe' >>C:\download.py
echo f = urllib2.urlopen(url) >>C:\download.py
echo data = f.read() >>C:\download.py
echo with open("C:\cuda_8.0.61_windows.exe", "wb") as code: >>C:\download.py
echo     code.write(data) >>C:\download.py

start python C:\download.py
