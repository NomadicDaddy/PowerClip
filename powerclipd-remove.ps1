# relaunch as admin if needed
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath $(Get-Process -Id $pid).Path -Verb RunAs -ArgumentList "-File ""$($MyInvocation.MyCommand.Path)"""
	break
}

try {

	# end task
	schtasks.exe /End /TN powerclipd

	# remove scheduled task
	schtasks.exe /Delete /TN powerclipd

	# delete powerclipd from your profile directory
	if (Test-Path -Path "$($env:USERPROFILE)\powerclipd.ps1") {
		Remove-Item -Path "$($env:USERPROFILE)\powerclipd.ps1"
	}

}
catch {
	$_.Exception
}

Write-Host 'Press any key to continue...';[Void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
