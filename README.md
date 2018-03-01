# Basic-Configuration-Windows-Server

These script must be located in different part : 

- BasicConfiguration.psm1 : C:\Windows\System32\WindowsPowerShell\v1.0\Modules\BasicConfiguration
- BasicConfigurationServer.ps1 / Data.psd1 : Must be in the same folder. 


This script automatically configure : 
- The network interface 
- Allow RDP Connection
- Name server

A log file is created to follow each task of this script
