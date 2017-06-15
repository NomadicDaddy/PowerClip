@echo off

:: copy powerclipd to your profile directory
copy .\powerclipd.ps1 %USERPROFILE%\ /Y

:: create scheduled task that executes when you logon
schtasks.exe /Create /SC ONLOGON /TN powerclipd /TR "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File %USERPROFILE%\powerclipd.ps1 -Force"

:: launch now
schtasks.exe /Run /TN powerclipd
