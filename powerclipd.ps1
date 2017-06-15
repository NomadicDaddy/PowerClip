<#
.SYNOPSIS
	Monitors and stores text clipboard entries.
.PARAMETER Path
	Path to powerclip store. Defaults to your home path.
.PARAMETER Limit
	Clips to store. Defaults to 100.
.PARAMETER Force
	Used on initial startup to ignore leftover lock file, if present.
.PARAMETER Reinitialize
	Reinitialize the clipboard cache.
.NOTES
	01/18/2017	pbeazley	Initial release.
	01/25/2017	pbeazley	Added -Reinitialize.
#>
[cmdletbinding(SupportsShouldProcess=$true)]
Param(
	[Parameter(Mandatory = $false, Position = 0)]
		[string]$Path = "$env:USERPROFILE",
	[Parameter(Mandatory = $false, Position = 1)]
		[int]$Limit = 100,
	[Parameter(Mandatory = $false, Position = 2)]
		[Switch]$Force,
	[Parameter(Mandatory = $false, Position = 3)]
		[Switch]$Reinitialize
)

$RunMarker = "$Path/powerclip.lck"
$ClipStore = "$Path/powerclip.psd1"
$ClipArray = @()

# run once
if ($Force -and (Test-Path -Path $RunMarker -PathType 'Leaf')) {
	Remove-Item -Path $RunMarker -Force
}
if (Test-Path -Path $RunMarker) {
	Write-Output 'PowerClip is already running. You may also use the Force.'
	exit 1
} else {
	Write-Output "$PID" | Out-File $RunMarker
}

# reinitialize
if ($Reinitialize -eq $true -and (Test-Path -Path $ClipStore)) {
	Remove-Item -Path $ClipStore -Force
}

# import clips from persisted storage
if (Test-Path -Path $ClipStore -PathType 'Leaf') {
	$ClipArray = Get-Content -Path $ClipStore
}

# monitor clipboard forever
try {
	while($true) {

	# check for clipboard changes
		if (-not $PreviousClip) { $PreviousClip = '' }
		if ($CurrentClip -and $ClipArray -notcontains $CurrentClip) {

			Write-Debug "$CurrentClip"

			# add current clipboard contents, retain up to cliplimit
			$ClipArray += $CurrentClip
			if ($ClipArray.Count -ge $Limit) {
				$ClipArray = $ClipArray[1..$Limit]
			}

			# write clips to persistent storage
			$ClipArray | Out-File -FilePath $ClipStore

		}

		# pause before cycling
		Start-Sleep -Milliseconds 500

		# get current clipboard contents
		$PreviousClip = $CurrentClip
		try {
			$CurrentClip = Get-Clipboard -Format Text -TextFormatType Text
			$CurrentClip = $CurrentClip.TrimEnd()
		}
		catch {
			$CurrentClip = Get-Clipboard -Format FileDropList
		}
		finally {
			$CurrentClip = ConvertTo-Json -InputObject $CurrentClip -Compress
		}

	}
}
catch {}
finally {
	if (Test-Path -Path $RunMarker -PathType 'Leaf') {
		Remove-Item -Path $RunMarker -Force
		exit 0
	}
}
