#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

. ./resources/colors.sh
. ./resources/arguments.sh
if [ "$node_type" = "master" ]; then

    echo 1>&2 "Good! We are $node_type"
    echo ""
    echo 1>&2 "Please enter MASTER IP:"
    read master_ip
    echo 1>&2 "Please enter SLAVE IP:"
    read slave_ip
    echo 1>&2 "Please enter SLAVE ROOT PASSWORD:"
    read slave_pass
    echo 1>&2 "Creating and copying SSH keys"
ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
sshpass -p "$slave_pass" ssh-copy-id -o StrictHostKeyChecking=no root@$slave_ip
database_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')
xml_cdr_username=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
xml_cdr_password=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
echo 1>&2 "Writing local cluster file"
printf "export master_ip='$master_ip'\nexport slave_ip='$slave_ip'\nexport node_type='master'\nexport database_password='$database_password'\nexport xml_cdr_username='$xml_cdr_username'\nexport xml_cdr_password='$xml_cdr_password'\n" > /usr/src/fusionpbx-sce-install/debian/resources/cluster.sh
echo 1>&2 "Writing remote cluster file"
printf "export master_ip='$master_ip'\nexport slave_ip='$slave_ip'\nexport node_type='slave'\nexport database_password='$database_password'\nexport xml_cdr_username='$xml_cdr_username'\nexport xml_cdr_password='$xml_cdr_password'\n" | ssh root@$slave_ip 'cat > /usr/src/fusionpbx-sce-install/debian/resources/cluster.sh'
fi
. ./resources/cluster.sh
echo ""
echo ""
echo "Ready to install, press any key to continue or Ctrl+c to abort"
read  test
if [ $CPU_CHECK = true ] && [ $USE_SWITCH_SOURCE = false ]; then
	#check what the CPU and OS are
	OS_test=$(uname -m)
	CPU_arch='unknown'
	OS_bits='unknown'
	CPU_bits='unknown'
	if [ $OS_test = 'armv7l' ]; then
		OS_bits='32'
		CPU_bits='32'
		# RaspberryPi 3 is actually armv8l but current Raspbian reports the cpu as armv7l and no Raspbian 64Bit has been released at this time
		CPU_arch='arm'
	elif [ $OS_test = 'armv8l' ]; then
		# We currently have no test case for armv8l
		OS_bits='unknown'
		CPU_bits='64'
		CPU_arch='arm'
	elif [ $OS_test = 'i386' ]; then
		OS_bits='32'
	if [ "$(grep -o -w 'lm' /proc/cpuinfo)" = 'lm' ]; then
			CPU_bits='64'
		else
			CPU_bits='32'
		fi
		CPU_arch='x86'
	elif [ $OS_test = 'i686' ]; then
		OS_bits='32'
		if [ $(grep -o -w 'lm' /proc/cpuinfo) = 'lm' ]; then
			CPU_bits='64'
		else
			CPU_bits='32'
		fi
		CPU_arch='x86'
	elif [ $OS_test = 'x86_64' ]; then
		OS_bits='64'
		if [ $(grep -o -w 'lm' /proc/cpuinfo) = 'lm' ]; then
			CPU_bits='64'
		else
			CPU_bits='32'
		fi
		CPU_arch='x86'
	fi
	
	if [ $CPU_arch = 'arm' ]; then
		if [ $OS_bits = '32' ]; then
			export USE_SWITCH_PACKAGE_UNOFFICIAL_ARM=true
			verbose "Correct CPU/OS detected, using unofficial arm repo"
		elif [ $OS_bits = '64' ]; then
			error "You are using a 64bit arm OS this is unsupported"
			warning " please rerun with --use-switch-source"
			exit 3
		else
			error "Unknown OS_bits $OS_bits this is unsupported"
			warning " please rerun with --use-switch-source"
			exit 3
		fi
	elif [ $CPU_arch = 'x86' ]; then
		if [ $OS_bits = '32' ]; then
			error "You are using a 32bit OS this is unsupported"
			if [ $CPU_bits = '64' ]; then
				warning " Your CPU is 64bit you should consider reinstalling with a 64bit OS"
			fi
			warning " please rerun with --use-switch-source"
			exit 3
		elif [ $OS_bits = '64' ]; then
			verbose "Correct CPU/OS detected"
		else
			error "Unknown OS_bits $OS_bits this is unsupported"
			warning " please rerun with --use-switch-source"
			exit 3
		fi
	else
		error "You are using a unsupported architecture $CPU_arch"
	fi
fi

# removes the cd img from the /etc/apt/sources.list file (not needed after base install)
sed -i '/cdrom:/d' /etc/apt/sources.list

#Update Debian
verbose "Update Debian"
apt-get upgrade && apt-get update -y --force-yes

#IPTables
resources/iptables.sh

#FusionPBX
resources/fusionpbx.sh

#NGINX web server
resources/nginx.sh

#PHP
resources/php.sh

#Fail2ban
resources/fail2ban.sh

#FreeSWITCH
if [ $USE_SWITCH_SOURCE = true ]; then
	if [ $USE_SWITCH_MASTER = true ]; then
		resources/switch/source-master.sh
	else
		resources/switch/source-release.sh
	fi

	#copy the switch conf files to /etc/freeswitch
	resources/switch/conf-copy.sh

	#set the file permissions
	resources/switch/source-permissions.sh

	#systemd service
	resources/switch/source-systemd.sh

else
	if [ $USE_SWITCH_MASTER = true ]; then
		if [ $USE_SWITCH_PACKAGE_ALL = true ]; then
			resources/switch/package-master-all.sh
		else
			resources/switch/package-master.sh
		fi
	else
		if [ $USE_SWITCH_PACKAGE_ALL = true ]; then
			resources/switch/package-all.sh
		else
			resources/switch/package-release.sh
		fi
	fi

	#copy the switch conf files to /etc/freeswitch
	resources/switch/conf-copy.sh

	#set the file permissions
	resources/switch/package-permissions.sh

	#systemd service
	resources/switch/package-systemd.sh

fi

#Postgres
resources/postgres.sh

#set the ip address
server_address=$(hostname -I)

#restart services
systemctl daemon-reload
systemctl restart php5-fpm
systemctl restart nginx
systemctl restart fail2ban

#add the database schema, user and groups
resources/finish.sh
