#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

. ./colors.sh
. ./arguments.sh
. ./cluster.sh

rpc_user=$xml_cdr_username
rpc_pass=$xml_cdr_password
#send a message
verbose "Installing FusionPBX"

#install dependencies
apt-get install -y --force-yes vim git dbus haveged ssl-cert
apt-get install -y --force-yes ghostscript libtiff5-dev libtiff-tools

if [ $USE_SYSTEM_MASTER = true ]; then
	verbose "Using master"
	BRANCH=""
else
	FUSION_MAJOR=$(git ls-remote --heads https://github.com/fusionpbx/fusionpbx.git | cut -d/ -f 3 | grep -P '^\d+\.\d+' | sort | tail -n 1 | cut -d. -f1)
	FUSION_MINOR=$(git ls-remote --tags https://github.com/fusionpbx/fusionpbx.git $FUSION_MAJOR.* | cut -d/ -f3 |  grep -P '^\d+\.\d+' | sort | tail -n 1 | cut -d. -f2)
	FUSION_VERSION=$FUSION_MAJOR.$FUSION_MINOR
	verbose "Using version $FUSION_VERSION"
	BRANCH="-b $FUSION_VERSION"
fi

#get the source code
git clone $BRANCH https://github.com/fusionpbx/fusionpbx.git /var/www/fusionpbx
cp /usr/src/fusionpbx-sce-install/debian/resources/ha_monitor.lua /var/www/fusionpbx/resources/install/scripts
cp /usr/src/fusionpbx-sce-install/debian/resources/lua.conf.xml /var/www/fusionpbx/resources/templates/conf/autoload_configs/lua.conf.xml
cp /usr/src/fusionpbx-sce-install/debian/resources/modules.conf.xml /var/www/fusionpbx/resources/templates/conf/autoload_configs/modules.conf.xml
cp /usr/src/fusionpbx-sce-install/debian/resources/modules.php /var/www/fusionpbx/app/modules/resources/classes/modules.php
cp /usr/src/fusionpbx-sce-install/debian/resources/internal.xml.noload /var/www/fusionpbx/resources/templates/conf/sip_profiles/internal.xml.noload
cp /usr/src/fusionpbx-sce-install/debian/resources/internal-ipv6.xml.noload /var/www/fusionpbx/resources/templates/conf/sip_profiles/internal-ipv6.xml.noload
cp /usr/src/fusionpbx-sce-install/debian/resources/external.xml.noload /var/www/fusionpbx/resources/templates/conf/sip_profiles/external.xml.noload
cp /usr/src/fusionpbx-sce-install/debian/resources/external-ipv6.xml.noload /var/www/fusionpbx/resources/templates/conf/sip_profiles/external-ipv6.xml.noload
cp /usr/src/fusionpbx-sce-install/debian/resources/callcenter.conf /var/www/fusionpbx/resources/templates/conf/autoload_configs/callcenter.conf
cp /usr/src/fusionpbx-sce-install/debian/resources/db.conf.xml /var/www/fusionpbx/resources/templates/conf/autoload_configs/db.conf.xml
cp /usr/src/fusionpbx-sce-install/debian/resources/fifo.conf.xml /var/www/fusionpbx/resources/templates/conf/autoload_configs/fifo.conf.xml
cp /usr/src/fusionpbx-sce-install/debian/resources/switch.conf.xml /var/www/fusionpbx/resources/templates/conf/autoload_configs/switch.conf.xml
cp /usr/src/fusionpbx-sce-install/debian/resources/vars.xml /var/www/fusionpbx/resources/templates/conf/vars.xml
cp /usr/src/fusionpbx-sce-install/debian/resources/app_defaults.php /var/www/fusionpbx/app/vars/app_defaults.php
sed -i /var/www/fusionpbx/app/vars/app_defaults.php -e s:"dsn_switch_password:$database_password:"
sed -i /var/www/fusionpbx/resources/templates/conf/vars.xml -e s:"dsn_switch_placeholder:pgsql\://hostaddr=127.0.0.1 port=5432 dbname=freeswitch user=freeswitch password=$database_password options='' application_name='freeswitch':"
sed -i /var/www/fusionpbx/resources/templates/conf/sip_profiles/internal.xml.noload -e s:"dsn_system_placeholder:pgsql\://hostaddr=127.0.0.1 port=5432 dbname=fusionpbx user=fusionpbx password=$database_password options='' application_name='fusionpbx':"
sed -i /var/www/fusionpbx/resources/templates/conf/sip_profiles/internal.xml.noload -e s:"dsn_switch_placeholder:pgsql\://hostaddr=127.0.0.1 port=5432 dbname=freeswitch user=freeswitch password=$database_password options='' application_name='freeswitch':"
sed -i /var/www/fusionpbx/resources/templates/conf/sip_profiles/internal-ipv6.xml.noload -e s:"dsn_system_placeholder:pgsql\://hostaddr=127.0.0.1 port=5432 dbname=fusionpbx user=fusionpbx password=$database_password options='' application_name='fusionpbx':"
sed -i /var/www/fusionpbx/resources/templates/conf/sip_profiles/internal-ipv6.xml.noload -e s:"dsn_switch_placeholder:pgsql\://hostaddr=127.0.0.1 port=5432 dbname=freeswitch user=freeswitch password=$database_password options='' application_name='freeswitch':"
sed -i /var/www/fusionpbx/resources/templates/conf/sip_profiles/external.xml.noload -e s:"dsn_system_placeholder:pgsql\://hostaddr=127.0.0.1 port=5432 dbname=fusionpbx user=fusionpbx password=$database_password options='' application_name='fusionpbx':"
sed -i /var/www/fusionpbx/resources/templates/conf/sip_profiles/external.xml.noload -e s:"dsn_switch_placeholder:pgsql\://hostaddr=127.0.0.1 port=5432 dbname=freeswitch user=freeswitch password=$database_password options='' application_name='freeswitch':"
sed -i /var/www/fusionpbx/resources/templates/conf/sip_profiles/external-ipv6.xml.noload -e s:"dsn_system_placeholder:pgsql\://hostaddr=127.0.0.1 port=5432 dbname=fusionpbx user=fusionpbx password=$database_password options='' application_name='fusionpbx':"
sed -i /var/www/fusionpbx/resources/templates/conf/sip_profiles/external-ipv6.xml.noload -e s:"dsn_switch_placeholder:pgsql\://hostaddr=127.0.0.1 port=5432 dbname=freeswitch user=freeswitch password=$database_password options='' application_name='freeswitch':"
sed -i /var/www/fusionpbx/resources/install/scripts/ha_monitor.lua -e s:"rpc_user:$xml_cdr_username:"
sed -i /var/www/fusionpbx/resources/install/scripts/ha_monitor.lua -e s:"rpc_pass:$xml_cdr_password:"
if [ $node_type = 'master' ]; then
    sed -i /var/www/fusionpbx/resources/install/scripts/ha_monitor.lua -e s:"rpc_ip:$slave_ip:"
else
    sed -i /var/www/fusionpbx/resources/install/scripts/ha_monitor.lua -e s:"rpc_ip:$master_ip:"
fi
sed -i /var/www/fusionpbx/resources/templates/conf/autoload_configs/xml_rpc.conf.xml -e s:"8080:8787:"
sed -i /var/www/fusionpbx/resources/templates/conf/autoload_configs/xml_rpc.conf.xml -e s:"name=\"auth-user\" value=\"freeswitch\":name=\"auth-user\" value=\"$rpc_user\":"
sed -i /var/www/fusionpbx/resources/templates/conf/autoload_configs/xml_rpc.conf.xml -e s:"name=\"auth-pass\" value=\"works\":name=\"auth-pass\" value=\"$rpc_pass\":"
chown -R www-data:www-data /var/www/fusionpbx
chmod -R 755 /var/www/fusionpbx/secure
