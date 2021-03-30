#!/bin/sh
#chkpackage=`dpkg --get-selections | grep mailutils | awk {'print $1'} | egrep -v "libmailutils|common"`;
chkpackage=`dpkg-query -W -f='${Status} ${Version}\n' mailutils | awk {'print $2'}`
srvname=`uname -n`;

if [ "$chkpackage" = "ok" ]; then
	echo "\e[32m The \"Mailutils\" package has already installed\e[0m"
	echo "\e[32m Skip installation!\e[0m"
else
echo "postfix postfix/mailname string $srvname" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
echo "\e[34m --------------------------------------\e[0m"
echo "\e[32m The installation process of mailutils package is in progress!\e[0m"
sudo apt install mailutils -y >> /dev/null

echo "\e[32m The \"Mailutils\" package has been installed successfully\e[0m"
fi

echo "\e[34m --------------------------------------\e[0m"
echo "\e[32m Creating directory to put script into it - /root/scripts!\e[0m"
mkdir /root/scripts

echo -n "Please enter your mail address to get notifications: "
read mail

sudo cat <<EOF > /root/scripts/notify.sh
#!/bin/sh
rm -Rf /root/scripts/srvmessage.txt
rm -Rf /root/scripts/catchmessage.txt
catchsubject="\"Node is not synchronized!"\";
catchmessage="/root/scripts/catchmessage.txt"
echo  "Agoric is not synchronized!Please check!" >>\$catchmessage
catchstatus=\`/root/go/bin/ag-cosmos-helper status 2>&1 | jq .SyncInfo | grep "catching_up" | awk {'print \$2'}\`;
#-----------------------------------------#
status=\`systemctl status ag-chain-cosmos.service | grep "Active:" | awk {'print \$2'}\`;
mailaddr=$mail
srvsubject="\"Service is down!"\";
srvmessage="/root/scripts/srvmessage.txt"
echo  "Agoric Service is down!Please check!" >>\$srvmessage

if [ "\$status" = "inactive" ]; then
	mail -s "\$srvsubject" "\$mailaddr" < \$srvmessage
fi

if [ "\$catchstatus" = "true" ]; then
        mail -s "\$catchsubject" "\$mailaddr" < \$catchmessage
fi
EOF
chmod +x /root/scripts/notify.sh

echo "\e[34m --------------------------------------\e[0m"
echo "\e[32m Creating cron task - /etc/cron.d/notify!\e[0m"
echo "* * * * * root /bin/sh /root/scripts/notify.sh" > /etc/cron.d/notify

echo "\e[31m#----------------------------------------------------------------#\e[0m"
echo "\e[31m# Please note! If your email server is not configured properly!  #\e[0m"
echo "\e[31m# e.g. You don't have SPF/DKIM/DMARC records.                    #\e[0m"
echo "\e[31m# Most probably your message will get to "SPAM"		         #\e[0m"
echo "\e[31m#----------------------------------------------------------------#\e[0m"
