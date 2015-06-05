#
# Cookbook Name:: sysconfig
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

execute 'modified system timezone' do
  user 'root'
  command <<-EOC
sed -i -e 's/ZONE=/#ZONE=/g' /etc/sysconfig/clock
echo 'ZONE="#{node['sysconfig']['timezone']}"' >> /etc/sysconfig/clock
echo 'UTC=false' >> /etc/sysconfig/clock
source /etc/sysconfig/clock
rm /etc/localtime
cp -p /usr/share/zoneinfo/#{node['sysconfig']['timezone']} /etc/localtime
  EOC
  only_if { File.exists?('/usr/share/zoneinfo/' + node['sysconfig']['timezone']); }
end

execute 'disabled Ctrl+Alt+Del' do
  user 'root'
  command <<-EOC
sed -i -e 's/^\([start|exec]\)/#\1/g' /etc/init/control-alt-delete.conf
  EOC
end

service 'sshd' do
  service_name 'sshd'
  action :nothing
end

execute 'disabled root ssh login' do
  user 'root'
  command <<-EOC
sed -i -e 's/^#PermitRootLogin.*$/PermitRootLogin no/g' /etc/ssh/sshd_config
  EOC
  notifies :restart, resources(:service => 'sshd')
end

