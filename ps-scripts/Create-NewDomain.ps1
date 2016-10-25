# Windows PowerShell script for AD DS Deployment
param($u,$p,$d)

# Domain Variables:
$DomainName = $d
$DomainMode = "Win2012"
$ForestMode = "Win2012"

$u = "$domainname\$u"

#AD Admin Password
$admpw = "V@grant1" | ConvertTo-SecureString -AsPlainText -Force

# Path Variables
$DatabasePath = "C:\Windows\NTDS"
$LogPath = "C:\Windows\NTDS"
$SysvolPath = "C:\Windows\SYSVOL"

# Installing needed roles/feautres
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

#Promote Domain Controller and create a new domain in new forest.
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath $DatabasePath `
-LogPath $LogPath `
-SysvolPath $SysvolPath `
-DomainName $DomainName `
-DomainMode $DomainMode `
-ForestMode $ForestMode `
-InstallDns:$true `
-NoRebootOnCompletion:$true `
-SafeModeAdministratorPassword $admpw `
-Force:$true

# Really ensure that DNS Server is installed
Install-WindowsFeature "DNS" -IncludeManagementTools
# Install DHCP on RDC
Install-WindowsFeature "DHCP" -IncludeManagementTools

#Disable NLA otherwise RDP stops working
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)
