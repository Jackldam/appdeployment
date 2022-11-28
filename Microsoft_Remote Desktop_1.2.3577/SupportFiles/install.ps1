#* PRE-INSTALLATION
[string]$installPhase = 'Pre-Installation'
#region

## Show Progress Message (with the default message)

## <Perform Pre-Installation tasks here>

#* Microsoft Visual C++ 2015-2022 Redistributable (x64)
#region

Show-InstallationProgress -StatusMessage $("Test if Microsoft Visual C++ 2015-2022 Redistributable (x64) is already installed") -WindowLocation BottomRight
if (!(Get-InstalledApplication -WildCard "Microsoft Visual C++ 2015-2022 Redistributable (x64)*")) {
    
    Show-InstallationProgress -StatusMessage $("Downloading Microsoft Visual C++ 2015-2022 Redistributable (x64)") -WindowLocation BottomRight
    Get-OnlineFile -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -Destination "$dirfiles\vc_redist.x64.exe"
    
    Show-InstallationProgress -StatusMessage $("Installing Microsoft Visual C++ 2015-2022 Redistributable (x64)") -WindowLocation BottomRight
    execute-process -path "$dirfiles\vc_redist.x64.exe" -Parameters "/Install /quiet /norestart" -CreateNoWindow
}
#endregion


#endregion

#* INSTALLATION
[string]$installPhase = 'Installation'
#region


## <Perform Installation tasks here>

#* Install as User
#region\
if (!(Test-Path "$dirfiles\RemoteDesktop_x64.msi")) {
    $DownloadUri = (Invoke-WebRequest -UseBasicParsing -Uri "https://learn.microsoft.com/en-us/azure/virtual-desktop/users/connect-windows?tabs=subscribe").links | Where-Object outerHTML -Like "*Windows 64-bit*"
    Show-InstallationProgress -StatusMessage $("Downloading Remote Desktop client") -WindowLocation BottomRight
    Get-OnlineFile -Uri $DownloadUri.href -Destination "$dirfiles\RemoteDesktop_x64.msi"
}

Show-InstallationProgress -StatusMessage $("Installing {0} {1} {2}" -f $FullAppName) -WindowLocation BottomRight
$Params = @{
    UserName   = "$($LoggedOnUserSessions.NTAccount)" #Currently logged on user
    Path       = "C:\Windows\System32\msiexec.exe"
    Parameters = "/i `"$dirfiles\RemoteDesktop_x64.msi`" /qn ALLUSERS=2 PRIVILEGED=1 RemoteAdminTS=1 AdminUser=1 INSTALLLEVEL=1 MSIINSTALLPERUSER=1"
    RunLevel   = "LeastPrivilege"
    Wait       = $true
}
Execute-ProcessAsUser @Params
#endregion

<#
Start-Process -FilePath "msiexec.exe" `
    -ArgumentList "/i `"C:\Users\jackdenouden\Downloads\RemoteDesktop_1.2.3577.0_x64.msi`" /log `"C:\Users\jackdenouden\Downloads\RD.log`" /qn ALLUSERS=2 Privileged=1" `
    -Wait
#>

#endregion

#* POST-INSTALLATION
[string]$installPhase = 'Post-Installation'
#region

## <Perform Post-Installation tasks here>

#endregion
