Import-Module $PSScriptRoot\MidFredPcCollection -Force

$PCNames = Import-Csv .\PcList.csv |
    Select-Object -ExpandProperty PcName

Test-MfPcConnection -ComputerName $PCNames |
    Get-MfPcNbtStat |
    Export-Csv -NoTypeInformation -Path "OutFile.csv"
