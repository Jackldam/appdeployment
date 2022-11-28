#* PRE-UNINSTALLATION
[string]$installPhase = 'Pre-Uninstallation'
#region

## Show Progress Message (with the default message)

# <Perform Pre-Uninstallation tasks here>

#endregion

#* UNINSTALLATION
[string]$installPhase = 'Uninstallation'
#region

# <Perform Uninstallation tasks here>
if (!(Test-Path "$dirfiles\RemoteDesktop_x64.msi")) {
    $DownloadUri = (Invoke-WebRequest -UseBasicParsing -Uri "https://learn.microsoft.com/en-us/azure/virtual-desktop/users/connect-windows?tabs=subscribe").links | Where-Object outerHTML -Like "*Windows 64-bit*"
    Show-InstallationProgress -StatusMessage $("Downloading Remote Desktop client") -WindowLocation BottomRight
    Get-OnlineFile -Uri $DownloadUri.href -Destination "$dirfiles\RemoteDesktop_x64.msi"
}

#* Uninstall as User
#region
Show-InstallationProgress -StatusMessage $("Uninstall {0} {1} {2}" -f $FullAppName) -WindowLocation BottomRight
$Params = @{
    UserName   = "$($LoggedOnUserSessions.NTAccount)" #Currently logged on user
    Path       = "C:\Windows\System32\msiexec.exe"
    Parameters = "/x `"$dirfiles\RemoteDesktop_x64.msi`" /qn ALLUSERS=2 PRIVILEGED=1 RemoteAdminTS=1 AdminUser=1 INSTALLLEVEL=1 MSIINSTALLPERUSER=1"
    RunLevel   = "LeastPrivilege"
    Wait       = $true
}
Execute-ProcessAsUser @Params
#endregion

#endregion

#* POST-UNINSTALLATION
[string]$installPhase = 'Post-Uninstallation'
#region

## <Perform Post-Uninstallation tasks here>

#endregion
