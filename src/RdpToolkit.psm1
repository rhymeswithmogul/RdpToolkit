<#
	Part of module 'RdpToolkit'

	RdpToolkit is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as published
	by the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	RdpToolkit is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with RdpToolkit.  If not, see <https://www.gnu.org/licenses/>.
#>

Function New-RdcFile {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[Alias('New-RdpFile')]
	Param(
		[Parameter(Mandatory, Position=0)]
		[Alias('File', 'RdcFile', 'RdpFile')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('\.rdp$')]
		[IO.FileInfo] $Path,

		[Parameter(Mandatory, Position=1, ValueFromPipelineByPropertyName)]
		[Alias('DnsHostName', 'HostName', 'IPAddress', 'Name', 'RdSessionHostName', 'ServerName')]
		[ValidateNotNullOrEmpty()]
		[String] $ComputerName,

		[Alias('AlternateFullAddress')]
		[String] $AlternateComputerName,

		[Alias('User')]
		[String] $UserName,

		[Alias('Domain')]
		[String] $DomainName,

		[Uri] $GatewayServerName,

		[Switch] $UseLoggedOnUserCredentials,

		[ValidateSet('*', 'AudioCapture', 'Cameras', 'Clipboard', 'Drives', 'PnPDevices', 'Printers', 'SerialPorts', 'SmartCards', 'UsbDevices')]
		[String[]] $Redirect = @('AudioCapture', 'Cameras', 'Clipboard', 'Drives', 'PnPDevices', 'Printers', 'SerialPorts', 'UsbDevices'),

		[Alias('Drives')]
		[ValidatePattern('(DynamicDrives|[A-Za-z]:?)')]
		[String[]] $DrivesToRedirect,

		[Switch] $SingleScreen,

		[Switch] $Force,

		[Switch] $Sign,

		[Switch] $PassThru
	)

	$RdpFileContents = [String[]]@(
		"full address:s:$ComputerName",
		'singlemoninwindowedmode:i:1'
	)
	Write-Debug -Message "Computer name = $ComputerName"
	Write-Debug -Message 'Single monitor in windowed mode = yes'

	If ($null -ne $AlternateComputerName) {
		# Per Microsoft, this parameter "[s]pecifies an alternate [name or IP
		# address] of the remote computer that you want to connect to."
		Write-Debug -Message "Alternate full address = $AlternateComputerName"
		$RdpFileContents += "alternate full address:s:$AlternateComputerName"
	}
	
	If ($null -ne $UserName) {
		# Specifies the name of the user account that will be used to sign in to
		# the remote computer.
		Write-Debug -Message "User name = $UserName"
		$RdpFileContents += "username:s:$UserName"
	}
	If ($null -ne $DomainName) {
		# Specifies the name of the domain in which the user account that will
		# be used to sign in to the remote computer is located.
		Write-Debug -Message "Domain name = $DomainName"
		$RdpFileContents += "domain:s:$DomainName"
	}
	If ($null -ne $GatewayServerName) {
		# Specifies the RD Gateway host name.
		Write-Debug -Message "Gateway server name = $GatewayServerName"
		$RdpFileContents += "gatewayhostname:s:$GatewayServerName"

		# Specifies when to use an RD Gateway for the connection.
		# 0 = Never.  1 = Always.  2 = If needed.  3 = Default.
		# 4 = Never, and bypass local addresses.
		Write-Debug -Message 'Gateway usage method = 2'
		$RdpFileContents += 'gatewayusagemethod:i:2'

		# Specifies whether to use default RD Gateway settings.
		# 0 = Default profile mode.  1 = Explicit settings
		Write-Debug -Message 'Gateway profile usage method = 1'
		$RdpFileContents += 'gatewayprofileusagemethod:i:1'

		# Determines whether a user's credentials are saved and used for both
		# the RD Gateway and the remote computer.
		Write-Debug -Message 'Use same credentials for gateway and PC = yes'
		$RdpFileContents += 'promptcredentialonce:i:1'

		If ($UseLoggedOnUserCredentials) {
			# Specifies the RD Gateway authentication method.
			# 0 = NTLM.  1 = Smart card.  2 = Logged-on user credentials
			# 3 = Basic.  4 = Let user select later.  5 = Cookie.
			Write-Debug -Message 'Gateway credentials = logged on user'
			$RdpFileContents += 'gatewaycredentialssource:i:2'
		} Else {
			Write-Debug -Message 'Gateway credentials = specify'
		}
	}

	Switch -RegEx ($Redirect) {
		# Redirect microphones.
		'\*|AudioCapture' {
			Write-Debug -Message 'Redirected devices += microphones'
			$RdpFileContents += 'audiocapturemode:i:1'
		}

		# Redirect all cameras.
		'\*|Cameras' {
			Write-Debug -Message 'Redirected devices += cameras (all)'
			$RdpFileContents += 'camerastoredirect:s:*'
		}

		# Redirect clipboard.
		'\*|Clipboard' {
			Write-Debug -Message 'Redirect clipboard = 1'
			$RdpFileContents += 'redirectclipboard:i:1'
		}

		# Redirect all drives (default), or only certain ones.
		'\*|Drives' {
			If ($null -eq $DrivesToRedirect) {
				Write-Debug -Message 'Redirected devices += drives (all)'
				$RdpFileContents += 'drivestoredirect:s:*'
			} Else {
				Write-Debug -Message "Redirected devices += drives $($DrivesToRedirect -Join ', ')"
				$drives = [String[]]@()
				$DrivesToRedirect | ForEach-Object {
					If ($_.Length -eq 1) {
						$drives += "$($_.ToUpper()):"
					} Else {
						$drives += $_
					}
				}
				$RdpFileContents += "drivestoredirect:s:$($drives -Join ';')"
			}
		}

		# Redirect Plug and Play devices.
		'\*|PnPDevices' {
			Write-Debug -Message 'Redirected devices += devices (all)'
			$RdpFileContents += 'devicestoredirect:s:*'
		}

		# Redirect printers.
		'\*|Printers' {
			Write-Debug -Message 'Redirected devices += printers'
			$RdpFileContents += 'redirectprinters:i:1'
		}

		# Redirect serial ports.
		'\*|SerialPorts' {
			Write-Debug -Message 'Redirected devices += COM: ports'
			$RdpFileContents += 'redirectcomports:i:1'
		}

		# Redirect smart cards and Windows Hello for Business tokens.
		'\*|SmartCards' {
			Write-Debug -Message 'Redirected devices += smart cards and Windows Hello for Business'
			$RdpFileContents += 'redirectsmartcards:i:1'
		}

		# Redirect USB devices.
		'\*|UsbDevices' {
			Write-Debug -Message 'Redirected devices += USB devices (all)'
			$RdpFileContents += 'usbdevicestoredirect:s:*'
		}

		default {
			Write-Warning -Message "The redirection item $_ was not recognized and will be ignored."
		}
	}
	# Disable smart card redirection unless the user has explicitly asked for
	# it.  Windows Hello and Hello for Business devices tend to be redirected
	# then, which are usually not supported for Remote Desktop authentication.
	If ($RdpFileContents -NotContains 'redirectsmartcards:i:1') {
		$RdpFileContents += 'redirectsmartcards:i:0'
	}

	# Determines whether the remote session will use one or multiple displays
	# from the local computer.
	If ($SingleScreen) {
		Write-Debug -Message 'Multi-monitor support = off'
		$RdpFileContents += 'use multimon:i:0'
	} Else {
		Write-Debug -Message 'Multi-monitor support = on'
		$RdpFileContents += 'use multimon:i:1'
	}

	Write-Debug -Message 'Saving the .rdp file'
	$SetContentParameters = @{
		'Confirm' = $false
		'Encoding' = 'UTF8'
		'Path' = $Path
		'WhatIf' = $false
	}

	$FileExists = Test-Path -Path $Path -PathType Leaf
	If ($FileExists) {
		If ($Force -or $PSCmdlet.ShouldProcess($Path, 'Overwrite')) {
			$RdpFileContents | Sort-Object | Set-Content @SetContentParameters -Force
		}
	}
	Else {
		$RdpFileContents | Sort-Object | Set-Content @SetContentParameters
	}

	If ($Sign) {
		Write-Debug -Message 'Applying a digital signature to the .rdp file'
		Try {
			# Only pass through -WhatIf if the file already existed and the user
			# specified -WhatIf.  In all other cases, this is either a new file,
			# or the user did not specify -WhatIf.
			Add-RdcFileSignature -Files $Path -Confirm:$false -WhatIf:($WhatIfPreference -and $FileExists)
		}
		Catch {
			Write-Warning -Message 'The .rdp file could not be signed due to an error.'
		}
	}

	If ($PassThru) {
		Return (Get-File -Path $Path)
	}
}

