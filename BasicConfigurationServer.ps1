
# Module file : C:\Windows\System32\WindowsPowerShell\v1.0\Modules\BasicConfiguration

Import-Module BasicConfiguration
Import-LocalizedData -BaseDirectory Z:\Script\Basic-Configuration-Windows-Server -FileName Data.psd1 -BindingVariable "data"

$stateComputername = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Expand Name


# Name server
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

