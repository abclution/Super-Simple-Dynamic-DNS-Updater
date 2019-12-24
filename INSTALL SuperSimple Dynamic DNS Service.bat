echo off

REM Use nssm to create the service.
"%~dp0bin\nssm.exe" install SuperSimpleDynamicDNSUpdater "%~dp0\SSDDNSUpdate.bat"

REM Use nssm to set the app restart period to 10s if it crashes for some reason.
"%~dp0bin\nssm.exe" set SuperSimpleDynamicDNSUpdater AppRestartDelay 10000

REM Use nssm to set service decription.
"%~dp0bin\nssm.exe" set SuperSimpleDynamicDNSUpdater Description "Works with a list of URL's in a text file and uses wget to set the updated ip for services that supports such methods for updates."

REM Use nssm to set service display name.
"%~dp0bin\nssm.exe" set SuperSimpleDynamicDNSUpdater  DisplayName "Super Simple Dynamic DNS Updater"