Function Remove-RdcFileSignature {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
	[OutputType([void])]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[Alias('File', 'Files', 'RdcFile', 'RdcFiles')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern("\.rdp$")]
		[IO.FileInfo[]] $Path,

		[Switch] $KeepBlankLines
	)

	Process {
		# The nested loops allow this cmdlet to operate on wildcards.
		ForEach ($Argument in $Path) {
			ForEach ($File in (Get-Item $Argument)) {
				$content = Get-Content -Path $File
				If ($PSCmdlet.ShouldProcess($File, 'Remove signature'))
				{
					If (-Not $KeepBlankLines) {
						$content = ($content | Where-Object {$_.trim() -ne ""})
					}
					$content = ($content | Select-String -NotMatch -Pattern '^sign(ature|scope):*')
					Set-Content -Path $File -Value $content -Force
				}
			}
		}
	}
}

Function Add-RdcFileSignature {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
	[OutputType([void])]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern("\.rdp$")]
		[IO.FileInfo[]] $Files,

		[Alias('Certificate', 'Thumbprint')]
		[AllowNull()]
		[String] $CertificateThumbprint = $null,

		[IO.FileInfo] $PathToRDPSign = (Join-Path -Path $env:WinDir -ChildPath 'System32' -AdditionalChildPath 'rdpsign.exe')
	)

	Begin {
		If (-Not $IsWindows) {
			Throw [PlatformNotSupportedException]::new('Signing .rdp files can only be done under Microsoft Windows.')
		}

		# If the user specified a certificate's thumbprint, we'll use that one.
		# Otherwise, call Get-CodeSigningCertificates to pick one automatically.
		If ("" -eq $CertificateThumbprint) {
			$CertificateThumbprint = Get-CodeSigningCertificate
		}
		Write-Verbose -Message "Signing with the certificate $CertificateThumbprint."
	}

	Process {
		# The nested loops allow this cmdlet to operate on wildcards.
		ForEach ($Argument in $Files) {
			ForEach ($File in (Get-Item $Argument)) {
				$File = Get-Item $File
				Write-Verbose "Signing the file $($File.Name)"

				If ($PSCmdlet.ShouldProcess($File, 'Add digital signature')) {
					$result = Invoke-RdpSign -Thumbprint $CertificateThumbprint -File $File -PathToRDPSign $PathToRDPSign
					If ($result -eq 0) {
						Write-Information "Signed $($File.Name)"
					} Else {
						Write-Warning "Did not sign the file $($File.Name)."
					}
				}
			}
		}
	}
}

