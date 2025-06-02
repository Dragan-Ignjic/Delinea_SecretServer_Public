<#

NO Creds
Test-RPCDynamicPorts -ComputerName "MyServer01"

With CREDS
$cred = Get-Credential
Test-RPCDynamicPorts -ComputerName "MyServer01" -Credential $cred



#>


function Test-RPCDynamicPorts {
    param (
        [Parameter(Mandatory)]
        [string]$ComputerName,

        [System.Management.Automation.PSCredential]
        $Credential
    )

    # Step 1: Get listening ports on the remote server
    $scriptBlock = {
        $dynamicPorts = Get-NetTCPConnection |
        Where-Object {
            $_.LocalPort -ge 49152 -and $_.LocalPort -le 65535 -and $_.State -eq 'Listen'
        }

        $wellKnownPorts = Get-NetTCPConnection |
        Where-Object {
                ($_.LocalPort -eq 135 -or $_.LocalPort -eq 445) -and $_.State -eq 'Listen'
        }

        $dynamicPorts + $wellKnownPorts | Select-Object -Property LocalAddress, LocalPort, State, OwningProcess
    }

    if ($Credential) {
        $remotePorts = Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -Credential $Credential
    }
    else {
        $remotePorts = Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock
    }

    # Step 2: Test if each port is reachable from the local machine
    foreach ($portInfo in $remotePorts) {
        $port = $portInfo.LocalPort
        $test = Test-NetConnection -ComputerName $ComputerName -Port $port -WarningAction SilentlyContinue

        [PSCustomObject]@{
            ComputerName = $ComputerName
            Port         = $port
            State        = $portInfo.State
            Reachable    = $test.TcpTestSucceeded
        }
    }
}
