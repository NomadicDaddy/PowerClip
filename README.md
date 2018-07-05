# PowerClip

Saves all clipboard text, allows selection of previous clips and re-adding them to your clipboard.

*powerclipd* -- constantly running monitor executed on logon
*powerclip*	-- shows your current cache, replaces clipboard with selection

To install, use one of the _-install_ scripts provided.
To remove, use one of the _-remove_ scripts provided.

To use powerclip to show my cache, I have an alias in my profile. Like this:

`Set-Alias -Name pc -Value 'D:\PowerClip\powerclip.ps1'`

You could do the same with a batch file or shortcut on your desktop.

### Educational Usage

This script provides real-world example usage of the following:
- clipboard manipulation
- running PowerShell in the background
- running PowerShell script at startup
- working with JSON data
