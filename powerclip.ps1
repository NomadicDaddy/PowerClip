<#
.SYNOPSIS
	Retrieves stored text clipboard entries.
.DESCRIPTION
	Select from past clipboard entries (text) stored by powerclipd and puts it on your current clipboard.
.PARAMETER Path
	Path to powerclip store. Defaults to your home path.
.EXAMPLE
	.\powerclip.ps1
.NOTES
	01/18/2017	lordbeazley		Initial release.
	01/23/2017	lordbeazley		Reversing the array so most recent clips are on top.
	07/11/2018	lordbeazley		Tidying up.
#>
[CmdletBinding(SupportsShouldProcess = $false, PositionalBinding = $false, ConfirmImpact = 'Low')]
Param(
	[Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
		[string]$Path = $env:USERPROFILE
)

$ClipStore = "$($Path)\powerclip.psd1"
$ClipArray = @()

# import clips from persisted storage
if (Test-Path -Path $ClipStore -PathType Leaf) {
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
