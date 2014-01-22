#!/bin/bash - 
#===============================================================================
#
#          FILE: panel.sh
# 
#         USAGE: ./panel.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Robin Cerny (rc), tschaerni@gmail.com
#  ORGANIZATION: private
#       CREATED: 07.12.2013 18:11:20 CET
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

#Settings:
BASEDIR=$(dirname `readlink -f $0`)
LOCK=$BASEDIR/shutdown.lock
GAMENAME="Starbound Server"
SCREENSESSION=starbound
# MAXMEM angabe in KB
MAXMEM=4000000
memlog=$BASEDIR/mem.log.txt
restartlog=$BASEDIR/restart.log.txt



function timestamp {
	echo -e "[`date +%d.%m.%y` `date +%H:%M:%S`]"
}

usage(){
	echo -e \
"Unknown or no option
Use panel: $0 {start|stop|restart|pidof|memcheck}

Options:
start		Starts the $GAMENAME in screensession $SCREENSESSION with a delay of 5min
stop		Stops the $GAMENAME and terminate screensession $SCREENSESSION with a delay of 5min
restart		Restarts the $GAMENAME with a delay of 5min
pidof		Shows the PID of the $GAMENAME
memcheck	Check usage of RAM and restarts the Server if necessary."
}

start(){
	screen -d -m -S $SCREENSESSION
	echo "starting $GAMENAME on screensession $SCREENSESSION."
	screen -S $SCREENSESSION -p 0 -X stuff "$BASEDIR/start.sh$(printf \\r)"
}

stop(){
	echo "Stopping the $GAMENAME on screensession "$SCREENSESSION"."
	kill $(pid)
	#screen -S $SCREENSESSION -X kill
	#screen -S $SCREENSESSION -p 0 -X stuff "/off$(printf \\r)"
}

pid(){
	pids=$(ps aux | grep ./starbound_server | grep -v grep | awk -F" " '{print $2}')
	echo "$pids"
}

memCHECK(){
	#resMEM=$(grep VmRSS /proc/`pid`/status | cut -d ' ' -f '2')
	resMEM=$(ps aux | grep $(pid) | awk '{print $6}')
	if [ "$resMEM" -gt "$MAXMEM" ] ; then
		echo "$(timestamp) Using $resMEM KB. Restarting." >> $restartlog
		stop
	fi
}

#save(){
#	echo "Saving database."
#	screen -S $SCREENSESSION -p 0 -X stuff "/save$(printf \\r)"
#}


case $1 in

	start)
		start
	;;

	stop)
		touch $LOCK
		stop
	;;

#	save)
#		save
#	;;

	restart)
		stop
		echo "Restart in progress.."
		#sleep 5
		#while true ; do
		#	if [[ -z $(pid) ]] ; then
		#		start
		#		break
		#	fi
		#done
	;;

	pidof)
		pid
	;;

	memcheck)
		memCHECK
		echo "$(timestamp) Using $resMEM KB." >> $memlog
	;;

	*)
		usage
		exit 1
	;;

esac


exit 0
