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

  # Network Settings
  svradr = "172.31.16.100"
  nwadr = "172.31.16"
  masklength = 24
  netmsk = "255.255.240.0"
  dns = "172.31.30.104"
  dns1 = #{dns}
  dns2 = "8.8.8.8"
  domain = "internal.wyvernsquare.com"
  # Linux Server Settings
  linusr = "vagrant"

  # VPN Connection Settings
  enable_ikev1 = "false"
  enable_ikev2 = "false"
  enable_l2tp = "true"
  psk_secret = "wyvernsquarebeerpizzaandfriends"
  enable_radius = "true"
  #vpnusername = "vpnuser"
  #vpnpassword = "opensesame"

  # VPN/RADIUS Host Settings
  vpnserver_name = "Wyvernsquare Staging"
  vpnlocal_ip = "172.31.27.1"
  vpnremote_ip = "172.31.27.10-249"
  vpnsubnet = "172.31.27.0/24"
  vpnradius_host = "52.192.214.252"
  l2tp_enable_nat = "true"
  l2tp_under_ipsec = "true"
  

  # Open file writing pipe for ansible inventory and global variable files
  require "fileutils"
  allvars = File.open("group_vars/all", "w")

  # DO NOT CHANGE THESE VALUES
  #allvars.puts "username: #{username}"
  #allvars.puts "password: #{password}"
  allvars.puts "domain: #{domain}"
  allvars.puts "gw: #{dns}"
  allvars.puts "dns: #{dns}"
  allvars.puts "masklength: #{masklength}"
  allvars.puts "netmask: #{netmsk}"
  allvars.close

  # Write to vpn1 variable file
  vpnfile = File.open("group_vars/vpn1.yml", "w")
  vpnfile.puts "---"
  vpnfile.puts "radius_servers:"
  vpnfile.puts "  host: #{vpnradius_host}"
  vpnfile.puts "  secret: #{psk_secret}"
  vpnfile.puts "dns_servers:"
  vpnfile.puts "  - #{dns1}"
  vpnfile.puts "  - #{dns2}"
  
  vpnfile.puts "ipsec_enable_ikev1: #{enable_ikev1}"
  vpnfile.puts "ipsec_enable_ikev2: #{enable_ikev2}"
  vpnfile.puts "ipsec_enable_l2tp: #{enable_l2tp}"
  vpnfile.puts "ipsec_psk: #{psk_secret}"
  vpnfile.puts "ipsec_use_radius: #{enable_radius}"
  vpnfile.puts "ipsec_dns_servers: \"\{\{ dns_servers \}\}\""
  #vpnfile.puts "ipsec_radius_servers: \"\{\{ radius_servers \}\}\""
  vpnfile.puts "ipsec_radius_servers:"
  vpnfile.puts "  host: #{vpnradius_host}"
  vpnfile.puts "  secret: #{psk_secret}"

  vpnfile.puts "l2tp_server_name: \"#{vpnserver_name}\""
  vpnfile.puts "l2tp_network:"
  vpnfile.puts "  local_ip: #{vpnlocal_ip}"
  vpnfile.puts "  remote_ip: #{vpnremote_ip}"
  vpnfile.puts "  subnet: #{vpnsubnet}"
  vpnfile.puts "l2tp_dns_servers: \"\{\{ dns_servers \}\}\""
  vpnfile.puts "l2tp_use_radius: #{enable_radius}"
  #vpnfile.puts "l2tp_radius_servers: \"\{\{ radius_servers \}\}\""
  vpnfile.puts "l2tp_radius_servers:"
  vpnfile.puts "  host: #{vpnradius_host}"
  vpnfile.puts "  secret: #{psk_secret}"
  vpnfile.puts "l2tp_enable_nat: #{l2tp_enable_nat}"
  vpnfile.puts "l2tp_under_ipsec: #{l2tp_under_ipsec}"

  vpnfile.puts "pptp_server_name: \"#{vpnserver_name}\""
  vpnfile.puts "pptp_network:"
  vpnfile.puts "  local_ip: #{vpnlocal_ip}"
  vpnfile.puts "  remote_ip: #{vpnremote_ip}"
  vpnfile.puts "  subnet: #{vpnsubnet}"
  vpnfile.puts "pptp_dns_servers: \"\{\{ dns_servers \}\}\""
  vpnfile.puts "pptp_use_radius: #{enable_radius}"
  #vpnfile.puts "pptp_radius_servers: \"\{\{ radius_servers \}\}\""
  vpnfile.puts "pptp_radius_servers:"
  vpnfile.puts "  host: #{vpnradius_host}"
  vpnfile.puts "  secret: #{psk_secret}"

  #vpnfile.puts "l2tp_users:"
  #vpnfile.puts "  - username: \"#{vpnusername}\""
  #vpnfile.puts "    password: \"#{vpnpassword}\""
  vpnfile.close

  f = File.open("hosts","w")

  # VM variables
  VAGRANT_VM_PROVIDER = "virtualbox"
  ANSIBLE_RAW_SSH_ARGS = []
  ANSIBLE_RAW_SSH_ARGS << "-o IdentityFile=#{ENV["VAGRANT_DOTFILE_PATH"]}/machines/server1/#{VAGRANT_VM_PROVIDER}/private_key"

  # Set up Linux Servers
    config.vm.define "server1"
    config.vm.box = "centos/7"
    config.vm.network "private_network", ip: "#{svradr}", netmask: "#{netmsk}"

    config.vm.hostname = "vpn1"
    f.puts "[vpn1]"
    config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
    f.puts "#{svradr} ansible_ssh_user=#{linusr} ansible_ssh_private_key_file=#{ENV["VAGRANT_DOTFILE_PATH"]}/machines/server1/#{VAGRANT_VM_PROVIDER}/private_key" 

  # Provision with Ansible
    config.vm.provision :ansible do |ansible|
      # Disable default limit to connect to all the machines
        ansible.limit = "all"
        ansible.playbook = "provision.yml"
        ansible.inventory_path = "hosts"
        #ansible.verbose = "-v"
        ansible.raw_ssh_args = ANSIBLE_RAW_SSH_ARGS
    end
  # Write list of servers
  # close inventory file writing pipe
    f.close

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder ".", "/vagrant", disabled: true
end
