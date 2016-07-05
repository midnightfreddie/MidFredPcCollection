

function Test-MfPcConnection {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$ComputerName
    )
    $ComputerName | ForEach-Object {
        $Status = $null
        $Ping = Get-CimInstance -ClassName Win32_PingStatus -Filter "Address='$_'"
        #$Ping
        Switch ($Ping.StatusCode) {
            $null { $Status = "DNS name not found"; break }
            0 { $Status = "Success"; break }
            11001 { $Status = "Buffer Too Small"; break }
            11002 { $Status = "Destination Net Unreachable"; break }
            11003 { $Status = "Destination Host Unreachable"; break }
            11004 { $Status = "Destination Protocol Unreachable"; break }
            11005 { $Status = "Destination Port Unreachable"; break }
            11006 { $Status = "No Resources"; break }
            11007 { $Status = "Bad Option"; break }
            11008 { $Status = "Hardware Error"; break }
            11009 { $Status = "Packet Too Big"; break }
            11010 { $Status = "Request Timed Out"; break }
            11011 { $Status = "Bad Request"; break }
            11012 { $Status = "Bad Route"; break }
            11013 { $Status = "TimeToLive Expired Transit"; break }
            11014 { $Status = "TimeToLive Expired Reassembly"; break }
            11015 { $Status = "Parameter Problem"; break }
            11016 { $Status = "Source Quench"; break }
            11017 { $Status = "Option Too Big"; break }
            11018 { $Status = "Bad Destination"; break }
            11032 { $Status = "Negotiating IPSEC"; break }
            11050 { $Status = "General Failure"; break }
            default { $Status = "Ping FAIL" }
        }
        New-Object psobject -Property ([ordered]@{
            ComputerName = $_
            IpAddress = $Ping.ProtocolAddress
            PingStatusCode = $Ping.StatusCode
            PingResult = $Status
            PingTime = $Ping.ResponseTime
        })
    }
}