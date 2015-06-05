default['yum']['remi']['repositoryid'] = 'remi'

case node['platform']
when 'amazon'
  default['yum']['remi']['description'] = 'Les RPM de remi pour Enterprise Linux 6 - $basearch'
  default['yum']['remi']['mirrorlist'] = 'http://rpms.famillecollet.com/enterprise/6/remi/mirror'
else
  default['yum']['remi']['description'] = "Les RPM de remi pour Enterprise Linux #{node['platform_version'].to_i} - $basearch"
  default['yum']['remi']['mirrorlist'] = "http://rpms.famillecollet.com/enterprise/#{node['platform_version'].to_i}/remi/mirror"
end

default['yum']['remi']['gpgkey'] = 'http://rpms.remirepo.net/RPM-GPG-KEY-remi'
default['yum']['remi']['gpgcheck'] = true
default['yum']['remi']['enabled'] = false
default['yum']['remi']['managed'] = true

