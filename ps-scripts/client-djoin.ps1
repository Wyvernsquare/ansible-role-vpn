#
# Script: client-djoin.ps1
# Joins clients/servers to a domain
#

param($u,$p,$d)

$domainname = $d
$u = "$domainname\$u"
$computername = $env:computername

$securePassword = ConvertTo-SecureString -String $p -AsPlainText -Force
$psCreds = new-object -typename System.Management.Automation.PSCredential -argumentlist $u, $securePassword

$domainCheck = (Get-WmiObject -Class win32_computersystem).Domain
if (!($domainCheck -eq $domainname)) {
#  Add-Computer -DomainName $domainname -Credential $psCreds -Force
   cmd.exe /c "netdom add /domain:$domainname $computername /userd:$u /passwordd:$p"
  eventcreate /t INFORMATION /ID 1 /L APPLICATION /SO "Ansible-Playbook" /D "joindomain-win: Added to the domain by ansible playbook."
}
