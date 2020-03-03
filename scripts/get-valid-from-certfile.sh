#!/bin/bash

# File: get-valid-from-certfile.sh
# Usage: Call from userparameter file to get number of days remaining for this ssl cert file
# Version: 1.0
# Author: Jeroen Baten, jbaten@i2rs.nl
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


enddate=$( openssl x509 -in "$1" -noout -enddate | sed -e 's/notAfter=//')
tmpenddate=$(date -d "$enddate" +%s) 
nowdate=$(date -d "now" +%s)
valid=$( echo "( $tmpenddate - $nowdate ) / 86400" | bc )
echo $valid
