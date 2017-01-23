fusionpbx-sce-install
--------------------------------------
The SCE stands for Simple Cluster Edition. This script will create a two server cluster with the minimum of input.
It is almost as easy as a regular FusionPBX install

On the SLAVE node do the following

On the slave we need to allow root SSH which is disabled by default on Debian 8. There will be a instructions to disable this again at the end if you wish to do so.

```
sed -i 's/^PermitRootLogin .*/PermitRootLogin yes/g' /etc/ssh/sshd_config
service ssh restart
apt-get update && apt-get upgrade -y --force-yes

apt-get install -y --force-yes git

cd /usr/src
git clone -b stable http://git.sip247.com/pbx/fusionpbx-sce-install.git

chmod 755 -R /usr/src/fusionpbx-sce-install
cd fusionpbx-sce-install/debian/
```
Now move to the MASTER node and do the following:

```
apt-get update && apt-get upgrade -y --force-yes

apt-get install -y --force-yes git sshpass

cd /usr/src
git clone -b stable http://git.sip247.com/pbx/fusionpbx-sce-install.git

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

For additional information to get started go to http://docs.fusionpbx.com/en/latest/getting_started.html 

TODO

~~Get memcache synching~~ Done

Add DSN to SIP profiles

Edit autload_configs

Sort out XML RPC

Turn off auto create schemas

Install Csync2 for file replication



