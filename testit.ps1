Import-Module $PSScriptRoot\MidFredPcCollection -Force

# $PingResult = Test-MfPcConnection -ComputerName @("molehill", "lenny", "winvr", "crookshanks", "nopcbythisname")
# 
# $PingResult

Test-MfPcConnection -ComputerName @("freddie", "molehill") | #, "nopcbythisname") |
    Get-MfPcNbtStat