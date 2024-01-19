require "yaml"
settings = YAML.load_file "settings.yaml"

IP_SECTIONS = settings["network"]["control_ip"].match(/^([0-9.]+\.)([^.]+)$/)
# First 3 octets including the trailing dot:
IP_NW = IP_SECTIONS.captures[0]
# Last octet excluding all dots:
IP_START = Integer(IP_SECTIONS.captures[1])
NUM_WORKER_NODES = settings["nodes"]["workers"]["count"]

Vagrant.configure("2") do |config|
  config.vm.provision "shell", env: { "IP_NW" => IP_NW, "IP_START" => IP_START, "NUM_WORKER_NODES" => NUM_WORKER_NODES }, inline: <<-SHELL
      apt-get update -y

      echo "$IP_NW$((IP_START)) master-node" >> /etc/hosts
      echo "$IP_NW$((IP_START+1)) acm-node" >> /etc/hosts
      for i in `seq 1 ${NUM_WORKER_NODES}`; do
        echo "$IP_NW$((IP_START+i+1)) worker-node0${i}" >> /etc/hosts
      done
  SHELL

  if `uname -m`.strip == "aarch64"
    config.vm.box = settings["software"]["box"] + "-arm64"
  else
    config.vm.box = settings["software"]["box"]
  end
  config.vm.box_check_update = true

  config.vm.define "acm" do |acm|
    acm.vm.hostname = "acm-node"
    #acm.ssh.private_key_path = "~/.ssh/id_rsa"
    #acm.vm.network "private_network", ip: settings["network"]["control_ip"]
    acm.vm.network "private_network", ip: IP_NW + "#{IP_START + 1}"
    if settings["shared_folders"]
      settings["shared_folders"].each do |shared_folder|
        acm.vm.synced_folder shared_folder["host_path"], shared_folder["vm_path"]
      end
    end
#     # Provision ACM node to generate SSH keys
#     acm.vm.provision "shell" do |shell|
#       shell.inline = <<-SCRIPT
#         mkdir -p /vagrant/ssh-keys
#         ssh-keygen -t rsa -b 2048 -N "" -f /vagrant/ssh-keys/acm_key
#       SCRIPT
#     end
    acm.vm.provider "virtualbox" do |vb|
        vb.cpus = settings["nodes"]["acm"]["cpu"]
        vb.memory = settings["nodes"]["acm"]["memory"]
        if settings["cluster_name"] and settings["cluster_name"] != ""
          vb.customize ["modifyvm", :id, "--groups", ("/" + settings["cluster_name"])]
        end
    end
#     # Provision ACM node with private key
#     master.vm.provision "shell" do |shell|
#       shell.inline = <<-SCRIPT
#         mkdir -p /home/vagrant/.ssh
#         cp /vagrant/ssh-keys/acm_key /home/vagrant/.ssh/id_rsa
#         chown -R vagrant:vagrant /home/vagrant/.ssh
#         chmod 600 /home/vagrant/.ssh/id_rsa
#       SCRIPT
#     end
    acm.vm.provision "shell", inline: <<-SHELL
      echo "$(cat /vagrant/keys/id_rsa.pub)" >> /home/vagrant/.ssh/authorized_keys
      cp /vagrant/keys/id_rsa ~/.ssh/
    SHELL
  end

  config.vm.define "master" do |master|
    master.vm.hostname = "master-node"
    master.vm.network "private_network", ip: settings["network"]["control_ip"]
    if settings["shared_folders"]
      settings["shared_folders"].each do |shared_folder|
        master.vm.synced_folder shared_folder["host_path"], shared_folder["vm_path"]
      end
    end
    master.vm.provider "virtualbox" do |vb|
        vb.cpus = settings["nodes"]["control"]["cpu"]
        vb.memory = settings["nodes"]["control"]["memory"]
        if settings["cluster_name"] and settings["cluster_name"] != ""
          vb.customize ["modifyvm", :id, "--groups", ("/" + settings["cluster_name"])]
        end
    end
#     master.vm.provision "shell",
#       env: {
#         "DNS_SERVERS" => settings["network"]["dns_servers"].join(" "),
#         "ENVIRONMENT" => settings["environment"],
#         "KUBERNETES_VERSION" => settings["software"]["kubernetes"],
#         "OS" => settings["software"]["os"]
#       },
#       path: "scripts/common.sh"
#     master.vm.provision "shell",
#       env: {
#         "CALICO_VERSION" => settings["software"]["calico"],
#         "CONTROL_IP" => settings["network"]["control_ip"],
#         "POD_CIDR" => settings["network"]["pod_cidr"],
#         "SERVICE_CIDR" => settings["network"]["service_cidr"]
#       },
#       path: "scripts/master.sh"
#       # Provision master node with public key
#       master.vm.provision "shell" do |shell|
#         shell.inline = <<-SCRIPT
#           mkdir -p /home/vagrant/.ssh
#           cp /vagrant/ssh-keys/acm_key.pub /home/vagrant/.ssh/authorized_keys
#           chown -R vagrant:vagrant /home/vagrant/.ssh
#         SCRIPT
#       end
    master.vm.provision "shell", inline: <<-SHELL
      echo "$(cat /vagrant/keys/id_rsa.pub)" >> /home/vagrant/.ssh/authorized_keys
      cp /vagrant/keys/id_rsa ~/.ssh/
    SHELL
  end

  (1..NUM_WORKER_NODES).each do |i|

    config.vm.define "node0#{i}" do |node|
      node.vm.hostname = "worker-node0#{i}"
      node.vm.network "private_network", ip: IP_NW + "#{IP_START + i + 1}"
      if settings["shared_folders"]
        settings["shared_folders"].each do |shared_folder|
          node.vm.synced_folder shared_folder["host_path"], shared_folder["vm_path"]
        end
      end
      node.vm.provider "virtualbox" do |vb|
          vb.cpus = settings["nodes"]["workers"]["cpu"]
          vb.memory = settings["nodes"]["workers"]["memory"]
          if settings["cluster_name"] and settings["cluster_name"] != ""
            vb.customize ["modifyvm", :id, "--groups", ("/" + settings["cluster_name"])]
          end
      end
#       node.vm.provision "shell",
#         env: {
#           "DNS_SERVERS" => settings["network"]["dns_servers"].join(" "),
#           "ENVIRONMENT" => settings["environment"],
#           "KUBERNETES_VERSION" => settings["software"]["kubernetes"],
#           "OS" => settings["software"]["os"]
#         },
#         path: "scripts/common.sh"
#       node.vm.provision "shell", path: "scripts/node.sh"
#       # Provision master node with public key
#       node.vm.provision "shell" do |shell|
#         shell.inline = <<-SCRIPT
#           mkdir -p /home/vagrant/.ssh
#           cp /vagrant/ssh-keys/acm_key.pub /home/vagrant/.ssh/authorized_keys
#           chown -R vagrant:vagrant /home/vagrant/.ssh
#         SCRIPT
#       end
        node.vm.provision "shell", inline: <<-SHELL
          echo "$(cat /vagrant/keys/id_rsa.pub)" >> /home/vagrant/.ssh/authorized_keys
          cp /vagrant/keys/id_rsa ~/.ssh/
        SHELL
    end

  end
end 
