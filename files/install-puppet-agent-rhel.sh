#!/bin/bash

if [ -d "/opt/puppetlabs" ] ; then
     echo "Puppet already installed"
     exit 0
fi

echo "**** Startup Step 1/5: Enable the Puppet Repo. ****"
dnf -y update
dnf -y install https://yum.puppetlabs.com/puppet-release-el-8.noarch.rpm

echo "**** Startup Step 2/5: Install Puppet Agent and update PATH. ****"
dnf -y install puppet-agent
. /etc/profile.d/puppet-agent.sh


echo "**** Startup Step 3/5: Configure Puppet Agent. ****"
# Probably should do this with puppet agent commands

cat >> /etc/puppetlabs/puppet/puppet.conf  <<EOT
[main]
server = ${tpl_PUPPET_SERVER}
environment = production
runinterval=60
EOT

echo "**** Startup Step 4/5: Ensure Puppet is running. ****"

puppet resource service puppet ensure=running enable=true

echo "**** Startup Step 5/5: Done . ****"

# #Wait for Puppet Server to start
# # TODO: Is there a better
# sleep 300

# puppet agent --test




