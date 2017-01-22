fusionpbx-install.sh
--------------------------------------

This install script that has been designed to be an fast, simple, and modular way to to install FusionPBX. Start with a minimal install of Debian 8 with SSH enabled. Run the following commands under root. It installs FusionPBX, FreeSWITCH release package and its dependencies, IPTables, Fail2ban, NGINX, PHP FPM, and PostgresQL.

```bash
wget https://raw.githubusercontent.com/fusionpbx/fusionpbx-install.sh/master/install.sh -O install.sh && sh install.sh
```

At the end of the install it will instruct you to go to the ip address of the server in your web browser to finish the install. It will also provide a random database password for you to use during the web based phase of the install. The install script builds the fusionpbx database so you will not need to use the create database username and password on the last page of the web based install.

After you have completed the install you can login with the username and password you chose during the install. After you login go to them menu then Advanced -> Upgrade select the checkbox for App defaults. 

```bash
systemctl daemon-reload
systemctl restart freeswitch
```

Then go to Status -> SIP Status and start the SIP profiles, after this, go to Advanced -> Modules and find the module Memcached and click start.

apt-get update && apt-get upgrade -y --force-yes
apt-get install -y --force-yes git
cd /usr/src
git clone https://github.com/fusionpbx/fusionpbx-install.sh.git
chmod 755 -R /usr/src/fusionpbx-install.sh
cd /usr/src/fusionpbx-install.sh/debian
./install.sh

fusionpbx-sce-install
--------------------------------------

apt-get update && apt-get upgrade -y --force-yes
apt-get install -y --force-yes git
cd /usr/src
git clone http://git.sip247.com/pbx/fusionpbx-sce-install.git
chmod 755 -R /usr/src/fusionpbx-sce-install
cd fusionpbx-sce-install/debian/

Create a database password to use a good example is to execute the following:

dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g'

Edit the cluster.sh file on each server putting the same db password within the file:

nano -w resources/cluster.sh

#!/bin/sh
########## Edit these values to suit and copy to second machine. Remember to set second machine to 'slave' ##########
export master_ip='192.168.1.116'
export slave_ip='192.168.1.110'
# node_type must be either 'master' or 'slave'
export node_type='master'
#Fill in the database password on each node. Please change the one below to the one generated in the instructions.
export database_password='4iaUT6sqPKSeRAMiPItELbBpBS8'
#####################################################################################################################

Change the masterand slave IPs, enter you DB password and do not forget on the slave to set the node_type to slave.

Once that is done run the following:

./install.sh

For best results run on the master first and then the slave. This is not strictly necessary but we wnat BDR up and running on the master when we attempt to connect the second.





For additional information to get started go to http://docs.fusionpbx.com/en/latest/getting_started.html 


