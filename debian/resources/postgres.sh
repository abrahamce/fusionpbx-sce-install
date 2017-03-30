#!/bin/sh

#includes
. ./resources/cluster.sh

#send a message
echo "Install PostgreSQL"

#generate a random password
password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64)

#install message
echo "Install PostgreSQL and create the database and users\n"

#included in the distribution
#apt-get install -y --force-yes sudo postgresql

#postgres official repository
#echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
#wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
#apt-get update && apt-get upgrade -y
#apt-get install -y --force-yes sudo postgresql

#Add PostgreSQL and BDR REPO
#echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main'  >> /etc/apt/sources.list.d/postgresql.list
echo 'deb http://packages.2ndquadrant.com/bdr/apt/ jessie-2ndquadrant main' >> /etc/apt/sources.list.d/2ndquadrant.list
#/usr/bin/wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
/usr/bin/wget --quiet -O - http://packages.2ndquadrant.com/bdr/apt/AA7A6805.asc | apt-key add -
apt-get update && apt-get upgrade -y
apt-get install -y --force-yes sudo postgresql-bdr-9.4 postgresql-bdr-9.4-bdr-plugin postgresql-bdr-contrib-9.4

cat /usr/src/fusionpbx-sce-install/debian/resources/postgresql.conf >> /etc/postgresql/9.4/main/postgresql.conf
chown postgres:postgres /etc/postgresql/9.4/main/postgresql.conf

#systemd
systemctl daemon-reload
systemctl restart postgresql

#init.d
#/usr/sbin/service postgresql restart

cat <<EOF > /etc/postgresql/9.4/main/pg_hba.conf
# Database administrative login by Unix domain socket
local   all             postgres                                peer
# TYPE  DATABASE        USER            ADDRESS                 METHOD
# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
hostssl all             all             $master_ip/32   trust
hostssl all             all             $slave_ip/32    trust
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
hostssl   replication   postgres        $master_ip/32           trust
hostssl   replication   postgres        $slave_ip/32            trust
EOF

systemctl restart postgresql

#move to /tmp to prevent a red herring error when running sudo with psql
cwd=$(pwd)
cd /tmp
#add the databases, users and grant permissions to them
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
if [ $node_type = 'master' ]; then
	sudo -u postgres psql freeswitch < /usr/src/fusionpbx-sce-install/debian/resources/freeswitch.sql;
fi
#ALTER USER fusionpbx WITH PASSWORD 'newpassword';
cd $cwd

#set the ip address
#server_address=$(hostname -I)
