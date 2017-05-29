#!/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#ombiUpdater-sh - v1.01 - https://github.com/BrianDMG/ombiUpdater-sh
#This script will update your Ombi install to the latest version from GitHub

#-----------------------------------------------------------------------------------------------------------------------------------------------
#User-defined variables
	#Local Ombi directory
	OMBIDIR=/usr/local/share/ombi
	#Backup directory
	BACKUPDIR=/usr/local/share/ombi_bk
	#OmbiIP (IP or hostname)
	OMBIHOST=
	OMBIAPIKEY='ombiapikey'
#SSMTP variables
	#To address
	TO="example@example.com"
	#From adderess
	FROM="example@example.com"
	#Subject
	SUBJECT="Ombi updated"
	#Body
	BODY="<html><head><meta charset="UTF-8" /></head><body>The Ombi server has been updated to <strong>v$LOCALVER</strong>.<br><a href=https://github.com/tidusjar/Ombi/releases/tag/v$LOCALVER target=_blank>Release notes</a></body></html>"
#-----------------------------------------------------------------------------------------------------------------------------------------------

#Get Ombi version with cURL, save to file ./ombiver
curl -o ombiver -k "https://$OMBIHOST/api/version?apikey=$OMBIAPIKEY"

#Strip " and . from cURL results for mathematical comparison, set as LOCALVER
LOCALVER=$(cat ombiver | sed -r 's/\"//g')
LOCALVERCOMP=$(cat ombiver | sed -r 's/\"//g' | sed -r 's/\.//g')

#Scrape Github for latest release tag info, strip all but the numbers for mathematical comparison
REMOTEVER=$(curl -s https://api.github.com/repos/tidusjar/Ombi/releases/latest | grep 'tag_' | cut -d\" -f4 | sed -r 's/v//g')
REMOTEVERCOMP=$(curl -s https://api.github.com/repos/tidusjar/Ombi/releases/latest | grep 'tag_' | cut -d\" -f4 | sed -r 's/v//g' | sed -r 's/\.//g')

#Compare LOCALVER and REMOTEVER	
	#If the remote version is higher than the local version, update
	if [ $REMOTEVERCOMP -gt $LOCALVERCOMP ] 
	then
	#Download latest release to /tmp
	(cd /tmp; wget $(curl -s https://api.github.com/repos/tidusjar/Ombi/releases/latest | grep 'browser_' | cut -d\" -f4))
	
	#Unzip Ombi.zip to /tmp
	unzip /tmp/Ombi.zip
	rm -f /tmp/Ombi.zip
	
	#Stop Ombi and nginx
	killall -9 mono-sgen
	killall -9 nginx

	#Backup existing Ombi directory
	mkdir -p "$BACKUPDIR"
	mv -r "$OMBIDIR/*" "$BACKUPDIR"

	#Overwrite old Ombi install
	mv -r /tmp/Release/* "$OMBIDIR"
	rm -rf /tmp/Release
	
	#Start Ombi and nginx
	/usr/local/bin/screen -d -m -S root nohup /usr/local/bin/mono $OMBIDIR/Ombi.exe
	service nginx start

	#Use sendmail/ssmtp to send email to post to Wordpress
	( 
	echo "From: $FROM"
	echo "To: $TO"
	echo "MIME-Version: 1.0"
	echo "Content-Type: text/html"
	echo "Subject: $SUBJECT"
	echo "$BODY"
	) | sendmail -f $FROM $TO

#Otherwise, exit.
else
echo "Already on the latest release (v$LOCALVER)"
fi
#Remove ombiver
rm -f ombiver
exit
