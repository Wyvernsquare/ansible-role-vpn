param($gw,$dns,$netmask,$masklength,$domain)

$DNSDomain=$domain
$DNSServerIP=$dns
$DHCPServerIP=$dns
$StartRange=$svrstart
$EndRange=$svrend
$Subnet=$netmask
$Router=$gw

$dnsext=".dns"
$zonefile=$domain -join $dnsext
$octet1,$octet2,$octet3,$octet4 = $gw.split('.',3)
$nwid=$octet1 + "." + $octet2 + "." + $octet3 + "." + "0" + "/" + $masklength
$reversezone=$octet3 + "." + $octet2 + "." + $octet1 + ".in-addr.arpa.dns"

$octet1,$octet2,$octet3,$octet4 = $gw.split('.',3)

Add-DnsServerPrimaryZone -Name $domain -ZoneFile $zonefile
Add-DnsServerPrimaryZone -NetworkID $nwid -ZoneFile $reversezone
Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru
Add-DnsServerForwarder -IPAddress 8.8.4.4 -PassThru

