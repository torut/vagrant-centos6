#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

node.set_unless['web_server'] = 'nginx'
if ! ['httpd', 'nginx'].include?(node['web_server'])
  node['web_server'] = 'nginx'
end

if node['web_server'] == 'nginx'
  package 'httpd packages' do
    action :remove
    package_name ['httpd', 'httpd-devel', 'httpd-tools']
  end

  execute 'install nginx repo' do
    user 'root'
    command <<-EOC
wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
rpm -Uvh /nginx-release-centos-6*.rpm
    EOC
    not_if 'rpm -qa | grep nginx-release'
  end

  service 'nginx' do
    supports status: true, restart: true, reload: true
    action :nothing
  end

  directory '/usr/share/nginx/logs' do
    owner 'nginx'
    group 'nginx'
    mode '0755'
    recursive true
    action :nothing
  end

  directory '/etc/nginx/conf.d' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  package 'nginx' do
    action :install
    options '--enablerepo=nginx'
    notifies :create, resources(:directory => '/usr/share/nginx/logs'), :immediately
    notifies :enable, resources(:service => 'nginx')
  end

  template '/etc/nginx/nginx.conf' do
    source 'nginx.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :restart, resources(:service => 'nginx')
  end

  template '/etc/nginx/conf.d/default.conf' do
    source 'conf.d/default.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :restart, resources(:service => 'nginx')
  end

end
