# Post-Sysprep-Windows.ps1
# run server configuration with cloudbase-init localscript
$kms="100.125.XX.XX"
$log="C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\post-sysprep-ps.log"
# Get-Content $log -wait

function get-metadata {

    $metadata =$null
    $webclient = new-object system.net.webclient;
    $url = 'http://169.254.169.254/openstack/latest/meta_data.json'

    do {
        "read meta data from : $url" | Write-verbose
        try {
            $metadata =  $webclient.DownloadString($url) 
        } catch {
            'ERROR: get-metadata failed - do a retry '| Out-File -FilePath $log -Append
        }
        if (!$metadata) {sleep 5}
    }
    until ($metadata -match 'name')

    $metadataHashtable = Invoke-Expression $metadata.replace('[','@(').replace(']',')').replace('{','@{').replace(', ',';').replace(': ','=')
    return $metadataHashtable 
}

$meta = get-metadata
$meta | Out-File -FilePath $log -Append

if ($meta.meta.byol -match 'true') {
    'remove Windows activation - byol option found' | Out-File -FilePath $log -Append
    cscript c:\windows\system32\slmgr.vbs /upk | Out-File -FilePath $log -Append
    cscript c:\windows\system32\slmgr.vbs /ckms | Out-File -FilePath $log -Append
    'finished removing Windows activation' | Out-File -FilePath $log -Append
} else {
    'start Windows activation' | Out-File -FilePath $log -Append
    'start Windows activation' | Write-Host
    cscript c:\windows\system32\slmgr.vbs /skms $kms | Out-File -FilePath $log -Append
    cscript c:\windows\system32\slmgr.vbs /ato | Out-File -FilePath $log -Append
    'finished Windows activation' | Out-File -FilePath $log -Append
}
