#
# Cookbook Name:: httpd
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

if node['web_server'] == 'httpd'
  package 'nginx' do
    action :remove
  end

  service 'httpd' do
    service_name 'httpd'
    supports     :status => true, :restart => true, :reload => true
    action       :nothing
  end

  execute 'rename welcome.conf' do
    user 'root'
    command 'mv /etc/httpd/conf.d/welcome.conf{,.back}'
    only_if { File.exists?('/etc/httpd/conf.d/welcome.conf') }
    action :nothing
  end

  template '/etc/httpd/conf/httpd.conf' do
    source 'httpd.conf.erb'
    mode '0644'
    action :nothing
  end

  package 'apache' do
    action :install
    package_name ['httpd', 'httpd-devel']
    notifies :create, resources(:template => '/etc/httpd/conf/httpd.conf'), :immediately
    notifies :run, resources(:execute => 'rename welcome.conf'), :immediately
    notifies :enable, resources(:service => 'httpd')
    notifies :start, resources(:service => 'httpd')
  end
end
