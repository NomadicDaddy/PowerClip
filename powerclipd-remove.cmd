@echo off

:: end task
schtasks.exe /End /TN powerclipd

:: remove scheduled task
schtasks.exe /Delete /TN powerclipd

:: delete powerclipd from your profile directory
if exist %USERPROFILE%\powerclipd.ps1 del %USERPROFILE%\powerclipd.ps1
