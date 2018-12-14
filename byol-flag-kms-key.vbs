Dim Count:Count = 0
Set http=CreateObject("Msxml2.ServerXMLHTTP")
http.setTimeouts 5000, 5000, 10000, 10000
For i = 1 To 5
    On Error Resume Next
        Err.Clear
        http.open "GET","http://169.254.169.254/openstack/latest/meta_data.json",False
        http.send
        If Err.Number <> 0 Then
            Err.Clear
        End If
    If http.status < 300 Then
	Exit For
    Else
        wscript.sleep 5000
    End If
Count = Count + 1
Next
text_metadata=http.responsetext
byol_str="""BYOL"": ""true"""
mypos=InStr(1,text_metadata,byol_str,1)
If mypos > 0 Then
    'skip Windows activation - byol option found'
    wscript.sleep 1000
Else
    'start Windows activation - byol option not found'
    Set WshShell=CreateObject("WScript.Shell")
    WshShell.Run "cmd.exe /c cscript /nologo %windir%/system32/slmgr.vbs /skms xx.xx.xx.xx", 0, True
    WshShell.Run "cmd.exe /c cscript /nologo %windir%/system32/slmgr.vbs /ato", 0, True
    'Windows activation success'
End If
