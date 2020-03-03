#!/bin/bash

# File: get-DNS-from-certfile.sh
# Usage: Call from userparameter file to get DNS info from ssl cert file
# Version: 1.0
# Author: Jeroen Baten, jbaten@i2rs.nl
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

domain=$( openssl x509 -in "$1" -noout -text | grep DNS: | sed -e "s/DNS://g" | tr -d '[:space:]' )
echo $domain
