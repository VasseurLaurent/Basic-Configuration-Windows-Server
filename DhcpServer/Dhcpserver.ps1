
Import-LocalizedData -BaseDirectory Z:\Script\Powershell-Configuration\DhcpServer -FileName Data.psd1 -BindingVariable "data"
Import-Module BasicConfiguration

 #Initialize LogFile

 InitializeLog $data.Logfile

if ((Get-WindowsFeature -Name dhcp | Select-Object -Expand "InstallState") -eq "Available") {
    
    try {
        # Service installation and security group creation 

        Install-WindowsFeature DHCP -IncludeManagementTools 
        netsh dhcp add securitygroups
        Restart-Service DhcpServer
        Set-ItemProperty -Path 'registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12' -Name ConfigurationState -Value 2

        # Range creation
        Add-DhcpServerv4Scope -name $data.NameRange -StartRange $data.StartRange -EndRange $data.EndRange -SubnetMask $data.SubnetMaskRange -State $data.StateRange

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

EndLog $data.LogFile