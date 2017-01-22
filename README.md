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

Edit the cluster.sh file on each server putting the same db password within the file:

```
nano -w resources/cluster.sh
```

<p>#!/bin/sh</p>
<p>########## Edit these values to suit and copy to second machine. Remember to set second machine to 'slave' ##########</p>
<p>export master_ip='192.168.1.116'</p>
<p>export slave_ip='192.168.1.110'</p>
<p>## node_type must be either 'master' or 'slave'</p>
<p>export node_type='master'</p>
<p>#Fill in the database password on each node. Please change the one below to the one generated in the instructions.</p>
<p>export database_password='4iaUT6sqPKSeRAMiPItELbBpBS8'</p>
<p>#####################################################################################################################</p>



<p>Change the master and slave IPs, enter you DB password and do not forget on the slave to set the node_type to slave.</p>

<p>Once that is done run the following:</p>

```
./install.sh
```

For best results run on the master first and then the slave. This is not strictly necessary but we want BDR up and running on the master when we attempt to connect the second.





For additional information to get started go to http://docs.fusionpbx.com/en/latest/getting_started.html 


