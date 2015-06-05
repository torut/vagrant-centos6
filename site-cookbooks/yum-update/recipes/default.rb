#
# Cookbook Name:: yum-update
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

execute "yum update" do
  user "root"
  command "yum -y update"
end
