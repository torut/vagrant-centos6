#
# Cookbook Name:: php56-remi
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

execute 'kill php-fpm service' do
  user 'root'
  command 'kill `ps aux | grep "php-fpm: master" | grep -v "grep" | awk "{print $2}"`'
  only_if 'ps aux | grep "php-fpm: master" | grep -v "grep"'
end

execute 'remove php packages' do
  user 'root'
  command <<-EOC
yum -y erase php54-*
yum -y erase php55u-*
yum -y erase php-*
  EOC
end

template '/etc/php.ini' do
  source 'php.ini.erb'
  mode '0644'
  action :nothing
end

template '/etc/php.d/15-xdebug.ini' do
  source 'xdebug.ini.erb'
  mode '0644'
  action :nothing
end

package 'php56' do
  action :install
  package_name [
    'php', 'php-devel', 'php-mbstring', 'php-mysqlnd', 'php-pdo', 'php-cli', 'php-gd', 'php-mcrypt',
    'php-pear', 'php-xml', 'php-pecl-xdebug', 'php-opcache', 'php-pecl-apcu', 'php-intl', 'php-fpm',
  ]
  options '--enablerepo=remi,remi-php56'
  notifies :create, resources(:template => '/etc/php.ini'), :immediately
  notifies :create, resources(:template => '/etc/php.d/15-xdebug.ini'), :immediately
  notifies :restart, resources(:service => 'httpd')  if node['web_server'] == 'httpd'
end

if node['web_server'] == 'nginx'
  directory '/var/lib/php/session' do
    group 'nginx'
    action :create
  end

  service 'php-fpm' do
    supports [:restart => true, :reload => true, :status => true]
    action :nothing
  end

  template '/etc/php-fpm.conf' do
    source 'php-fpm.conf.erb'
    mode '0644'
    notifies :enable, resources(:service => 'php-fpm')
    notifies :start, resources(:service => 'php-fpm')
  end
else
  service 'php-fpm' do
    supports [:restart => true, :reload => true, :status => true]
    action [:disable]
  end
end

