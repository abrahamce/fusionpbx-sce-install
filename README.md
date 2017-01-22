fusionpbx-sce-install
--------------------------------------
The SCE stands for Simple Cluster Edition. This script will create a two server cluster with the minimum of input.
Just change one file and its almost as easy as a regular FusionPBX install

On the SLAVE node do the following

On the slave we need to allow root SSH which is disabled by default on Debian 8. There will be a instructions to disable this at the end if you wish to do so.

```
sed -i 's/^PermitRootLogin .*/PermitRootLogin yes/g' /etc/ssh/sshd_config
service ssh restart
apt-get update && apt-get upgrade -y --force-yes

apt-get install -y --force-yes git

cd /usr/src
git clone http://git.sip247.com/pbx/fusionpbx-sce-install.git

chmod 755 -R /usr/src/fusionpbx-sce-install
cd fusionpbx-sce-install/debian/
```
Now move to the MASTER node and do the following:

```
apt-get update && apt-get upgrade -y --force-yes

apt-get install -y --force-yes git sshpass

cd /usr/src
git clone http://git.sip247.com/pbx/fusionpbx-sce-install.git

chmod 755 -R /usr/src/fusionpbx-sce-install
cd fusionpbx-sce-install/debian/
```

Run the following and follow the instructions onscreen:
```
./install.sh --masternode
```

You will be informed when installation is completed, now return to the SLAVE node and run:

```
cd /usr/src/fusionpbx-sce-install/debian
./installer.sh
```

For additional information to get started go to http://docs.fusionpbx.com/en/latest/getting_started.html 


