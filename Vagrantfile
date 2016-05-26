# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  N = 4
  VAGRANT_VM_PROVIDER = "virtualbox"
  ANSIBLE_RAW_SSH_ARGS = []

  (1..N-1).each do |machine_id|
    ANSIBLE_RAW_SSH_ARGS << "-o IdentityFile=#{ENV["VAGRANT_DOTFILE_PATH"]}/machines/server#{machine_id}/#{VAGRANT_VM_PROVIDER}/private_key"
  end

  # Set-up Management Machine
  config.vm.box = "centos/7"
  config.vm.hostname = "mgmt01"
  config.vm.define "server1"
  config.vm.network "private_network", ip: "192.168.1.10", netmask: "255.255.0.0"
  
  (2..N).each do |machine_id|
  config.vm.define "server#{machine_id}" do |machine|
    machine.vm.box = "mwrock/Windows2012R2"
    machine.vm.guest = :windows
    # Set-up WinRM and RDP for Windows Machines
    machine.vm.communicator = "winrm"
    machine.winrm.username = "Administrator"
    machine.winrm.password = "vagrant"
    # Port forward WinRM and RDP (changed values to NOT conflict with host)
    machine.vm.network "forwarded_port", host: 33389, guest: 3389, id: "rdp", auto_correct: true
    machine.vm.network "forwarded_port", host: 5987, guest: 5985, id: "winrm", auto_correct: true
	 if machine_id  < N-1 && machine_id > 1
	     machine.vm.hostname = "dc#{machine_id}"
	 end
	 if machine_id == N-1
	     machine.vm.hostname = "wsus"
	 end

     machine.vm.network "private_network", ip: "192.168.1.#{9+machine_id}", netmask: "255.255.0.0"
  
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
        machine.vm.provision :ansible do |ansible|
           #Disable default limit to connect to all the machines
           ansible.limit = "all"
           ansible.playbook = "provision.yml"
           ansible.inventory_path = "statichosts"
           ansible.raw_ssh_args = ANSIBLE_RAW_SSH_ARGS
		    end
       end
    end
   end
	
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
end
