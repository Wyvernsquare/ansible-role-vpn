param($gw,$dns,$masklength)

$ipv4adr = (get-netipaddress -InterfaceAlias 'Ethernet 2' -AddressFamily IPv4).IPAddress
$ipv4gw = $gw
$prefix = $masklength
$alias = "Ethernet 2"
$ipv4dns1 = $dns

#remove-netipaddress -InterfaceAlias 'Ethernet 2' -AddressFamily IPv4 -Confirm:$false
# $netadapter = Get-NetAdapter -Name 'Ethernet 2';
#New-NetIPAddress -AddressFamily IPv4 -IPAddress $ipv4adr -DefaultGateway $ipv4gw -PrefixLength $prefix -Confirm:$false -InterfaceAlias $alias

#$ipv4dns1 = (get-netipaddress -InterfaceAlias 'Ethernet 2' -AddressFamily IPv4).IPAddress
#$ipv4dns2 = "192.168.90.110" #uncomment and set for two DNS servers

Get-DnsClientServerAddress -InterfaceAlias $alias
Set-DNSClientServerAddress -InterfaceAlias $alias -ServerAddresses $dns

#Set-DNSClientServerAddress -InterfaceAlias $alias -ServerAddresses 192.168.1.11
# Set-DNSClientServerAddress -InterfaceAlias $alias -ServerAddresses ("$ipv4dns1","$ipv4dns2") #use this for two dns servers
