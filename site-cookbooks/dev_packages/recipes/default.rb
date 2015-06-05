#
# Cookbook Name:: dev_packages
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

if node['dev_packages']['packages']
  package 'dev_packages' do
    package_name node['dev_packages']['packages']
    action :install
  end
end
