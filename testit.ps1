Import-Module $PSScriptRoot\MidFredPcCollection -Force

Test-MfPcConnection -ComputerName @("molehill", "lenny", "winvr", "crookshanks")