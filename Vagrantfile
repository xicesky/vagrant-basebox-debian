# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    #config.vm.box = "chef/debian-7.6"
    #config.vm.box = "debian/contrib-jessie64"
    #config.vm.box.version = ">= 0"
    #config.vm.box = "debian-8.1.0-amd64"
    config.vm.box = "bento/debian-8.5"

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    config.ssh.forward_agent = true

    # Do NOT automatically replace the insecure key
    # (That feature does not seem to work right...)
    config.ssh.insert_key = false
    #config.ssh.private_key_path = './support/vagrant/vagrant_insecure_private_key'
    

    
    # Synced folders
    #config.vm.synced_folder ".", "/vagrant", type: "nfs"
    #    disabled: true,
    #    owner: "vagrant", group: "vagrant"
  
    ####################################################################################################
    # Virtual machine (and provider-specific) configuration

    config.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 2
        #vb.gui = true
        #vb.customize ["modifyvm", :id, "--memory", "1024"]
    end

    config.vm.provider :libvirt do |libvirt|
        libvirt.default_prefix = "build_box"
    end
    
    ####################################################################################################
    # Ports

    # Web port
    #config.vm.network :forwarded_port, host: 80, guest: 80

    # PostgreSQL port
    #config.vm.network :forwarded_port, host: 5432, guest: 5432

    ####################################################################################################
    # Caching behaviour (vagrant cachier)

    if Vagrant.has_plugin?('vagrant-cachier')
        config.cache.auto_detect = true
        config.cache.scope = :box
        config.cache.enable :apt

        # https://github.com/fgrehm/vagrant-cachier/issues/57
        config.cache.enable :generic, {
            "maven" => { cache_dir: "/home/vagrant/.m2/repository" },
        }
    end

    ####################################################################################################
    # Shell provisioning

    # Do the real provisioning
    config.vm.provision "shell", path: "support/vagrant/bootstrap.sh"

    # Clean up
    config.vm.provision "shell", path: "support/vagrant/postprocess.sh"

end
