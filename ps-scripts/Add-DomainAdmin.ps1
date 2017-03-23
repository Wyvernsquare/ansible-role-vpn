# Windows PowerShell script for AD DS Deployment
param($u,$p,$a,$w,$d)


New-ADUser `
 -Name $a `
 -Path  "OU=Users,DC=$d" `
 -SamAccountName  "$a" `
 -DisplayName "$a" `
 -AccountPassword (ConvertTo-SecureString "$w" -AsPlainText -Force) `
 -ChangePasswordAtLogon $false  `
 -Enabled $true
Add-ADGroupMember "Domain Admins" "$a"
