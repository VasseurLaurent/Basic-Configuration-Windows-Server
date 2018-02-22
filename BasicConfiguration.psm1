# Module file : C:\Windows\System32\WindowsPowerShell\v1.0\Modules\BasicConfiguration
Function LogWrite()
{
    Param
    (
        [string]$Logfile,
        [string]$Logstring
    )
   Add-Content -Path $Logfile -Value ((Get-Date).ToString() + " : "+ $Logstring)
}

Function InitializeLog()
{
    Param
    (
        [string]$Logfile
    )
    Write-Output $Logfile
    LogWrite $Logfile "==================================== EXECUTING SCRIPT =============================================="
}

Function EndLog()
{
    Param
    (
        [string]$LogFile
    )
    LogWrite $LogFile "===================================== END SCRIPT ===================================================="
}