#
# Cookbook Name:: zsh
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

tarball = 'zsh.tar.gz'

package 'zsh depends packages' do
  action :install
  package_name ['pcre-devel', 'ncurses-devel']
end

execute 'install zshell' do
  user 'root'
  cwd '/usr/local/src'
  not_if { File.exists?('/usr/local/bin/zsh') }
  command <<-EOC
tar zxf #{tarball}
cd `ls -l | grep 'zsh' | awk '$1 ~ /d/ {print $9}'`
./configure --enable-pcre --enable-maildir-support --enable-multibyte --enable-zsh-secure-free --with-tcsetpgrp
make
make install
  EOC
  action :nothing
end

remote_file "/usr/local/src/#{tarball}" do
  action :create
  user 'root'
  source 'http://www.zsh.org/pub/zsh.tar.gz'
  retries 30
  retry_delay 10
  notifies :run, resources(:execute => 'install zshell'), :immediately
end


execute 'add zsh for /etc/shells' do
  user 'root'
  command <<-EOC
echo '/usr/local/bin/zsh' >> /etc/shells
  EOC
  not_if 'grep "/usr/local/bin/zsh" /etc/shells'
end