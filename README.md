Introduction
---------------------------------
This project is an example ansible project, demonstrating Windows Active Directory deployment via Ansible and Vagrant.

It will create a private internal network between all the servers, with a working DNS server and fully AD-managed environment.
---------------------------------

Requirements
---------------------------------
Install the following packages.

ansible (>= 1.8.x)
vagrant
virtualbox
python needs to be install as well, then make sure the following libraries are installed: xmltodict, pywinrm
Make sure 192.168.1.0/24 is not used in your network. If it is, modify the IP addresses in Vagrantfile.

Make sure your access line is not pay-as-you-go. The scripts will download a lot of files.
---------------------------------

Installing and Provisioing
---------------------------------
The necessary scripts are included in this project. 

Start your instance by running "vagrant up" and this will download the necessary Windows Server 2012 R2 image and create a total of four servers: server1,server2,server3, and server4 respectively. Please keep in mind that the box image is around 6GB and it WILL take a while to download and provision these boxes.
server1 serves as Domain controller #1,
server2 serves as Domain controller #2,
server3 serves as Windows Server Update Services WSUS server, 
server4 is a sample client server to demonstrate a domain-joined client. It is not particularly configured for anything and can be used for testing roles.

Once vagrant up finishes, it will execute ansible-playbook and run pre-scripts.yml which will configure the four servers to have the needed roles.
Once that is finished, pre-scripts.yml will call post-scripts.yml which will run the remaining tasks to clean up whatever else.

Please be aware that the process, since servers are Windows servers, will take a long time so please be patient.

The scripts are set to ignore errors by default so that the project can clone to completion without any interruptions in case of possible minor errors especially when being cloned on Cygwin and Windows environment.
---------------------------------

Accessing Servers
---------------------------------
You can access the servers by running "vagrant rdp server1" to RDP into server1, for example. The default Administrator account is as follows:
Username: Administrator
Password: vagrant

The servers are joined to "reallyenglish.local" domain.
servers 1 to 4 have the respective IP addresses: 192.168.1.11, 192.168.1.12, 192.168.1.13, and 192.168.1.14.
---------------------------------

You can change the statichosts file to specify vagrant provisioning if you need to, however your ansible-playbook instance may be using /etc/ansible/hosts so you will need to modify that file to reflect what's in statichosts in order to run separate playbooks after Vagrant provisioning.


Notes
---------------------------------
In some ansible scripts, ignore_error flag has been included as the commands occasionally will throw an unauthorized error but still perform to completion. The non-inclusion of this flag will cause the script to fail even though there is not an issue with task execution. Check winrm-error file for specific error
---------------------------------
