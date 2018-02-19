
# Module file : C:\Windows\System32\WindowsPowerShell\v1.0\Modules\BasicConfiguration

Import-Module BasicConfiguration
Import-LocalizedData -BaseDirectory Z:\Script\Basic-Configuration-Windows-Server -FileName Data.psd1 -BindingVariable "data"

$stateComputername = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Expand Name

$Logfile = $data.Logfile
Write-Output($Logfile)

if ($data.ComputerName.CompareTo($stateComputername) ) {

    LogWrite $Logfile "Computer Name unchanged"

}
else {

    try {
        Rename-Computer -NewName $computerName -LocalCredential Administrateur -Restart
        LogWrite $Logfile "Computer Name changed"
    }
    catch {
        LogWrite $Logfile "Error : Computer Name unchanged"
    }

}

