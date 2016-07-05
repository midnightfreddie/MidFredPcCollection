$Win32PingStatusCodes = @{
    #$null = "DNS name not found"
    [uint32]0 = "Success"
    [uint32]11001 = "Buffer Too Small"
    [uint32]11002 = "Destination Net Unreachable"
    [uint32]11003 = "Destination Host Unreachable"
    [uint32]11004 = "Destination Protocol Unreachable"
    [uint32]11005 = "Destination Port Unreachable"
    [uint32]11006 = "No Resources"
    [uint32]11007 = "Bad Option"
    [uint32]11008 = "Hardware Error"
    [uint32]11009 = "Packet Too Big"
    [uint32]11010 = "Request Timed Out"
    [uint32]11011 = "Bad Request"
    [uint32]11012 = "Bad Route"
    [uint32]11013 = "TimeToLive Expired Transit"
    [uint32]11014 = "TimeToLive Expired Reassembly"
    [uint32]11015 = "Parameter Problem"
    [uint32]11016 = "Source Quench"
    [uint32]11017 = "Option Too Big"
    [uint32]11018 = "Bad Destination"
    [uint32]11032 = "Negotiating IPSEC"
    [uint32]11050 = "General Failure"
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
            PingResult = if ($Ping.StatusCode -eq $null) { "DNS name not found" } else { $Win32PingStatusCodes[$Ping.StatusCode] }
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