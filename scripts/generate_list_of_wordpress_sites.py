#!/usr/bin/python3
# File: generate_list_of_wordpress_sites.py
# Usage: Call from userparameter file to get list off all web sites.
#        Disable the checks on sites that are not wordpress.
# Version: 2.0
# Author: Jeroen Baten, jbaten@i2rs.nl
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# USE LLD to create item prototypes based on domain
# use trapper to send values into item prototypes
# 20200522 J.Baten Rewrite from bash to python3

import sys,os
from pprint import pprint,pformat
from apacheconfig import *

folderpath = r"/etc/apache2/sites-enabled/" # make sure to put the 'r' in front
filepaths  = [os.path.join(folderpath, name) for name in os.listdir(folderpath)]

# we need to generate something like:
# {
#"data": [
#{"{#HOST}": "i2rs.nl","{#PROTO}": "http","{#DOCROOT}": "/srv/www/default"}

print("{")
print("\"data\": [")

options = {
    'lowercasenames': True
}

firstline=True

for path in filepaths:
    #print("")
    #print("Doing " + path)

    with make_loader(**options) as loader:
        config = loader.load(path)

    for vhost in config["virtualhost"]:
        if isinstance(vhost, str):
            vhost=config["virtualhost"]
        for vhost2 in vhost.keys():
          if "80" in vhost2:
              proto="http"
          if "443" in vhost2:
              proto="https"

          if "servername" in vhost[vhost2].keys():
            servername=vhost[vhost2].get("servername")
          if "documentroot" in vhost[vhost2].keys():
            documentroot=vhost[vhost2].get("documentroot")

    #Do not print a seperation comma before the first output line printed
    if firstline == False:
        print(",")
    else:
        firstline=False

    print("{\"{#HOST}\": \"" + servername + "\",\"{#PROTO}\": \"" + proto + "\",\"{#DOCROOT}\": \"" + documentroot + "\"}" )

print("")
print("]")
print("}")

