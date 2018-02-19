
Import-LocalizedData -BaseDirectory Z:\Script  -FileName Data.psd1 -BindingVariable "data"

$stateComputername = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Expand Name
$Logfile = $data.Logfile

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}


if ($data.ComputerName.CompareTo($stateComputername) ) {

    LogWrite("Computer Name unchanged")

}
else {

    try {
        Rename-Computer -NewName $computerName -LocalCredential Administrateur -Restart
        LogWrite("Computer Name changed")
    }
    catch {
        LogWrite("Error : Computer Name unchanged")
    }
    

}

