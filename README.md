Introduction
---------------------------------
Creates a working PPTP/L2TP over IPSec working VPN with RADIUS authentication.
Change Vagrantfile to specify settings.

---------------------------------

Requirements
---------------------------------
Install the following packages.

ansible (>= 1.8.x)
vagrant
virtualbox
Make sure 172.31.16.100/16 is not used in your network. If it is, modify the IP addresses in Vagrantfile.
