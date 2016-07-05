

function Test-MfPcConnection {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$ComputerName
    )
    $ComputerName | ForEach-Object {
        $Ping = Get-CimInstance -ClassName Win32_PingStatus -Filter "Address='$_'"
        $Ping
    }
}