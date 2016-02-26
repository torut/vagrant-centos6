VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # CentOS 6.5 x86_64 Minimal (2014-01-16)
  # https://github.com/2creatives/vagrant-centos/releases/tag/v6.5.3
  config.vm.box = 'centos65-x86_64-20140116'
  config.vm.box_url = 'https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box'

  config.vm.hostname = 'vagrant.local'

  # private ip-address
  config.vm.network :private_network, ip: '192.168.33.11'

  # port forward
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # folder sync
  config.vm.synced_folder './', '/mnt/vagrant',
    :owner => 'vagrant', :group => 'vagrant',
    :mount_options => ['dmode=777,fmode=777']

  config.vm.provider 'virtualbox' do |vb|
    # name
    vb.customize ['modifyvm', :id, '--name', 'CentOS 6.5 x86_64 Minimal']
    
    # Customize the amount of memory on the VM:
    vb.customize ['modifyvm', :id, '--memory', '1024']
  end

  config.vbguest.auto_update = false

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['./cookbooks', './site-cookbooks']

    chef.add_recipe 'selinux::disabled'
    chef.add_recipe 'iptables::disabled'
    chef.add_recipe 'sysconfig'

    chef.add_recipe 'ntp'

    chef.add_recipe 'dev_packages'

    chef.add_recipe 'yum-epel'
    chef.add_recipe 'yum-remi'

    chef.add_recipe 'zsh'

    # Database server: Percona-Server 5.6
    chef.add_recipe 'percona::server'

    # Web server: The default nginx
    chef.add_recipe 'httpd'

    # PHP: The default is PHP 5.4 remi
    chef.add_recipe 'php54-remi'
    # chef.add_recipe 'phpmyadmin'
    # chef.add_recipe 'phpunit'

    # Ruby: The default is 2.1.5 by rbenv
    # chef.add_recipe 'ruby'

    # chef.add_recipe 'jenkins'

    # (optional) Update all yum packages
    # chef.add_recipe 'yum-update'

    chef.json = {
      'sysconfig' => {
        'timezone' => 'Asia/Tokyo',
      },
#      'web_server' => 'httpd', # if use apache for web server comment in this line.
      'dev_packages' => {
        'packages' => ['wget', 'gcc', 'make', 'tmux', 'emacs-nox', 'git']
      },
      'yum-epel' => {
        'repositories' => ['epel']
      },
      'yum-remi' => {
        'repositories' => ['remi']
      },
      'percona' => {
        'server' => {
          'root_password' => 'rootpassword'
        }
      },
      'php' => {
        'date.timezone' => 'Asia/Tokyo'
      },
      'phpmyadmin' => {
        'absolute_uri' => 'http://192.168.33.11/phpmyadmin/'
      },
      'ruby' => {
        'version' => '2.1.5'
      }
    }
  end

end
