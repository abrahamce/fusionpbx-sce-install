fusionpbx-sce-install
--------------------------------------

```
apt-get update && apt-get upgrade -y --force-yes
apt-get install -y --force-yes git
cd /usr/src
git clone http://git.sip247.com/pbx/fusionpbx-sce-install.git
chmod 755 -R /usr/src/fusionpbx-sce-install
cd fusionpbx-sce-install/debian/
```

Create a database password to use a good example is to execute the following:

```
dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g'
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



<p>Change the masterand slave IPs, enter you DB password and do not forget on the slave to set the node_type to slave.</p>

<p>Once that is done run the following:</p>

```
./install.sh
```

For best results run on the master first and then the slave. This is not strictly necessary but we wnat BDR up and running on the master when we attempt to connect the second.





For additional information to get started go to http://docs.fusionpbx.com/en/latest/getting_started.html 


