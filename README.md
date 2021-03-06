# ombiUpdater-sh
Script that creates a backup of and updates your Ombi server, then sends a notification email using ssmpt.

<b><u>Dependencies</u></b><br>
This script requires that ssmtp be installed and configured. (<a href="https://www.nixtutor.com/linux/send-mail-with-gmail-and-ssmtp/">Setup Guide</a>)<br><br>
<b>Usage</b><br>
This script can be run manually or as a cron job. Ensure the script has proper permissions (<i>chmod 755</i>) before executing.<br><br>
<b>User-defined variables</b><br>
There are several user-defined variables you will need to edit using your text editor of choice.<br><br>
<b>OMBIDIR</b> = the path to the Ombi executable (<i>no trailing "/"</i>)<br>
<b>BACKUPDIR</b> = the path to the directory where you want to store Ombi backups generated by this script.<br> 
<b>OMBIHOST</b> = The IP address or hostname of your Ombi server.<br>
<b>OMBIAPIKEY</b> = Your Ombi API key (<i>found under Settings -> Ombi Configuration</i>)<br>
<b>TO</b> = The recipient for the notification email<br>
<b>FROM</b> = The sender for the notification email.<br>
<b>SUBJECT</b> = The subject for the notification email.<br> 
<b>BODY</b> = The notification email body.
