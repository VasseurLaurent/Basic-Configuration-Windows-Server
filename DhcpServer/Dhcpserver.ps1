
Import-Module BasicConfiguration

 #Initialize LogFile

$data = Import-PowerShellDataFile -Path .\Data.psd1

 InitializeLog $data.Logfile

if ((Get-WindowsFeature -Name dhcp | Select-Object -Expand "InstallState") -eq "Available") {
    
    try {
        # Service installation and security group creation 

        Install-WindowsFeature DHCP -IncludeManagementTools 
        netsh dhcp add securitygroups
        Restart-Service DhcpServer
        Set-ItemProperty -Path 'registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12' -Name ConfigurationState -Value 2
        
        LogWrite $data.Logfile "DHCP installed and ready to use"
        
    }
    catch {
        LogWrite $data.LogFile "ERROR : DHCP service no installed or configured"
    }
}

elseif((Get-WindowsFeature -Name dhcp | Select-Object -Expand "InstallState") -eq "Installed") {
    LogWrite $data.LogFile "DHCP already setup"
}

else {
    LogWrite $data.Logfile "ERROR : Feature not found"
}

# Range creation
try {
    foreach($range in $data.Range.Values){
        if((Get-DhcpServerv4Scope | Select-Object -Property StartRange | Where-Object {$_.StartRange -eq $data.Range.Range1.StartRange} | Measure-Object | Select-Object -Expand Count) -eq 0){

            Add-DhcpServerv4Scope -name $range.NameRange -StartRange $range.StartRange -EndRange $range.EndRange -SubnetMask $range.SubnetMaskRange -State $range.StateRange
        }
        else {
            LogWrite $data.LogFile ("WARNING : Range " + $data.NameRange + "Already Setup ")
        }
        
    }
}
catch{
    LogWrite $data.Logfile "ERROR : Range not created"
}

EndLog $data.LogFile