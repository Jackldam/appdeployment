<#
.SYNOPSIS
    This script creates an AppInfo.json file for the Deployment-Application.ps1 to use to build Name and versions.
.DESCRIPTION
    n/a
.EXAMPLE
    PS C:\> & "Update-AppInfo.ps1"
    File Created "C:\AppInfo.json"
.INPUTS
    n/a
.OUTPUTS
    Path to the AppInfo.json File
.NOTES
    n/a
#>
[CmdletBinding()]
param (

)

$Parent = $PSScriptRoot

#Test if Application name is not to long for SG Creation icm with Naming convention.
$FullAppName = (Split-Path -Path:$Parent -Leaf)
$AppNameLength = $FullAppName.Length - 44
If ( $AppNameLength -gt 0){
    throw "Applicationname `"$FullAppName`" Contains `"$AppNameLength`" to many characters"
}

do {
    $i = Read-Host -Prompt:"Add path and version detection? y/N"
    $i
}
while (($i -ne "n") -and ($i -ne "y") -and ($i -ne ""))

switch ($i) {
    "y" { $InstallPath = $true }
    "n" { $InstallPath = $false }
    Default { $InstallPath = $false }
}

do {
    $i = Read-Host -Prompt:"Is this application required for OS Deployment? y/N"
    $i
}
while (($i -ne "n") -and ($i -ne "y") -and ($i -ne ""))

switch ($i) {
    "y" { $DeploymentType = "OSD" }
    "n" { $DeploymentType = "SD" }
    Default { $DeploymentType = "SD" }
}

function Select-FileGUI {
    [CmdletBinding()]
    param (
    )
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = "C:\" }
    $null = $FileBrowser.ShowDialog()
    $FileBrowser.FileName
}

try {
    if ($InstallPath) { 
        $InstallationPath = $(Select-FileGUI -ErrorAction:Stop)
        $FileVersion = (Get-ItemProperty -Path:$InstallationPath -ErrorAction:Stop).VersionInfo.FileVersion
        $FileVersion = $FileVersion.Replace(",", ".")
        $FileVersion = $FileVersion.Replace(" ", "")
    }
}
catch {
    $_.exception.message
}

$AppInfo = $null
$FolderSplit = (Split-Path -Path:$Parent -Leaf).Split("_")
$AppInfo += [PSCustomObject]@{
    'appVendor'      = $($FolderSplit)[0]
    'appName'        = $($FolderSplit)[1]
    'appVersion'     = $($FolderSplit)[2]
    'DeploymentType' = $DeploymentType
    'ModifiedBy'     = "$($env:USERDOMAIN)\$($Env:USERNAME)"
    'LastUpdate'     = $(Get-Date -Format "yyyy/MM/dd HH:mm").Replace("-", "/")
    'InstallPath'    = if ([bool]$InstallationPath) { $InstallationPath }else { "" }
    'FileVersion'    = if ([bool]$FileVersion) { $FileVersion }else { "" }
}
$AppInfo | ConvertTo-Json | Set-Content -Path:"$Parent\AppInfo.json" -Force
Write-Host "File Created `"$Parent\AppInfo.json`"" -ForegroundColor:Yellow

. "$PSScriptRoot\Set-ApplicationControl.ps1"