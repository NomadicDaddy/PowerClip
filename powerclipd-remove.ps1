# end task
schtasks.exe /End /TN powerclipd

# remove scheduled task
schtasks.exe /Delete /TN powerclipd

# delete powerclipd from your profile directory
if (Test-Path -Path "$($env:USERPROFILE)\powerclipd.ps1") {
	Remove-Item -Path "$($env:USERPROFILE)\powerclipd.ps1"
}
