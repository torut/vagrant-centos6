#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

service 'ntpd' do
  service_name 'ntpd'
  supports     :status => true, :restart => true, :reload => true
  action       :nothing
end

execute 'configure ntpd' do
  user 'root'
  command <<-EOC
ntpdate -b 210.173.160.87
sed -i -e 's/^server /#server /g' /etc/ntp.conf
echo '# ADDED mfeed' >> /etc/ntp.conf
echo 'server 210.173.160.27' >> /etc/ntp.conf
echo 'server 210.173.160.57' >> /etc/ntp.conf
echo 'server 210.173.160.87' >> /etc/ntp.conf
  EOC
  not_if 'grep '# ADDED mfeed' /etc/ntp.conf'
  action :nothing
end

package 'ntp' do
  action :install
  notifies :run, resources(:execute => 'configure ntpd'), :immediately
  notifies :enable, resources(:service => 'ntpd')
  notifies :start, resources(:service => 'ntpd')
end
