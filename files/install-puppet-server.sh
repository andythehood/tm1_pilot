#!/bin/bash

if [ -d "/opt/puppetlabs" ] ; then
     echo "Puppet already installed"
     exit 0
fi

echo "**** Startup Step 1/9: Enable the Puppet Repo. ****"
dnf -y update
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf -y install https://yum.puppetlabs.com/puppet-release-el-8.noarch.rpm

echo "**** Startup Step 2/9: Install Puppet Server and update PATH. ****"
dnf -y install puppetserver
. /etc/profile.d/puppet-agent.sh

echo "**** Startup Step 3/9: Update Puppet Server to latest versions. ****"

puppet resource package puppetserver ensure=latest

echo "**** Startup Step 4/9: Open Firewall for Puppet port. ****"

firewall-cmd --add-port=8140/tcp --permanent
firewall-cmd --reload

echo "**** Startup Step 5/9: Update Puppet Configuration. ****"

cat >> /etc/puppetlabs/puppet/puppet.conf  <<EOT
autosign = true
[main]
certname = puppet-server.tada.local
server = puppet-server.tada.local
environment = production
EOT

echo "**** Startup Step 6/9: Generate PuppetServer CA certificates. ****"
puppetserver ca setup

echo "**** Startup Step 7/9: Start and Enable Puppet Server. ****"
systemctl start puppetserver
systemctl enable puppetserver

echo "**** Startup Step 8/9: Install default Puppet Modules. ****"

puppet module install puppetlabs-apache
puppet module install puppetlabs-chocolatey

echo "**** Startup Step 9/9: Create Sample manifests. ****"

cat >> /etc/puppetlabs/code/environments/production/manifests/apache.pp <<EOT
if \$osfamily == 'RedHat' {
  class { 'apache':
    package_ensure => 'installed'
  }
  file { '/var/www/html/index.html':
    ensure => file,
    content => '<html><head></head><body><h2>Puppet configured!</h2></body></html>',
  }
}
EOT

cat >> /etc/puppetlabs/code/environments/production/manifests/smss.pp <<EOT
if \$osfamily == 'windows' { 
  include chocolatey
  package { 'sql-server-management-studio':
    provider => chocolatey,
    ensure => installed,
  }
}
EOT

echo "**** Startup Done. ****"
