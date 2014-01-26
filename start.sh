#!/bin/bash - 
#===============================================================================
#
#          FILE: start.sh
# 
#         USAGE: ./start.sh 
# 
#   DESCRIPTION: Start script for the Starbound Server
# 
#       OPTIONS: ---
#  REQUIREMENTS: screen
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Robin Cerny (rc), tschaerni@gmail.com
#  ORGANIZATION: private
#       CREATED: 29.11.2013 04:15:59 CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
BASEDIR=$(dirname `readlink -f $0`)
LOCK=$BASEDIR/shutdown.lock
#Settings:
SCREENSESSION=starbound
cmd="$BASEDIR/linux64/starbound_server"
while true; do
	if [ -f $LOCK ] ; then
		rm $LOCK
		screen -d $SCREENSESSION
		screen -S $SCREENSESSION -X kill
		exit 0
	else
		$cmd
	fi

	sleep 5
done
