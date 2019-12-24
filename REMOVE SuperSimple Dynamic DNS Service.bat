echo off

REM Use nssm to remove the service.
"%~dp0bin\nssm.exe" remove SuperSimpleDynamicDNSUpdater confirm