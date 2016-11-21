# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

# Checks ENV VAGRANT_DOTFILE_PATH. Set to current directory .vagrant if NULL
VAGRANT_DOTFILE_PATH = ENV['VAGRANT_DOTFILE_PATH'];
currpath = ENV['VAGRANT_DOTFILE_PATH'];
if(currpath.nil?)
    currpath = '.vagrant';
    ENV['VAGRANT_DOTFILE_PATH'] = currpath;
end


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Number of total servers
  N = 5
  # Windows Servers starting from position number Nth
  winsrvN = 3
  # Network Settings
  nwadr = "10.0.81"
  lastoctet_initadr = 10
  masklength = 24
  netmsk = "255.255.255.0"
  svrstartip = "10.0.81.100"
  svrendip = "10.0.81.254"
  dns = "10.0.81.12"
  # Windows Server Settings
  username = "Administrator"
  password = "vagrant"
  domain = "reallyenglish.local"

  # Linux Server Settings
  linusr = "vagrant"


  # Open file writing pipe for ansible inventory and global variable files
  require "fileutils"
  allvars = File.open("group_vars/all", "w")
  allvars.puts "username: #{username}"
  allvars.puts "password: #{password}"
  allvars.puts "domain: #{domain}"
  allvars.puts "gw: #{nwadr}.1"
  allvars.puts "dns: #{dns}"
  allvars.puts "masklength: #{masklength}"
  allvars.puts "netmask: #{netmsk}"
  allvars.puts "svrstart: #{svrstartip}"
  allvars.puts "svrend: #{svrendip}"
  allvars.close

  f = File.open("hosts","w")

  # VM variables
  VAGRANT_VM_PROVIDER = "virtualbox"
  ANSIBLE_RAW_SSH_ARGS = []
  (1..N-1).each do |machine_id|
    ANSIBLE_RAW_SSH_ARGS << "-o IdentityFile=#{ENV["VAGRANT_DOTFILE_PATH"]}/machines/server#{machine_id}/#{VAGRANT_VM_PROVIDER}/private_key"
  end

  # Set up Linux Servers
  (1..winsrvN-1).each do |svr_id|
    config.vm.define "server#{svr_id}" do |server|
      server.vm.box = "centos/7"
      server.vm.network "private_network", ip: "#{nwadr}.#{lastoctet_initadr+svr_id-1}", netmask: "#{netmsk}"

      # Set-up Management Machine and VPN Server
      if svr_id == 1
        server.vm.hostname = "mgmt1"
        f.puts "[mgmt1]"
      end
      if svr_id == 2
        server.vm.hostname = "vpn1"
        f.puts "[vpn1]"
        server.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
      end
    f.puts "#{nwadr}.#{lastoctet_initadr+svr_id-1} ansible_ssh_user=#{linusr} ansible_ssh_private_key_file=#{ENV["VAGRANT_DOTFILE_PATH"]}/machines/server#{svr_id}/#{VAGRANT_VM_PROVIDER}/private_key" 
    end
  end

  # Set up Windows Servers
  i = 1
  (winsrvN..N).each do |machine_id|
  config.vm.define "server#{machine_id}" do |machine|
    machine.vm.box = "kensykora/windows_2012_r2_standard"
    machine.vm.guest = :windows
    # Set-up WinRM and RDP for Windows Machines
    machine.vm.communicator = "winrm"
    machine.winrm.username = "#{username}"
    machine.winrm.password = "#{password}"
    # Port forward WinRM and RDP (changed values to NOT conflict with host)
    machine.vm.network "forwarded_port", host: 33389, guest: 3389, id: "rdp", auto_correct: true
    machine.vm.network "forwarded_port", host: 5987, guest: 5985, id: "winrm", auto_correct: true
	 if machine_id  < N && machine_id > 0
	     machine.vm.hostname = "dc#{i}"
       f.puts "[dc#{i}]"
       f.puts "#{nwadr}.#{lastoctet_initadr-1+machine_id}"
	 end
	 if machine_id == N
	     machine.vm.hostname = "wsus"
       f.puts "[wsus]"
       f.puts "#{nwadr}.#{lastoctet_initadr-1+machine_id}"
	 end
     machine.vm.network "private_network", ip: "#{nwadr}.#{lastoctet_initadr-1+machine_id}", netmask: "#{netmsk}"
  
     # Create a forwarded port mapping which allows access to a specific port
     # within the machine from a port on the host machine. In the example below,
     # accessing "localhost:8080" will access port 80 on the guest machine.
      machine.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true

     # Customize the amount of memory on the VM:
     #vb.memory = "1024"

	 # Run Ansible from the Vagrant Host
     # Only execute once the Ansible provisioner,
     # when all the machines are up and ready.
       if machine_id == N
        # Provision with Ansible
        machine.vm.provision :ansible do |ansible|
           #Disable default limit to connect to all the machines
           ansible.limit = "all"
           ansible.playbook = "provision.yml"
           ansible.inventory_path = "hosts"
           #ansible.verbose = "-v"
           ansible.raw_ssh_args = ANSIBLE_RAW_SSH_ARGS
		    end
        
        # Write list of servers
        f.puts "[allservers:children]"
        (winsrvN..N).each do |num|
          if num < N
            f.puts "dc#{num-winsrvN+1}"
          end
        end
        f.puts "wsus"
        f.puts "[allservers:vars]"
        f.puts "ansible_ssh_user=Administrator"
        f.puts "ansible_ssh_pass=vagrant"
        f.puts "ansible_connection=winrm"
        f.puts "ansible_ssh_port=5985"
        f.puts "ansible_winrm_server_cert_validation=ignore"

       # close inventory file writing pipe
       f.close
       # close group variable file writing pipe
       end


   i = i+1
    end
   end
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
end
