Dim Count:Count = 0
Set http=CreateObject("Msxml2.ServerXMLHTTP")
http.setTimeouts 5000, 5000, 10000, 10000
For i = 1 To 5
    On Error Resume Next
        Err.Clear
        http.open "GET","http://169.254.169.254/latest/meta-data/hostname",False
        http.send
        If Err.Number <> 0 Then
            Err.Clear
        End If
    If http.status < 300 Then
	Exit For
    Else
        wscript.sleep 200 
    End If
Count = Count + 1
Next
text_hostname=http.responsetext
If len(text_hostname) > 0 Then
    hostname=split(text_hostname,".novalocal")
    str_hostname=hostname(0)
    If len(str_hostname) > 14 Then
        str_computername=left(str_hostname,14)
    Else
        str_computername=str_hostname
    End If
    Set OperationRegistry=WScript.CreateObject("WScript.Shell")
    OperationRegistry.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\ComputerName",str_computername,"REG_SZ"
    OperationRegistry.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName\ComputerName",str_computername,"REG_SZ"
    OperationRegistry.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Hostname",str_hostname,"REG_SZ"
    OperationRegistry.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\NV Hostname",str_hostname,"REG_SZ"
End If
