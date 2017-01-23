#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./colors.sh
. ./arguments.sh
. ./cluster.sh

#database details
database_host=127.0.0.1
database_port=5432
database_username=fusionpbx
#database_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')

#allow the script to use the new password
export PGPASSWORD=$database_password

#update the database password
sudo -u postgres psql -c "ALTER USER fusionpbx WITH PASSWORD '$database_password';"
sudo -u postgres psql -c "ALTER USER freeswitch WITH PASSWORD '$database_password';"

#add the config.php
mkdir -p /etc/fusionpbx
chown -R www-data:www-data /etc/fusionpbx
cp fusionpbx/config.php /etc/fusionpbx
sed -i /etc/fusionpbx/config.php -e s:'{database_username}:fusionpbx:'
sed -i /etc/fusionpbx/config.php -e s:"{database_password}:$database_password:"

#add the database schema
if [ $node_type = 'master' ]; then
	cd /var/www/fusionpbx && php /var/www/fusionpbx/core/upgrade/upgrade_schema.php > /dev/null 2>&1
fi

#get the server hostname
#domain_name=$(hostname -f)

#get the ip address
domain_name=$(hostname -I | cut -d ' ' -f1)

#get a domain_uuid
domain_uuid=$(/usr/bin/php /var/www/fusionpbx/resources/uuid.php);

#add the domain name
if [ $node_type = 'master' ]; then
	psql --host=$database_host --port=$database_port --username=$database_username -c "insert into v_domains (domain_uuid, domain_name, domain_enabled) values('$domain_uuid', '$domain_name', 'true');"


	#app defaults
	cd /var/www/fusionpbx && php /var/www/fusionpbx/core/upgrade/upgrade_domains.php

	#add the user
	user_uuid=$(/usr/bin/php /var/www/fusionpbx/resources/uuid.php);
	user_salt=$(/usr/bin/php /var/www/fusionpbx/resources/uuid.php);
	user_name=admin
	user_password=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
	password_hash=$(php -r "echo md5('$user_salt$user_password');");
	psql --host=$database_host --port=$database_port --username=$database_username -t -c "insert into v_users (user_uuid, domain_uuid, username, password, salt, user_enabled) values('$user_uuid', '$domain_uuid', '$user_name', '$password_hash', '$user_salt', 'true');"
	#get the superadmin group_uuid
	group_uuid=$(psql --host=$database_host --port=$database_port --username=$database_username -t -c "select group_uuid from v_groups where group_name = 'superadmin';");
	group_uuid=$(echo $group_uuid | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//')

	#add the user to the group
	group_user_uuid=$(/usr/bin/php /var/www/fusionpbx/resources/uuid.php);
	group_name=superadmin
	psql --host=$database_host --port=$database_port --username=$database_username -c "insert into v_group_users (group_user_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$group_user_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"
fi

#add bdr extensions and create group
sudo -u postgres psql fusionpbx -c "CREATE EXTENSION bdr";
sudo -u postgres psql freeswitch -c "CREATE EXTENSION bdr";
if [ $node_type = 'master' ]; then
        sudo -u postgres psql fusionpbx -c "SELECT bdr.bdr_group_create(local_node_name := 'node1_fusionpbx', node_external_dsn := 'host=$master_ip port=5432 dbname=fusionpbx');"
        sudo -u postgres psql freeswitch -c "SELECT bdr.bdr_group_create(local_node_name := 'node1_freeswitch', node_external_dsn := 'host=$master_ip port=5432 dbname=freeswitch');"
elif [ $node_type = 'slave' ]; then
        sudo -u postgres psql fusionpbx -c "SELECT bdr.bdr_group_join(local_node_name := 'node2_fusionpbx', node_external_dsn := 'host=$slave_ip port=5432 dbname=fusionpbx', join_using_dsn := 'host=$master_ip port=5432 dbname=fusionpbx');"
        sudo -u postgres psql freeswitch -c "SELECT bdr.bdr_group_join(local_node_name := 'node2_freeswitch', node_external_dsn := 'host=$slave_ip port=5432 dbname=freeswitch', join_using_dsn := 'host=$master_ip port=5432 dbname=freeswitch');"
fi

#update xml_cdr url, user and password
#xml_cdr_username=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
#xml_cdr_password=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_http_protocol}:http:"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{domain_name}:127.0.0.1:"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_project_path}::"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_user}:$xml_cdr_username:"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_pass}:$xml_cdr_password:"

if [ $node_type = 'slave' ]; then
#Wait for BDR sync to do app defaults
bdr_synced=$(sudo -u postgres psql -qtA fusionpbx -c "SELECT node_status FROM bdr.bdr_nodes WHERE node_name='node2_fusionpbx'" )
while [ "$bdr_synced" != "r" ]
do
sleep 5
bdr_synced=$(sudo -u postgres psql -qtA fusionpbx -c "SELECT node_status FROM bdr.bdr_nodes WHERE node_name='node2_fusionpbx'" )
echo "   Waiting for BDR sync."
done
fi

#app defaults
cd /var/www/fusionpbx && php /var/www/fusionpbx/core/upgrade/upgrade_domains.php

#restart freeswitch
/bin/systemctl daemon-reload
/bin/systemctl restart freeswitch

echo ""
echo ""
verbose "Cleaning up after install."
echo ""
/usr/bin/fs_cli -x "memcache flush"
/bin/systemctl stop freeswitch
rm /var/lib/freeswitch/db/*
/bin/systemctl start freeswitch

#welcome message
if [ $node_type = 'master' ]; then
echo ""
echo ""
verbose "Installation has completed."
echo ""
echo "   Use a web browser to login."
echo "      domain name: https://$domain_name"
echo "      username: $user_name"
echo "      password: $user_password"
echo ""
echo "   The domain name in the browser is used by default as part of the authentication."
echo "   If you need to login to a different domain then use username@domain."
echo "      username: $user_name@$domain_name";
echo ""
echo "   Official FusionPBX Training"
echo "      Admin Training    24 - 26 Jan (3 Days)"
echo "      Advanced Training 31 Jan - Feb 2 (3 Days)"
echo "      Timezone: https://www.timeanddate.com/worldclock/usa/boise"
echo "      For more info visit https://www.fusionpbx.com"
echo ""
echo "   Additional information."
echo "      https://fusionpbx.com/support.php"
echo "      https://www.fusionpbx.com"
echo "      http://docs.fusionpbx.com"
echo ""
else
echo ""
echo ""
verbose "Installation has completed."
echo ""
echo "   Please obtain credentials from master node."
echo ""
echo "   Now you have your cluster, please consider the Official FusionPBX Training"
echo ""
echo "   Official FusionPBX Training"
echo "      Admin Training    24 - 26 Jan (3 Days)"
echo "      Advanced Training 31 Jan - Feb 2 (3 Days)"
echo "      Timezone: https://www.timeanddate.com/worldclock/usa/boise"
echo "      For more info visit https://www.fusionpbx.com"
echo ""
echo "   Additional information."
echo "      https://fusionpbx.com/support.php"
echo "      https://www.fusionpbx.com"
echo "      http://docs.fusionpbx.com"
echo ""
fi
