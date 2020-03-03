#!/bin/bash

# File: get-enddate-from-certfile.sh
# Usage: Call from userparameter file to get enddate info from ssl cert file
# Version: 1.0
# Author: Jeroen Baten, jbaten@i2rs.nl
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


enddate=$( openssl x509 -in "$1" -noout -enddate | sed -e 's/notAfter=//')
echo $enddate
