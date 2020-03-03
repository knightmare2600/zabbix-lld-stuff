<?PHP

# script to test remotely if wordpress update is needed
# Put this script in the root of jour wordpress directory.
# Tested on WordPress 3.6 and newer
# Author: Jeroen Baten, jbaten@i2rs.nl
# 1.0 J.Baten september 17, 2013
# 2.0 J.Baten december 6, 2019 : change to JSON output
# License: MPL

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# set max error output to force correct code. :-)
ini_set('display_errors',1);
ini_set('display_startup_errors',1);
error_reporting(-1);

if( php_sapi_name() !== 'cli' ) {
        die("0");
}

require('wp-load.php');

$user_id=1;
$current_user = get_user_by( 'id', $user_id );
$result=wp_get_update_data();
#print_r($result);

$myJSON =  json_encode($result["counts"]);
echo $myJSON;

?>
