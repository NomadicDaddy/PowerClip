<#
.SYNOPSIS
	Retrieves stored text clipboard entries.
.PARAMETER Path
	Path to powerclip store. Defaults to your home path.
.NOTES
	01/18/2017	pbeazley	Initial release.
	01/23/2017	pbeazley	Reversing the array so most recent clips are on top.
#>
[cmdletbinding(SupportsShouldProcess=$true)]
Param(
	[Parameter(Mandatory = $false, Position = 0)]
		[string]$Path = "$env:USERPROFILE"
)

$ClipStore = "$Path/powerclip.psd1"
$ClipArray = @()

# import clips from persisted storage
if (Test-Path -Path $ClipStore -PathType 'Leaf') {
	$ClipArray = Get-Content -Path $ClipStore
	if ($ClipArray) {
		$Export = @()
		[array]::Reverse($ClipArray)
		$ClipArray | Out-GridView -Title 'Select a clip...' -PassThru | ForEach-Object {
			# add selected clip(s) to stack
			$Export += (ConvertFrom-Json -InputObject $_)
		}
		# export stack to clipboard
		$Export | clip
	}
} else {
	Write-Host 'No powerclip store found. Have you run powerclipd?' -ForegroundColor 'Red'
}
