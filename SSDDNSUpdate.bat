echo off
setlocal enabledelayedexpansion
:loop
echo %date% %time%

REM ------------------------------------------
REM DNSREFRESH is the time between updating DNS in seconds.
REM You may change this variable while the service is running and it will take effect without restarting the service.
SET /A DNSREFRESH=60
REM ------------------------------------------

REM ------------------------------------------
REM URL's to the service that will return your ip.
SET IPV4URL="https://ipv4.nsupdate.info/myip"
SET IPV6URL="https://ipv6.nsupdate.info/myip"
REM ------------------------------------------

REM ------------------------------------------
REM Logging...
ECHO Updating this machines current IPV4 address to local file IPV4_CURRENT...
ECHO Updating this machines current IPV4 address to local file IPV4_CURRENT... >> "%~dp0SSDDNSUpdate.log"
REM WGet IPV4 IP and write to file
REM -t,  --tries=NUMBER              set number of retries to NUMBER (0 unlimits)
REM -T,  --timeout=SECONDS           set all timeout values to SECONDS
"%~dp0bin\wget.exe" "%IPV4URL%" -t 2 -T 3 --no-hsts -O "%~dp0\IPV4_CURRENT" -a "%~dp0SSDDNSUpdate.log" 
REM Logging...
ECHO Updating this machines current IPV6 address to local file IPV6_CURRENT...
ECHO Updating this machines current IPV6 address to local file IPV6_CURRENT... >> "%~dp0SSDDNSUpdate.log"
REM WGet IPV6 IP and write to file
"%~dp0bin\wget.exe" "%IPV6URL%" -t 2 -T 3 --no-hsts -O "%~dp0\IPV6_CURRENT" -a "%~dp0SSDDNSUpdate.log" 
REM ------------------------------------------

REM PAUSE

REM ------------------------------------------
REM Splits the URL List into each domain
FOR /F "tokens=2,3,4 delims=/:@" %%G IN (URL_List.txt) DO ( 
REM echo %%G g
REM echo %%H h
REM echo %%I i
REM IMPORT Current IP from previous step from file to variables.
REM I realize this reads the files during each loop but BAT files and local / global variables is confuz.
	set /p IPV4_CURRENT=<IPV4_CURRENT
	set /p IPV6_CURRENT=<IPV6_CURRENT

	REM Based on update URL, figure out if this is for an IPV4 or IPV6 update.
	REM If its for IPV4, ping it and get the IP.
	IF %%I==ipv4.nsupdate.info ( 
		 for /f "tokens=1,2 delims=[]" %%A in ('ping -4 -n 1 -w 1 %%G ^| find "Pinging"') do ( SET IPADDRESS=%%B
			REM Logging...
			echo %%G - IPV4 Address Detected, checking for changes... >> "%~dp0SSDDNSUpdate.log"
			echo !IPADDRESS!	- DNS RECORD >> "%~dp0SSDDNSUpdate.log"
			echo !IPV4_CURRENT!	- CURRENT IP  >> "%~dp0SSDDNSUpdate.log"
			echo %%G - IPV4 Address Detected, checking for changes...
			echo !IPADDRESS!	- DNS RECORD
			echo !IPV4_CURRENT!	- CURRENT IP  
			REM Check if DNS RECORD and CURRENT IP match.
 			IF NOT !IPADDRESS!==!IPV4_CURRENT! ( echo "IP differs, updating IPV4 record..."
				REM Logging...
				echo "%~dp0bin\wget.exe" -t 2 -T 3 "https://%%G:%%H@%%I/nic/update" --no-hsts -O NUL: -a "%~dp0SSDDNSUpdate.log" >> "%~dp0SSDDNSUpdate.log"
				REM Update the IPV4 record via wget.
				"%~dp0bin\wget.exe" -t 2 -T 3 "https://%%G:%%H@%%I/nic/update" --no-hsts -O NUL: -a "%~dp0SSDDNSUpdate.log"
		)
		REM Logging...
		echo ------------------------------------------------------------------
		echo ------------------------------------------------------------------ >> "%~dp0SSDDNSUpdate.log"
		REM PAUSE
		
		)
	
	REM If its not for IPV4 (IPV6), ping it and get the IP.	
	) ELSE ( for /f "tokens=1,2 delims=[]" %%A in ('ping -6 -n 1 -w 1 %%G ^| find "Pinging"') do ( SET IPADDRESS=%%B
			echo %%G - IPV6 Address Detected, checking for changes... >> "%~dp0SSDDNSUpdate.log"
			echo !IPADDRESS!	- DNS RECORD >> "%~dp0SSDDNSUpdate.log"
			echo !IPV6_CURRENT!	- CURRENT IP  >> "%~dp0SSDDNSUpdate.log"
			echo %%G - IPV6 Address Detected, checking for changes...
			echo !IPADDRESS!	- DNS RECORD
			echo !IPV6_CURRENT!	- CURRENT IP  
			IF NOT !IPADDRESS!==!IPV6_CURRENT! ( echo "IP differs, updating IPV6 record..."
				echo "%~dp0bin\wget.exe" -t 2 -T 3 "https://%%G:%%H@%%I/nic/update" --no-hsts -O NUL: -a "%~dp0SSDDNSUpdate.log" >> "%~dp0SSDDNSUpdate.log"
				"%~dp0bin\wget.exe" -t 2 -T 3 "https://%%G:%%H@%%I/nic/update" --no-hsts -O NUL: -a "%~dp0SSDDNSUpdate.log"
		)
		REM Logging...
		echo ------------------------------------------------------------------
		echo ------------------------------------------------------------------ >> "%~dp0SSDDNSUpdate.log"
		REM PAUSE
		)
	
	
	)
	
	REM NOTE: Unset IPADDRESS because if domain is stuck or doesn't exist, it would use the previous IP in the loop.
	REM Domains set to abuse status, their DNS record doesn't exist and goofs up the loop.
	SET IPADDRESS=	
)

timeout /T %DNSREFRESH% /NOBREAK
goto loop
