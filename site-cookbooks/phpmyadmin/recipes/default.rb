#
# Cookbook Name:: phpmyadmin
# Recipe:: default
#
# Copyright 2015, Toru TAMURA
#

Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['phpmyadmin']['cookie_token'] = secure_password

taball = 'http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.4.7/phpMyAdmin-4.4.7-all-languages.tar.gz?use_mirror=jaist&ts=1432172560'

template '/usr/share/phpMyAdmin/config.inc.php' do
  source 'config.inc.php.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :nothing
end

execute 'install phpMyAdmin' do
  user 'root'
  command <<-EOC
tar zxf /tmp/phpmyadmin.tar.gz -C /usr/share
mv /usr/share/phpMyAdmin-4.4.7-all-languages /usr/share/phpMyAdmin
  EOC
  action :nothing
  notifies :create, resources(:template => '/usr/share/phpMyAdmin/config.inc.php'), :immediately
  not_if { File.exists?('/usr/share/phpMyAdmin/index.php') }
end

remote_file '/tmp/phpmyadmin.tar.gz' do
  action :create
  source taball
  retries 30
  retry_delay 10
  notifies :run, resources(:execute => 'install phpMyAdmin'), :immediately
end

# for nginx
if node['web_server'] == 'nginx'
  directory '/etc/nginx/default.d' do
    group 'root'
    user 'root'
    action :create
    only_if { File.exists?('/usr/sbin/nginx') }
  end

  template '/etc/nginx/default.d/phpmyadmin.conf' do
    source 'nginx_phpmyadmin.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, resources(:service => 'nginx')
    only_if { File.exists?('/usr/sbin/nginx') }
  end
end

# for httpd
if node['web_server'] == 'httpd'
  template '/etc/httpd/conf.d/phpmyadmin.conf' do
    source 'httpd_phpmyadmin.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, resources(:service => 'httpd')
    only_if { File.exists?('/usr/sbin/httpd') }
  end
end
