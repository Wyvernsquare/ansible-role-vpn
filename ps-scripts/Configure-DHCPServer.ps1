param($gw,$dns,$netmask,$masklength,$svrstart,$svrend,$domain)

$DNSDomain=$domain
$DNSServerIP=$dns
$DHCPServerIP=$dns
$StartRange=$svrstart
$EndRange=$svrend
$Subnet=$netmask
$Router=$gw
 
cmd.exe /c "netsh dhcp add securitygroups"
Restart-service dhcpserver
Add-DhcpServerInDC -DnsName $Env:COMPUTERNAME
Set-ItemProperty -Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
Add-DhcpServerV4Scope -Name "DHCP Scope" -StartRange $StartRange -EndRange $EndRange -SubnetMask $Subnet
Set-DhcpServerV4OptionValue -DnsDomain $DNSDomain -DnsServer $DNSServerIP -Router $Router 
Set-DhcpServerv4Scope -ScopeId $DHCPServerIP -LeaseDuration 1.00:00:00

Add-DhcpServerInDC -DNSName $domain -IPAddress $dns
