# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = [
  { :name => 'sign.dev.service.gov.uk', :ip => '10.10.11.10' },
  { :name => 'case.dev.service.gov.uk', :ip => '10.10.11.12' },
  { :name => 'deed.dev.service.gov.uk', :ip => '10.10.11.11' }
]

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-7.0-64-puppet"
  config.vm.box_version = "1.0.1"
  config.dns.tld = 'dev.service.gov.uk'
  config.dns.patterns = [/^.*dev.service.gov.uk$/]
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
    puppet.hiera_config_path = "hiera.yaml"
    puppet.module_path = ["site", "modules"]
    puppet.facter = {
      'is_vagrant'   => true,
    }
  end

  nodes.each do |node|
    config.vm.define node[:name] do |box|
      box.vm.host_name = node[:name]
      box.vm.network "private_network", ip: node[:ip]

      box.vm.provider :virtualbox do |v|
        v.customize ['modifyvm', :id, '--memory', '2048']
      end
    end
  end
end
