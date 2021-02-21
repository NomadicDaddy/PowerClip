# relaunch as admin if needed
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath $(Get-Process -Id $pid).Path -Verb RunAs -ArgumentList "-File ""$($MyInvocation.MyCommand.Path)"""
	break
}

try {

	# copy powerclipd to your profile directory
	Copy-Item -Path '.\powerclipd.ps1' -Destination "$($env:USERPROFILE)\powerclipd.ps1" -Force

	# create scheduled task that executes when you logon
	schtasks.exe /Create /SC ONLOGON /TN powerclipd /TR "$((Get-Process -Id $pid).Path) -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -Command ""%USERPROFILE%\powerclipd.ps1"" -Force"

	# launch now
	schtasks.exe /Run /TN powerclipd

}
catch {
	$_.Exception
}

Write-Host 'Press any key to continue...';[Void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
