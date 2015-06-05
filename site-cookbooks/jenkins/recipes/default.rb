#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2015, Toru TAMURA <https://github.com/torut>
#

package 'java-1.8.0-openjdk' do
  action :install
end

package 'vlgothic fonts' do
  action :install
  package_name ['vlgothic-fonts', 'vlgothic-p-fonts']
end

execute 'install jenkins repo' do
  user 'root'
  command <<-EOC
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
  EOC
  not_if { File.exists?('/etc/yum.repos.d/jenkins.repo') }
end

package 'jenkins' do
  action :install
end

service 'jenkins' do
  service_name 'jenkins'
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

remote_file '/var/lib/jenkins/jenkins-cli.jar' do
  source 'http://localhost:8080/jnlpJars/jenkins-cli.jar'
  retries 30
  retry_delay 10
  not_if { File.exists?('/var/lib/jenkins/jenkins-cli.jar') }
end

execute 'update jenkins plugin list' do
  command <<-EOC
curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack
  EOC
end

execute 'install jenkins plugins' do
  user 'vagrant'
  command <<-EOC
java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 install-plugin git github checkstyle cloverphp crap4j dry htmlpublisher jdepend plot pmd violations xunit phing
  EOC
end

execute 'install jenkins php-template' do
  user 'root'
  command <<-EOC
cd /var/lib/jenkins/jobs
rm -rf php-template
git clone --depth=1 https://github.com/sebastianbergmann/php-jenkins-template.git php-template
chown -R jenkins:jenkins php-template
  EOC
end

directory '/var/lib/jenkins/jobs/fuelphp-template' do
  owner 'jenkins'
  group 'jenkins'
  mode '0755'
  action :create
end

template '/var/lib/jenkins/jobs/fuelphp-template/config.xml' do
  owner 'jenkins'
  group 'jenkins'
  source 'fuelphp-template-config.xml.erb'
  mode '0644'
  notifies :restart, resources(:service => 'jenkins')
end

# change /home/vagrant permission to use composer installed commands
execute 'change /home/vagrant permission' do
  user 'root'
  command <<-EOC
chmod go+rx /home/vagrant
  EOC
end

