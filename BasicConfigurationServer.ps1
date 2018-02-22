
# Module file : C:\Windows\System32\WindowsPowerShell\v1.0\Modules\BasicConfiguration

Import-Module BasicConfiguration
Import-LocalizedData -BaseDirectory Z:\Script\Basic-Configuration-Windows-Server -FileName Data.psd1 -BindingVariable "data"


 #Initialize LogFile

 InitializeLog $data.Logfile

# Configure network interface 

$stateIpAdress = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex 2 | Select-Object -Expand IpAddress 

if ($data.IpAddress -eq ($stateIpAdress) ) {
    LogWrite $data.Logfile "Ip Address unchanged"
}
else {
    try {
        $wmi = Get-WmiObject win32_networkadapterconfiguration -Filter "ipenabled = 'true'"
        $wmi.EnableStatic($data.IpAddress,$data.IpNetmask)
        $wmi.SetGateways($data.IpGateway, 1)
        $wmi.SetDNSServerSearchOrder($data.IpDNS)
        LogWrite $data.Logfile "Ip Address changed"
    }
    catch {
        LogWrite $data.Logfile "Error : IpAddress unchanged"
    }
}



# Enable RDP connection 

if ((Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections -eq 1) {
    LogWrite $data.Logfile "Rdp connection already allowed"
}
elseif ((Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp').UserAuthentication -eq 1){
    LogWrite $data.Logfile "Rdp secured connection already allowed"
}
else {
    try {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1 -ErrorAction SilentlyContinue
        LogWrite $data.Logfile "Rdp configured"
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop" 
        LogWrite $data.Logfile "Firewall rules for RDP configured"
    }
    catch {
        LogWrite $data.Logfile "Error : Rdp not configured"
    }
}

# Name server

$stateComputername = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Expand Name

if ($data.ComputerName -eq ($stateComputername)) {

    LogWrite $data.Logfile "Computer Name unchanged"

}
else {

    try {
        Rename-Computer -NewName $computerName -LocalCredential Administrateur -Restart
        LogWrite $data.Logfile "Computer Name changed"
    }
    catch {
        LogWrite $data.Logfile "Error : Computer Name unchanged"
    }

}

# End script 

EndLog $data.LogFile
