---
external help file: RdpToolkit-help.xml
Module Name: RdpToolkit
online version: https://github.com/rhymeswithmogul/RdpToolkit/blob/main/man/en-US/Add-RdcFileSignature.md
schema: 2.0.0
---

# Add-RdcFileSignature

## SYNOPSIS
Signs a Remote Desktop Connection file.

## SYNTAX

```
Add-RdcFileSignature [-Files] <FileInfo[]> [-CertificateThumbprint <String>] [-PathToRDPSign <FileInfo>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will sign a Remote Desktop Connection (.rdp) file with a digital signature, by using an already-installed code signing certificate.  This will reduce the number of warnings that the user sees, unless the file is modified.

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-RdcFileSignature yourcomputer.rdp
```

This will sign the file "yourcomputer.rdp" with the first available code signing certificate.

## PARAMETERS

### -CertificateThumbprint
Rather than have the .NET runtime select a code signing certificate for you, you may also specify the SHA-256 thumbprint of your certificate.  This is only needed if you have more than one non-expired code signing certificate installed on your computer.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Certificate, Thumbprint

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Files
One or more Remote Desktop Connection (.rdp) files to be signed.

```yaml
Type: FileInfo[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PathToRDPSign
By default, rdpsign.exe is located at C:\Windows\System32\rdpsign.exe.  If your copy of rdpsign.exe is located somewhere else, or if you are using a third-party tool compatible with its syntax, specify its path here.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ${env:WinDir}\System32\rdpsign.exe
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
The cmdlet is run, but the RDC file is neither signed nor modified.

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

### System.IO.FileInfo[]
You may pass one or more .rdp files on the pipeline.

## OUTPUTS

### void
This command produces no output.

## NOTES
Remote Desktop Connection files do not support signature timestamping.  This means that if your code signing certificate or a certificate in the chain expires or is revoked, the .rdp file will become unusable!

## RELATED LINKS

[about_RdpToolkit]()
[Remove-RdcFileSignature]()
[New-RdcFile]()