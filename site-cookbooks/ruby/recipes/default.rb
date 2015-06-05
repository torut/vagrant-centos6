#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

package 'ruby depends packages' do
  action :install
  package_name ['openssl-devel', 'libxml2-devel', 'libxslt-devel', 'readline-devel']
end

vagrant = 'vagrant'
home = "/home/#{vagrant}"

git "#{home}/.rbenv" do
  repository 'https://github.com/sstephenson/rbenv.git'
  revision   'master'
  user       vagrant
  group      vagrant
  action     :sync
end

directory "#{home}/.rbenv/plugins" do
  owner  vagrant
  group  vagrant
  action :create

  %w[.bash_profile .zshrc].each do |rc|
    notifies :run, "bash[#{home}/#{rc}]", :immediately
  end
end

git "#{home}/.rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  revision   'master'
  user       vagrant
  group      vagrant
  action     :sync
end

%w[.bash_profile .zshrc].each do |rc|
  bash "#{home}/#{rc}" do
    action :nothing
    user vagrant
    code <<-EOC
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> #{home}/#{rc}
echo 'eval "$(rbenv init -)"' >> #{home}/#{rc}
EOC
  end
end

ruby_version = node['ruby']['version']
rbenv_init = <<-EOC
export RBENV_ROOT="#{home}/.rbenv"
export PATH="#{home}/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
EOC

bash "#{home}/.rbenv/versions/#{ruby_version}" do
  not_if { ::File.exists? "#{home}/.rbenv/versions/#{ruby_version}" }

  user   vagrant
  cwd    home
  code   <<-EOC
#{rbenv_init}
rbenv install #{ruby_version}
rbenv rehash
rbenv global #{ruby_version}
gem install bundler
EOC
  action :run

end