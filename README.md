# Super Simple Dynamic DNS Updater - SSDDNSUpdate.bat
####  2019-12-24 Version: .1 Initial Release

# DESCRIPTON:
A simple way to update dynamic dns hostnames on Windows for compatible providers.

Works with a list of URL's in a text file and uses wget to set the updated ip for services that supports such methods for updating DNS records. As long as the dynamic dns provider gives you a "direct update url", this program should work for it, its Super Simple.

The SSDDNSUpdate.bat connects via wget to those URLS and updates your dynamic dns records on the provider.

Works for IPV4/IPV6 as long as your provider and internet connection does as well!

## Supported Dynamic DNS Providers

### NSUPDATE.INFO -- https://www.nsupdate.info/
Currently known to work With this particular provider.

example IPV4 URL: https://MYDYNAMICHOSTNAME.nsupdate.info:MYSECRETE@ipv4.nsupdate.info/nic/update

example IPV6 URL: https://MYDYNAMICHOSTNAME.nsupdate.info:MYSECRETE@ipv6.nsupdate.info/nic/update


### Freedns -- https://freedns.afraid.org/dynamic/
Should work with the "Direct URL" method on either the v1 or v2 api.

example IPV4 URL: https://freedns.afraid.org/dynamic/update.php?MYSUPERSECRETKEY23kjfj234=

Please note, you will need to have accounts / signed up with these providers for this program to be of any use.


# INSTALLATION:
Extract somewhere convienient, there is no installation.

Please note "IMPORTANT NOTE ABOUT WINDOWS SERVICE and EXTRACTED FILES LOCATION" at the end of this document if you will run it as a service.

# USAGE:

## ADD YOUR UPDATE URLS
Open & edit "URL_List.txt" file with one update URL per line. 

## CHANGE YOUR DYNAMIC DNS UPDATE FREQUENCY
Open & edit "SSDDNSUpdate.bat" and edit the line containing "SET /A DNSREFRESH=360"

The default value is 360 seconds (6 minutes) between updates.
Common Values:
- 120 = 2 minutes
- 300 = 5 minutes
- 900 = 15 minutes
- 3600 = 1 hour

# UPDATING DNS
Run SSDDNSUpdate.bat to update your Dynamic DNS.

It will run in a console window, until closed or Ctrl+C to stop the .bat file.
 

# WINDOWS SERVICE USAGE: 
Run "INSTALL SuperSimple Dynamic DNS Service.bat" - Installs a windows service (SuperSimple Dynamic DNS Service)
Run "EDIT Super Simple Dynamic DNS Service.bat" - To edit the service parameters in case you have special needs.
Run "REMOVE SuperSimple Dynamic DNS Service.bat" - To remove the service. (SuperSimple Dynamic DNS Service)

## IMPORTANT NOTE ABOUT WINDOWS SERVICE and EXTRACTED FILES LOCATION
If you have installed the (SuperSimple Dynamic DNS Service), you should *NOT* move the SuperSimple Dynamic DNS Service files from their current location.
If you find that you would like to move (SuperSimple Dynamic DNS Updater to another folder on your disk, it is reccomended to first 

Run "REMOVE SuperSimple Dynamic DNS Service.bat" then,
Move the Super Simple Dynamic DNS Updater files to the destination you wish.
And finally Run "INSTALL SuperSimple Dynamic DNS Service.bat" to install the service again.


# INCLUDED BINARIES INFORMATION

- wget.exe - WGET the classic file fetch utility from linux land.
 - Wget is used to fetch/connect to the Dynamic DNS provider and update.

- nssm.exe - The Non-Sucking Service Manager http://nssm.cc/
 - NSSM is used to simply create a service for Super Simple Dynamic DNS Updater - SSDDNSUpdate.bat 
