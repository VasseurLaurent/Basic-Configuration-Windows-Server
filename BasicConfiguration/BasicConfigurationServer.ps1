
# Module file : C:\Windows\System32\WindowsPowerShell\v1.0\Modules\BasicConfiguration

Import-Module BasicConfiguration
Import-LocalizedData -BaseDirectory Z:\Script\Basic-Configuration-Windows-Server -FileName Data.psd1 -BindingVariable "data"


 #Initialize LogFile

 InitializeLog $data.Logfile

# Configure network interface 

$stateIpAdress = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet0 | Select-Object -Expand IpAddress 

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

# Remote Desktop Connection

if (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server') {
    try {
        Set-RemoteDesktopConfig
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
        LogWrite $data.LogFile "RDP configured"
    }
    catch {
        LogWrite $data.LogFile "ERROR : RDP no configured"
    }
}
else {
    LogWrite $data.LogFile "RDP Already configured"
}

# Name server

$stateComputername = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Expand Name

if ($data.ComputerName -eq ($stateComputername)) {

    LogWrite $data.Logfile "Computer Name unchanged"

}
else {

    try {
        Rename-Computer -NewName $data.ComputerName -LocalCredential Administrateur -Restart
        LogWrite $data.Logfile "Computer Name changed"
    }
    catch {
        LogWrite $data.Logfile "Error : Computer Name unchanged"
    }

}

# End script 

EndLog $data.LogFile