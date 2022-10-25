---
external help file: RdpToolkit-help.xml
Module Name: RdpToolkit
online version: https://github.com/rhymeswithmogul/RdpToolkit/blob/main/man/en-US/New-RdcFile.md
schema: 2.0.0
---

# New-RdcFile

## SYNOPSIS
Creates a new Remote Desktop Connection (.rdp) file.

## SYNTAX

```
New-RdcFile [-Path] <FileInfo> [-ComputerName] <String> [-AlternateComputerName <String>] [-UserName <String>]
 [-DomainName <String>] [-GatewayServerName <Uri>] [-UseLoggedOnUserCredentials] [-Redirect <String[]>]
 [-DrivesToRedirect <String[]>] [-SingleScreen] [-Force] [-Sign] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will programatically generate a new Remote Desktop Connection (.rdp) file with the parameters you specify.  The only required parameter is the computer name.

## EXAMPLES

### Example 1: Basic usage
```powershell
PS C:\> New-RdcFile 'JohnDoe.rdp' -ComputerName 'JohnDoe-PC.internal.contoso.com'
```

Creates a new Remote Desktop Connection file named JohnDoe.rdp that will connect to the computer named JohnDoe-PC.internal.contoso.com.

### Example 2: Using the pipeline
```powershell
PS C:\> Get-ADComputer "JaneDoe-PC" | New-RdcFile -Path 'JaneDoe.rdp'
```

Creates a new Remote Desktop Connection file named JaneDoe.rdp that will connect to the computer named JaneDoe-PC.

### Example 3: Supplying a username in UPN format
```powershell
PS C:\> New-RdcFile 'Server1.rdp' 'Server1' -UserName 'Administrator@ad.fabrikam.com' -GatewayServerName 'remote.fabrikam.com' -Force
```

Creates or replaces the file Server1.rdp, that will connect to the computer named Server1 through the Remote Desktop Gateway server remote.fabrikam.com.  The default username will be Administrator@ad.fabrikam.com.

### Example 4: Supplying a username in SAM format
```powershell
PS C:\> New-RdcFile 'Server1.rdp' 'Server1' -DomainName 'FABRIKAM' -UserName 'Administrator' -GatewayServerName 'remote.fabrikam.com' -Force
```

Creates or replaces the file Server1.rdp, that will connect to the computer named Server1 through the Remote Desktop Gateway server remote.fabrikam.com.  The default username will be FABRIKAM\Administrator.

Alternatively, you could omit the DomainName parameter and only use -UserName 'FABRIKAM\Administrator'.

### Example 5: Redirecting items, such as drives
```powershell
PS C:\> New-RdpFile -RdpFile 'Computer1.rdp' -Name 'Computer1.home.arpa' -Redirect 'Drives','Printers' -DrivesToRedirect 'A:','C:','DynamicDrives'
```

Creates the file Computer1.rdp that connects to Computer1.home.arpa.  Printers will be redirected.  Drives A:, C:, and drives plugged in later will be redirected, too.

Oh, and New-RdpFile is an alias for this cmdlet, so don't worry if you mis-type it.

### Example 6: Digital signatures
```powershell
PS C:\> New-RdcFile -File 'Bank Server.rdp' -Name 'SecureServer1.woodgrovebank.com' -GatewayServerName 'remote.woodgrovebank.com' -Sign
```

Creates the file Bank Server.rdp that connects to the server SecureServer1.woodgrovebank.com through the RD Gateway server remote.woodgrovebank.com.  In addition, the file is digitally signed to prevent tampering.  The .rdp file is signed with the first available and valid code signing certificate in the current user's Personal store.

## PARAMETERS

### -ComputerName
The name of the computer.  You may specify only the computer name, or you may specify the fully-qualified domain name.  This is the only required parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DnsHostName, HostName, IPAddress, Name, RdSessionHostName, ServerName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AlternateComputerName
The alternate name of the computer.  You may specify a computer name or an IP address.  If this specified, the -ComputerName parameter will be ignored by many clients.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AlternateFullAddress

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainName
You may specify the default Active Directory Domain Services domain name.  Alternatively, you may use a user principal name in the UserName parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Domain

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DrivesToRedirect
Specify which drives will be redirected into the remote session.  Specify drive letters in Windows format (that is, a letter and a colon), separated by comma.  To redirect drives that are plugged in after the session is started, include "DynamicDrives" in the list.

If the -Redirect parameter includes "Drives" and this parameter is omitted, then all drives will be redirected into the remote session.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Drives

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
If the .rdp file exists, overwrite it without confirmation.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GatewayServerName
If you must use a Remote Desktop Gateway server, specify its fully-qualified domain name.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return an \[IO.FileSystemObject\] pointing to the new .rdp file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{ Fill Path Description }}

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases: File, RdcFile, RdpFile

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Redirect
Remote Desktop Connection can redirect some client devices into the remote session.  You may specify the value * to redirect all items, or specify which items you would like redirected:

 - AudioCapture (microphones)
 - Cameras
 - Clipboard
 - Drives (all drives, plus drives plugged in later.  To override this, use the -DrivesToRedirect parameter)
 - PnPDevices
 - Printers
 - SerialPorts
 - SmartCards (and Windows Hello for Business)
 - UsbDevices

 If this parameter is omitted or null, some things will be redirected.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: *, AudioCapture, Cameras, Clipboard, Drives, PnPDevices, Printers, SerialPorts, SmartCards, UsbDevices

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sign
Digitally sign the .rdp file to prevent tampering.  Note that .rdp files do not support timestamping, so the file will become unusable after the signing certificate expires.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SingleScreen
By default, Remote Desktop sessions will use all available monitors.  To limit Remote Desktop to a single screen, use this parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseLoggedOnUserCredentials
By default, Remote Desktop Connection will ask the user for their credentials.  To use the current user's username and password, specify this.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
Provide a default username.  You may use any format accepted by the remote computer, including just a username, a username with the NetBIOS domain name (e.g., DOMAIN\username), or a user principal name (e.g., username@domain.local).

```yaml
Type: String
Parameter Sets: (All)
Aliases: User

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is run, but the .rdp file is not generated.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### ADComputer
Optionally, a single Object with a Name parameter may be passed to this cmdlet.  Ideally, this object would be the output of Get-ADComputer.

## OUTPUTS

### System.IO.FileSystemInfo
If the -PassThru option is specified, this cmdlet will return a FileSystemInfo object, as if you had run Get-Item on the generated .rdp file.

## NOTES
This cmdlet does not support all of the options supported by a .rdp file.  This module is being actively developed, so check for updates often.

## RELATED LINKS

[about_RdpToolkit]()
[Get-ADComputer]()
[Add-RdcFileSignature]()
[Remove-RdcFileSignature]()