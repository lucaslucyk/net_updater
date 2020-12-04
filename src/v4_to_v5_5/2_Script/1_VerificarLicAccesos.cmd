echo off
SET appName=%1
SET dir=%CD%
IF %appName%.==. SET appName=netTime
del netTime.sl3
del verifyLicAccesos.log
xcopy ..\..\netTime.sl3 *.* /y
sqlite3 "%dir%\%appName%.sl3" ".read verifyLicAccesos.sql"
