# Test-RPCDynamicPorts.ps1

A PowerShell function to check which RPC dynamic ports are listening on a remote Windows machine, and whether they are reachable from the local system. This is useful for network diagnostics, firewall testing, and RPC troubleshooting.

---

## 🔧 Features

- Detects listening TCP ports in the RPC dynamic range (49152–65535)
- Includes well-known ports: 135 (RPC endpoint mapper) and 445 (SMB)
- Tests remote port reachability from your local machine
- Supports optional credential input
- Can be dynamically loaded from GitHub without installation

---

## 📦 Load and Use It Dynamically

You can use this function without downloading or installing anything:

powershell:
$TestRPC = ([ScriptBlock]::Create(((Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Dragan-Ignjic/Delinea_SecretServer_Public/refs/heads/main/Test_Discovery_Ports/Test-RPCDynamicPorts.ps1').Content))); . $TestRPC

Then run the function:
Test-RPCDynamicPorts -ComputerName "TargetServer"

Or with credentials:
$cred = Get-Credential
Test-RPCDynamicPorts -ComputerName "TargetServer" -Credential $cred

## Requirements
- PowerShell 5.1 or newer
- WinRM enabled and accessible on the remote system
- Proper permissions to use Invoke-Command
- Local system must be able to reach the target ports over the network
