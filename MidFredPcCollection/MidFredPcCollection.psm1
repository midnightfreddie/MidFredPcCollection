$Win32PingStatusCodes = @{
    #$null = "DNS name not found"
    0 = "Success"
    11001 = "Buffer Too Small"
    11002 = "Destination Net Unreachable"
    11003 = "Destination Host Unreachable"
    11004 = "Destination Protocol Unreachable"
    11005 = "Destination Port Unreachable"
    11006 = "No Resources"
    11007 = "Bad Option"
    11008 = "Hardware Error"
    11009 = "Packet Too Big"
    11010 = "Request Timed Out"
    11011 = "Bad Request"
    11012 = "Bad Route"
    11013 = "TimeToLive Expired Transit"
    11014 = "TimeToLive Expired Reassembly"
    11015 = "Parameter Problem"
    11016 = "Source Quench"
    11017 = "Option Too Big"
    11018 = "Bad Destination"
    11032 = "Negotiating IPSEC"
    11050 = "General Failure"
}

function Test-MfPcConnection {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$ComputerName
    )
    $ComputerName | ForEach-Object {
        $Ping = Get-CimInstance -ClassName Win32_PingStatus -Filter "Address='$_'"
        New-Object psobject -Property ([ordered]@{
            ComputerName = $_
            IpAddress = $Ping.ProtocolAddress
            PingStatusCode = [int]$Ping.StatusCode
            PingResult = if ($Ping.StatusCode -eq $null) { "DNS name not found" } else { $Win32PingStatusCodes[[int]$Ping.StatusCode] }
            PingTime = $Ping.ResponseTime
        })
    }
}

filter Get-MfPcNbtStat {
    process {
        if ($_.PingStatusCode -eq 0) {
            $NbtstatName = (
                & nbtstat -a $_.ComputerName |
                Select-String "<00>  UNIQUE" |
                Select-Object -First 1
            ).ToString().Split('<')[0].Trim()

        } else {
            $NbtstatName = $null
        }
        $_ | Add-Member -MemberType NoteProperty -Name "NetBiosName" -Value $NbtstatName
        Write-Output $_
    }
}

filter Get-MfPcNbtName {
    process {
        if ($_.PingStatusCode -eq 0) {
            $CimSystem = Get-CimInstance -ClassName CIM_System -ComputerName $_.ComputerName
        } else {
            $CimSystem = $null
        }
        $_ | Add-Member -MemberType NoteProperty -Name "NetBiosName" -Value $CimSystem.Name
        $_ | Add-Member -MemberType NoteProperty -Name "AdDomain" -Value $CimSystem.Domain
        $_ | Add-Member -MemberType NoteProperty -Name "Memory" -Value $CimSystem.TotalPhysicalMemory
        $_ | Add-Member -MemberType NoteProperty -Name "Model" -Value $CimSystem.Model
        $_ | Add-Member -MemberType NoteProperty -Name "Manufacturer" -Value $CimSystem.Manufacturer
        Write-Output $_
    }
}