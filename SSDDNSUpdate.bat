echo off
:loop
echo %date% %time%

REM --hsts-file NUL: Outputs wget host file to null (no trace)

REM DNSREFRESH is the time between updating DNS in seconds.
REM You may change this variable while the service is running and it will take effect without restarting the service.
SET /A DNSREFRESH=360



REM run wget, fetch urls from input file URL_List.txt, disable hsts file creation, output fetched file to Windows /dev/null, output wget output to file SSDDNS_Update.log for monitoring.
"%~dp0bin\wget.exe" -i "%~dp0URL_List.txt" --no-hsts -O NUL: -a "%~dp0SSDDNSUpdate.log" 

timeout /T %DNSREFRESH% /NOBREAK

goto loop