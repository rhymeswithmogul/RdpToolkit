<#
	Module manifest for module 'RdpToolkit'

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

@{

# Root module
RootModule = 'src/RdpToolkit.psm1'

# Version number of this module.
<<<<<<< HEAD
ModuleVersion = '1.1'
=======
ModuleVersion = '1.0.1'
>>>>>>> 1e9ec840067eaee606229eda8a26982b7a6b0329

# Supported PSEditions
CompatiblePSEditions = @('Desktop', 'Core')

# ID used to uniquely identify this module
GUID = '5c7916cb-5b36-41a0-9450-57e88eb518a9'

# Author of this module
Author = 'Colin Cogle <colin@colincogle.name>'

# Copyright statement for this module
Copyright = '(c) 2020 Colin Cogle. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Programatically generates Remote Desktop Connection files.'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Scripts to run in the caller's environment.
ScriptsToProcess = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
	'New-RdcFile',
	'Add-RdcFileSignature',
	'Remove-RdcFileSignature'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = ''

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @(
	'New-RdpFile'
)

# List of all files packaged with this module.
# Note that this only includes files needed for production, not for development.
FileList = @(
	'en-US/about_RdpToolkit.help.txt',
	'en-US/RdpToolkit-help.xml',
	'src/RdpToolkit.psm1',
	'ChangeLog',
	'INSTALL',
	'LICENSE',
	'RdpToolkit.code-workspace',
	'RdpToolkit.psd1',
	'README.md'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

	PSData = @{

		# Tags applied to this module. These help with module discovery in online galleries.
		Tags = @('Remote-Desktop', 'RDC', 'RDP', 'mstsc', 'msrdc', 'Terminal-Services', 'rdpsign')

		# A URL to the license for this module.
		LicenseUri = 'https://www.gnu.org/licenses/agpl-3.0.en.html'

		# A URL to the main website for this project.
		ProjectUri = 'https://github.com/rhymeswithmogul/RdpToolkit'

		# A URL to an icon representing this module.
		# IconUri = ''

		# ReleaseNotes of this module
		ReleaseNotes = 'https://github.com/rhymeswithmogul/RdpToolkit/blob/main/ChangeLog'

		# Flag to indicate whether the module requires explicit user acceptance for install/update/save
		RequireLicenseAcceptance = $false

	} # End of PSData hashtable

} # End of PrivateData hashtable

}

