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

Function Set-RemoteDesktopConfig 

{Param ([switch]$LowSecurity, [switch]$disable) 
 if ($Disable) {
       set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'`
                        -name "fDenyTSConnections" -Value 1 -erroraction silentlycontinue 
       if (-not $?) {new-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' `
                                      -name "fDenyTSConnections"  -Value 1 -PropertyType dword }
       set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' `
                        -name "UserAuthentication" -Value 1 -erroraction silentlycontinue
      if (-not $?) {new-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' 
                                      -name "UserAuthentication" -Value 1 -PropertyType dword} 
     } 
else {
       set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' `
                        -name "fDenyTSConnections" -Value 0 -erroraction silentlycontinue
        if (-not $?) {new-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' `
                                      -name "fDenyTSConnections" -Value 0 -PropertyType dword } 
       if ($LowSecurity) {
           set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'`
                                               -name "UserAuthentication" -Value 0 -erroraction silentlycontinue 
        if (-not $?) {new-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'`
                                          -name "UserAuthentication" -Value 0 -PropertyType dword}
        }
    }
}