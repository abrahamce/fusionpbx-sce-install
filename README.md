fusionpbx-sce-install 4.2 version ( with mods. use at own risk)
--------------------------------------
The SCE stands for Simple Cluster Edition. This script will create a two server cluster with the minimum of input.

It is almost as easy as a regular FusionPBX install



**If you are using PROXMOX with LXC containers please complete the procedure at the bottom of the page first**



On the SLAVE node do the following

On the slave we need to allow root SSH which is disabled by default on Debian 8. There will be a instructions to disable this again at the end if you wish to do so.

```
sed -i 's/^PermitRootLogin .*/PermitRootLogin yes/g' /etc/ssh/sshd_config
service ssh restart
apt-get update && apt-get upgrade -y --force-yes

apt-get install -y --force-yes git sshpass

cd /usr/src
git clone -b stable  https://github.com/abrahamce/fusionpbx-sce-install.git
chmod 755 -R /usr/src/fusionpbx-sce-install
cd fusionpbx-sce-install/debian/
```
Now move to the MASTER node and do the following:

```
apt-get update && apt-get upgrade -y --force-yes

apt-get install -y --force-yes git sshpass

cd /usr/src
git clone -b stable  https://github.com/abrahamce/fusionpbx-sce-install.git

chmod 755 -R /usr/src/fusionpbx-sce-install
cd fusionpbx-sce-install/debian/
```

Run the following and follow the instructions onscreen:
```
./install.sh --masternode
```

You will be informed when installation is completed, once that is done, return to the SLAVE node and run:

```
cd /usr/src/fusionpbx-sce-install/debian
./install.sh
```

You will be informed on screen when the installation is completed.

If you wish to disable root password authentication by SSH run the following:
```
sed -i 's/^PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
service ssh restart
```

**Debian on Proxmox LXC**

If using Debian Jessie on Proxmox LXC containers please run the following BEFORE starting the FusionPBX install. 


```
apt-get update && apt-get upgrade
apt-get install systemd
apt-get install systemd-sysv
apt-get install ca-certificates
reboot
```

For additional information to get started go to http://docs.fusionpbx.com/en/latest/getting_started.html 

TODO

~~Get memcache synching~~ - Done

~~Add DSN to SIP profiles~~ - Done

~~Edit autload_configs~~ - Done

~~Sort out XML RPC~~ - Done

~~Turn off auto create schemas~~ - Done

Install Csync2 for file replication

Upgrade to fusion 4.5

sudo service postgresql start

sudo -u postgres psql -c "CREATE DATABASE fusionpbx";
sudo -u postgres psql -c "CREATE DATABASE freeswitch";
sudo -u postgres psql -c "CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD '$password';"
sudo -u postgres psql -c "CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD '$password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch;"
sudo -u postgres psql fusionpbx -c "CREATE EXTENSION btree_gist";
sudo -u postgres psql fusionpbx -c "CREATE EXTENSION pgcrypto";
sudo -u postgres psql freeswitch -c "CREATE EXTENSION btree_gist";
sudo -u postgres psql freeswitch -c "CREATE EXTENSION pgcrypto";
sudo -u postgres psql freeswitch < /usr/src/fusionpbx-sce-install/debian/resources/freeswitch.sql;

cd /var/www/fusionpbx && php /var/www/fusionpbx/core/upgrade/upgrade_schema.php


su postgres
psql
\c fusionpbx
update v_usersupdate v_users set password = '67a1e09bb1f83f5007dc119c14d663aa', salt = 'salt' where       username = 'admin';






