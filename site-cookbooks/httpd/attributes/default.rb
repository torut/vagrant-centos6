default['httpd']['ServerTokens'] = 'Prod'
default['httpd']['ServerSignature'] = 'On'
default['httpd']['Timeout'] = 300
default['httpd']['KeepAlive'] = 'Off'

default['httpd']['Port'] = 80
default['httpd']['User'] = 'apache'
default['httpd']['Group'] = 'apache'
default['httpd']['ServerAdmin'] = 'root@localhost'

default['httpd']['DocumentRoot'] = '/vagrant/public'
default['httpd']['ScriptDocumentRoot'] = '/var/www/cgi-bin/'

default['httpd']['UseAliasIcons'] = false
default['httpd']['UseAliasError'] = false

default['httpd']['mpm']['prefork']['StartServers']        = 8
default['httpd']['mpm']['prefork']['MinSpareServers']     = 5
default['httpd']['mpm']['prefork']['MaxSpareServers']     = 20
default['httpd']['mpm']['prefork']['ServerLimit']         = 256
default['httpd']['mpm']['prefork']['MaxClients']          = 256
default['httpd']['mpm']['prefork']['MaxRequestsPerChild'] = 4000

default['httpd']['mpm']['worker']['StartServers']        = 4
default['httpd']['mpm']['worker']['MaxClients']          = 300
default['httpd']['mpm']['worker']['MinSpareThreads']     = 25
default['httpd']['mpm']['worker']['MaxSpareThreads']     = 75
default['httpd']['mpm']['worker']['ThreadsPerChild']     = 25
default['httpd']['mpm']['worker']['MaxRequestsPerChild'] = 0


default['httpd']['NameVirtualHost'] = false
default['httpd']['vhost'][0]['Port'] = 80
default['httpd']['vhost'][0]['ServerAdmin'] = 'webmaster@dummy-host.example.com'
default['httpd']['vhost'][0]['DocumentRoot'] = '/www/docs/dummy-host.example.com'
default['httpd']['vhost'][0]['ServerName'] = 'dummy-host.example.com'
default['httpd']['vhost'][0]['ErrorLog'] = 'logs/dummy-host.example.com-error_log'
default['httpd']['vhost'][0]['CustomLog'] = 'logs/dummy-host.example.com-access_log combined'