Function Get-CodeSigningCertificate {
	[OutputType([String])]
	[CmdletBinding()]
	[Alias('Get-CodeSigningCertificate')]
	Param()

	$Thumbprint = $null
	$Certificates = Get-ChildItem (Join-Path -Path 'Cert:' -ChildPath 'CurrentUser' -AdditionalChildPath 'My') -CodeSigning -ErrorAction Stop `
					  | Where-Object {$_.NotBefore -le (Get-Date) -and $_.NotAfter -ge (Get-Date)}

	If ($Certificates.Count -gt 0) {
		$Thumbprint = $Certificates | Select-Object -First 1 -ExpandProperty Thumbprint
		Write-Verbose "Using the certificate with thumbprint $Thumbprint."
		Write-Debug ($Certificates | Select-Object -First 1 -ExpandProperty Thumbprint)
	} Else {
		Throw [PowerShell.Commands.CertificateNotFoundException]::new('A valid code signing certificate could not be found.')
	}
	Return $Thumbprint
}

Function Invoke-RdpSign {
	[OutputType([bool])]
	Param(
		[Parameter(Mandatory, Position=0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern("\.rdp$")]
		[IO.FileInfo] $File,

		[ValidateNotNullOrEmpty()]
		[String] $Thumbprint,

		[IO.FileInfo] $PathToRDPSign = (Join-Path -Path $env:WinDir -ChildPath 'System32' -AdditionalChildPath 'rdpsign.exe')
	)

	If (Test-Path -Path $PathToRDPSign -PathType Leaf) {
		$output = Start-Process -FilePath $PathToRDPSign -ArgumentList @("/sha256 $Thumbprint", "`"$($File.FullName)`"") -PassThru -Wait -WindowStyle Hidden | Out-Null
		Return ($output.ExitCode -eq 0)
	} Else {
		Throw [IO.FileNotFoundException]::new("rdpsign was not found at $PathToRdpSign")
	}
}
