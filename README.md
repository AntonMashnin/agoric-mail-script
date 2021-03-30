# agoric-mail-script
Agoric Mail Script Notification

This is a bash script to notification the end-user if some problem with Agoric Service or Agoric Synchronization is happened.

## Requirements
There is no special requirements. The bash script will install all necessary software and perform all configuration autoamtiacally

You just need to install 'wget' tool to make possabillity run and install it:
```
sudo apt install wget -y
```

## Feauters
- Send notfication if your service is down
- Send notification if the "catching up" status is "true"

## Notes
- During installation process you need to set your mail address
- Please note: if your mail service is not configured properly (you don't have SPF/DKIM/DMARC records) most probably the notification message will be delivered to the spam directory
 
## Installation
To configure notification tool please run:
```
sudo wget https://raw.githubusercontent.com/AntonMashnin/agoric-mail-script/main/notification.sh
sudo chmod +x notification.sh
sudo ./notification.sh
```
