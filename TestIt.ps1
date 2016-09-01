Import-Module $PSScriptRoot\MidFredPcCollection -Force

$PCNames = @(
    "molehill"
    "lenny"
    "winvr"
    "crookshanks"
    "nopcbythisname"
)

Test-MfPcConnection -ComputerName $PCNames |
    Get-MfPcNbtStat |
    Export-Csv -NoTypeInformation -Path "OutFile.csv"
