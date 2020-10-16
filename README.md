# RdpToolkit
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](code_of_conduct.md) 
This is a PowerShell module to programatically generate and modify the `.rdp` connection files used by apps that implement Microsoft's Remote Desktop Protocol.  While fairly boring on its own, perhaps you can integrate this module into something of yours.

## Example
One command available in this module is `New-RdcFile`:

```powershell
New-RdcFile -Path 'Work.rdp' -ComputerName 'WorkPC.contoso.local' -UserName 'myaccount@contoso.com' -Redirect Drives,Cameras,AudioCapture -Sign
```

That will create a file in the current folder called `Work.rdp` that will connect you to the computer `WorkPC.contoso.local` with the suggested username myaccount@contoso.com.  Upon successfully connecting, the local computer's cameras, drives, and microphones will be available in the remote session.  The `.rdp` file will also be signed to prevent tampering.