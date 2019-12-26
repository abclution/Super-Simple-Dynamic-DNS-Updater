echo off
setlocal enabledelayedexpansion

:loop
echo %date% %time%

REM DNSREFRESH is the time between updating DNS in seconds.
REM You may change this variable while the service is running and it will take effect without restarting the service.
SET /A DNSREFRESH=360


REM ------------------------------------------
REM Get current IP's, write to file

rem https://ipv4.nsupdate.info/myip (to get your current IPv4 address)
rem https://ipv6.nsupdate.info/myip (to get your current IPv6 address)

SET IPV4URL="https://ipv4.nsupdate.info/myip"
SET IPV6URL="https://ipv6.nsupdate.info/myip"

ECHO Updating this machines current IPV4 address to local file IPV4_CURRENT...
ECHO Updating this machines current IPV4 address to local file IPV4_CURRENT... >> "%~dp0SSDDNSUpdate.log"
"%~dp0bin\wget.exe" "%IPV4URL%" --no-hsts -O "%~dp0\IPV4_CURRENT" -a "%~dp0SSDDNSUpdate.log" 
ECHO Updating this machines current IPV6 address to local file IPV6_CURRENT...
ECHO Updating this machines current IPV6 address to local file IPV6_CURRENT... >> "%~dp0SSDDNSUpdate.log"
"%~dp0bin\wget.exe" "%IPV6URL%" --no-hsts -O "%~dp0\IPV6_CURRENT" -a "%~dp0SSDDNSUpdate.log" 

REM Set variables from saved loaded files
REM set /p IPV4_CURRENT=<IPV4_CURRENT
REM set /p IPV6_CURRENT=<IPV6_CURRENT

REM PAUSE


rem this line returns the correct info
REM Splits the URL List into each domain
FOR /F "tokens=2,3,4 delims=/:@" %%G IN (URL_List.txt) DO ( 
	set /p IPV4_CURRENT=<IPV4_CURRENT
	set /p IPV6_CURRENT=<IPV6_CURRENT
	rem echo %IPV4_CURRENT%
	rem echo %IPV6_CURRENT%
	rem echo DNSNAME		%%G is 
	rem echo SECRET	%%H is 
	rem echo URL		%%I is 
	
	IF %%I==ipv4.nsupdate.info ( 
		 for /f "tokens=1,2 delims=[]" %%A in ('ping -4 -n 1 -w 1 %%G ^| find "Pinging"') do ( SET IPADDRESS=%%B
		echo %%G - IPV4 Address Detected, checking for changes... >> "%~dp0SSDDNSUpdate.log"
		echo !IPADDRESS!	- DNS RECORD >> "%~dp0SSDDNSUpdate.log"
		echo !IPV4_CURRENT!	- CURRENT IP  >> "%~dp0SSDDNSUpdate.log"
		echo %%G - IPV4 Address Detected, checking for changes...
		echo !IPADDRESS!	- DNS RECORD
		echo !IPV4_CURRENT!	- CURRENT IP  
				IF NOT !IPADDRESS!==!IPV4_CURRENT! ( echo "IP differs, updating IPV4 record..."
		echo "%~dp0bin\wget.exe" "https://%%G:%%H@%%I/nic/update" --no-hsts -O NUL: -a "%~dp0SSDDNSUpdate.log" >> "%~dp0SSDDNSUpdate.log"
		"%~dp0bin\wget.exe" "https://%%G:%%H@%%I/nic/update" --no-hsts -O NUL: -a "%~dp0SSDDNSUpdate.log"
		)
		echo ------------------------------------------------------------------
		echo ------------------------------------------------------------------ >> "%~dp0SSDDNSUpdate.log"
		
		
		)
	
	
	) ELSE ( for /f "tokens=1,2 delims=[]" %%A in ('ping -6 -n 1 -w 1 %%G ^| find "Pinging"') do ( SET IPADDRESS=%%B
		echo %%G - IPV6 Address Detected, checking for changes... >> "%~dp0SSDDNSUpdate.log"
		echo !IPADDRESS!	- DNS RECORD >> "%~dp0SSDDNSUpdate.log"
	    echo !IPV6_CURRENT!	- CURRENT IP  >> "%~dp0SSDDNSUpdate.log"
		echo %%G - IPV6 Address Detected, checking for changes...
		echo !IPADDRESS!	- DNS RECORD
	    echo !IPV6_CURRENT!	- CURRENT IP  
				IF NOT !IPADDRESS!==!IPV6_CURRENT! ( echo "IP differs, updating IPV6 record..."
		echo "%~dp0bin\wget.exe" "https://%%G:%%H@%%I/nic/update" --no-hsts -O NUL: -a "%~dp0SSDDNSUpdate.log" >> "%~dp0SSDDNSUpdate.log"
		"%~dp0bin\wget.exe" "https://%%G:%%H@%%I/nic/update" --no-hsts -O NUL: -a "%~dp0SSDDNSUpdate.log"
		)
		echo ------------------------------------------------------------------
		echo ------------------------------------------------------------------ >> "%~dp0SSDDNSUpdate.log"
		
		)
	
	
	)
	

	REM NOTE: Unset IPADDRESS because if domain is stuck or doesn't exist, it would use the previous IP in the loop.
	SET IPADDRESS=	
)

timeout /T %DNSREFRESH% /NOBREAK

goto loop
