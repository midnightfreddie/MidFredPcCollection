Import-Module $PSScriptRoot\MidFredPcCollection -Force

$PCNames = Get-Content .\PcList.txt

Test-MfPcConnection -ComputerName $PCNames |
    Get-MfPcNbtStat |
    Export-Csv -NoTypeInformation -Path "OutFile.csv"
