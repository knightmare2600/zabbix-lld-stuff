#!/bin/bash

# File: generate_zabbix_ssl_cert_lld_data_v3.sh
# Usage: Call from userparameter file to get list off all ssl certificate files.

# Version: 3.0
# Author: Jeroen Baten, jbaten@i2rs.nl
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# USE LLD to create item prototypes based on domain
# use trapper to send values into item prototypes

# Find IP of Zabbix Server for trapper:
ZABBIX_SERVER=$( grep -i "^Server=" /etc/zabbix/zabbix_agentd.conf | sed -e 's/Server=//' | tr -d '[:space:]' )
ZABBIX_HOSTNAME=$( grep -i "^Hostname=" /etc/zabbix/zabbix_agentd.conf | sed -e 's/Hostname=//'  )
LOGFILE=/tmp/generate_zabbix_ssl_cert_lld_data.log
echo "Start" > $LOGFILE
echo "Time: $(date)" >> $LOGFILE
echo "ZABBIX_SERVER=$ZABBIX_SERVER" >> $LOGFILE
echo "ZABBIX_HOSTNAME=$ZABBIX_HOSTNAME" >> $LOGFILE

echo "{"
echo '"data": ['
fmt="{\"{#%s}\": %s}"
first=0
for sslfile in $( cat /etc/apache2/sites-enabled/*.conf |  grep SSLCertificateFile |  grep   "^[^#]*$" | sed -e "s/SSLCertificateFile//"  | sort -u  )
do
	echo "sslfile = $sslfile" >> $LOGFILE
	if [ -e ${sslfile} ]
	then
		if [[ $first -ne 0 ]]; then
	 		echo ","
		fi
		echo "${sslfile}" >> $LOGFILE
		printf "$fmt" CERTFILE "\"${sslfile}\""
		first=1
	else
		echo "File ${sslfile} not found" >> $LOGFILE 
	fi
done
echo ""
echo "]"
echo "}"
