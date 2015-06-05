default['yum']['remi-test']['repositoryid'] = 'remi-test'

case node['platform']
when 'amazon'
  default['yum']['remi-test']['description'] = 'Les RPM de remi en test pour Enterprise Linux 6 - $basearch'
  default['yum']['remi-test']['mirrorlist'] = 'http://rpms.famillecollet.com/enterprise/6/test/mirror'
else
  default['yum']['remi-test']['description'] = "Les RPM de remi en test pour Enterprise Linux #{node['platform_version'].to_i} - $basearch"
  default['yum']['remi-test']['mirrorlist'] = "http://rpms.famillecollet.com/enterprise/#{node['platform_version'].to_i}/test/mirror"
end

default['yum']['remi-test']['gpgkey'] = 'http://rpms.remirepo.net/RPM-GPG-KEY-remi'
default['yum']['remi-test']['gpgcheck'] = true
default['yum']['remi-test']['enabled'] = false
default['yum']['remi-test']['managed'] = true

