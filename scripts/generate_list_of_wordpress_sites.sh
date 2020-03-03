#!/bin/bash

# File: generate_list_of_wordpress_sites.sh
# Usage: Call from userparameter file to get list off all web sites.
#        Disable the checks on sites that are not wordpress.
# Version: 1.0
# Author: Jeroen Baten, jbaten@i2rs.nl
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# USE LLD to create item prototypes based on domain
# use trapper to send values into item prototypes

LOGFILE=/tmp/generate_zabbix_lld-vhosts.log
echo "Start" > $LOGFILE
echo "Time: $(date)" >> $LOGFILE
#echo $LOGFILE

echo "{"
echo '"data": ['
fmt="{\"{#%s}\": %s,\"{#%s}\": %s,\"{#%s}\": %s}"
first=0
for file in $( ls /etc/apache2/sites-enabled/*.conf )
do
  while read -a line
  do
    case ${line[0]} in
      \<VirtualHost)
        vhost=${line[1]:0:(-1)}      
	# if vhost contains 80 set to http
        if [[ $vhost == *"80"* ]]; then
	  prot="http"
	fi
	# if vhost contains 443 set to https
        if [[ $vhost == *"443"* ]]; then
	  prot="https"
	fi
        #printf "vhost=%s\n" ${line[1]:0:(-1)}
        ;;
      ServerName)
        servername=${line[1]}
        ;;
     DocumentRoot)
	docroot=${line[1]}
	;;
     \</VirtualHost\>)
	if [[ ${#docroot} -gt 0 ]]; then
	  if [[ $first -ne 0 ]]; then
	    echo ","
  	  fi
	  first=1
  	  printf "$fmt" HOST "\"${servername}\"" PROTO "\"${prot}\"" DOCROOT "${docroot}"
          printf "\n"
	fi
        ;;
    esac
  done < $file
done

echo ""
echo "]"
echo "}"
