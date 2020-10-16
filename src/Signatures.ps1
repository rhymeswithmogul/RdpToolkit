<#
	Signature-related functions of module 'RdpToolkit'

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

Function Remove-RdcFileSignature {
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
				If (-Not $KeepBlankLines) {
					$content = ($content | Where-Object {$_.trim() -ne ""})
				}
				$content = ($content | Select-String -NotMatch -Pattern '^sign(ature|scope):*')
				Set-Content -Path $File -Value $content -Force
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
			$CertificateThumbprint = Get-CodeSigningCertificates
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

Function Get-CodeSigningCertificates {
	[OutputType([String])]
	[CmdletBinding()]
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