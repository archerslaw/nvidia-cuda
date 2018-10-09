'https://www.leavesongs.com/PYTHON/resume-download-from-break-point-tool-by-python.html'
'https://www.jb51.net/article/36613.htm'

'download.vbs:'
'在CMD中输入：cscript.exe download.vbs http://xxxxxxx.exe'

if (lcase(right(wscript.fullname,11))="wscript.exe") then
die("Script host must be CScript.exe.")
end if

if wscript.arguments.count<1 then
die("Usage: cscript webdl.vbs url [filename]")
end if

url=wscript.arguments(0)
if url="" then die("URL can't be null.")
if wscript.arguments.count>1 then
filename=wscript.arguments(1)
else
t=instrrev(url,"/")
if t=0 or t=len(url) then die("Can not get filename to save.")
filename=right(url,len(url)-t)
end if
if not left(url,7)="http://" then url="http://"&url

set fso=wscript.createobject("Scripting.FileSystemObject")
set aso=wscript.createobject("ADODB.Stream")
set http=wscript.createobject("Microsoft.XMLHTTP")

if fso.fileexists(filename) then
start=fso.getfile(filename).size
else
start=0
fso.createtextfile(filename).close
end if

wscript.stdout.write "Connectting..."
current=start
do
http.open "GET",url,true
http.setrequestheader "Range","bytes="&start&"-"&cstr(start+20480)
http.setrequestheader "Content-Type:","application/octet-stream"
http.send

for i=1 to 120
if http.readystate=3 then showplan()
if http.readystate=4 then exit for
wscript.sleep 500
next
if not http.readystate=4 then die("Timeout.")
if http.status>299 then die("Error: "&http.status&" "&http.statustext)
if not http.status=206 then die("Server Not Support Partial Content.")

aso.type=1
aso.open
aso.loadfromfile filename
aso.position=start
aso.write http.responsebody
aso.savetofile filename,2
aso.close

range=http.getresponseheader("Content-Range")
if range="" then die("Can not get range.")
temp=mid(range,instr(range,"-")+1)
current=clng(left(temp,instr(temp,"/")-1))
total=clng(mid(temp,instr(temp,"/")+1))
if total-current=1 then exit do
start=start+20480
loop while true

wscript.echo chr(13)&"Download ("&total&") Done."

function die(msg)
wscript.echo msg
wscript.quit
end function

function showplan()
if i mod 3 = 0 then c="/"
if i mod 3 = 1 then c="-"
if i mod 3 = 2 then c="\"
wscript.stdout.write chr(13)&"Download ("&total&") "&c&chr(8)
end function
