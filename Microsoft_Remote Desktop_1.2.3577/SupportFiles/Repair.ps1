
#* PRE-REPAIR
[string]$installPhase = 'Pre-Repair'
#region

## Show Progress Message (with the default message)
Show-InstallationProgress -StatusMessage $("Attempting repair {0} {1} {2}" -f $FullAppName) -WindowLocation BottomRight

## <Perform Pre-Repair tasks here>

#endregion

#* REPAIR
[string]$installPhase = 'Repair'
#region

# <Perform Repair tasks here>

#endregion

#* POST-REPAIR
[string]$installPhase = 'Post-Repair'
#region

## <Perform Post-Repair tasks here>

#endregion
