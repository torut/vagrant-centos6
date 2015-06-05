#
# Cookbook Name:: phpunit
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

execute 'install composer' do
  user 'root'
  command <<-EOC
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chown vagrant.vagrant /usr/local/bin/composer
  EOC
  not_if { File.exists?('/usr/local/bin/composer') }
end

execute 'install phpunit by composer' do
  user 'vagrant'
  command <<-EOC
mkdir -p /home/vagrant/.composer
cd /home/vagrant/.composer
composer require 'phpunit/phpunit=3.7.*'
  EOC
  not_if { File.exists?('/home/vagrant/.composer/vendor/bin/phpunit') }
end

execute 'install php QA tools by composer' do
  user 'vagrant'
  command <<-EOC
mkdir -p /home/vagrant/.composer
cd /home/vagrant/.composer
composer require \
  'squizlabs/php_codesniffer=2.2.*' \
  'phploc/phploc=2.0.*' \
  'pdepend/pdepend=2.0.*' \
  'phpmd/phpmd=2.2.*' \
  'sebastian/phpcpd=2.0.*' \
  'theseer/phpdox=0.7.*' \
  'phing/phing=2.9.*'
  EOC
  not_if { File.exists?('/home/vagrant/.composer/vendor/bin/phing') }
end

execute 'install fuelphp-phpcs' do
  user 'vagrant'
  command <<-EOC
cd /home/vagrant
git clone https://github.com/eviweb/fuelphp-phpcs.git
cd fuelphp-phpcs/Standards
mv FuelPHP /home/vagrant/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards
  EOC
  not_if { File.exists?('/home/vagrant/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/FuelPHP') }
end

# set composer path
execute 'set global composer bin path' do
  user 'vagrant'
  command <<-EOC
sed -i -e '/\.composer/d' /home/vagrant/.bash_profile
sed -i -e '/export PATH/d' /home/vagrant/.bash_profile
echo 'PATH="$HOME/.composer/vendor/bin:$PATH"' >>/home/vagrant/.bash_profile
echo 'export PATH' >>/home/vagrant/.bash_profile
  EOC
end
