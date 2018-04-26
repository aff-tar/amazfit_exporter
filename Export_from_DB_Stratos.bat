@echo off
echo *******************************************************
echo ** PGM download sport_data from the Huami watch      **
echo ** and export to TCX or GPX                          **
echo *******************************************************
echo .

IF EXIST %cd%\db\sport_data.db GOTO DB_EXISTS

echo *******************************************************
echo ** sport_data.db not exist in your PC                **
echo *******************************************************
echo .
GOTO DB_DOWNL

:DB_EXISTS
echo *******************************************************
echo ** sport_data.db exist in your PC                    **
echo *******************************************************
echo .

:VYBER_DB_EXISTS
echo *******************************************************
echo ** Do you want download again?   press Y/N           **
echo ******************************************************* 

SET M=
SET /P M=**  and press Enter                                  **  
IF %M%==Y GOTO DB_DOWNL
IF %M%==y GOTO DB_DOWNL
IF %M%==N GOTO EXPORT
IF %M%==n GOTO EXPORT

echo *******************************************************
ECHO **          "%M%" isn't correct choice                 ** 
echo ******************************************************* 
echo .

GOTO VYBER_DB_EXISTS


:DB_DOWNL
echo *******************************************************
echo ** Connect your watch to PC and press ENTER           **
SET M=
SET /P M=*******************************************************  
echo .

echo *******************************************************
echo ** Download sport_data.db                            **
echo ** If is not response, then reconnect your watch.    **
echo *******************************************************
echo .
%cd%\adb\adb devices
%cd%\adb\adb wait-for-device
%cd%\adb\adb backup -f export_data.ab -noapk com.huami.watch.newsport
java -jar %cd%\pgm\abe.jar unpack export_data.ab export_data.tar
"C:\Program Files\7-Zip\7z.exe"  x export_data.tar
mkdir db
copy apps\com.huami.watch.newsport\db\sport_data.db* db
%cd%\adb\adb wait-for-device
%cd%\adb\adb kill-server
%cd%\adb\adb wait-for-device

IF EXIST %cd%\db GOTO COPY_DB
MD %cd%\db
:COPY_DB
MOVE %cd%\sport_data.db %cd%\db\sport_data.db
echo *******************************************************
echo ** Download sport_data.db is completed.              **
echo *******************************************************
echo .

:EXPORT
:VYBER

:TCX_EXPORT
echo *******************************************************
echo ** Exporting to TCX                                  **
echo ******************************************************* 
echo .
IF EXIST %cd%\export\TCX GOTO TCX
MD %cd%\export\TCX
:TCX
python pgm/tcx/amazfit_exporter_cli.py db/sport_data.db %cd%/export/TCX
START %cd%\export\TCX
echo *******************************************************
echo ** Export to TCX is done                             **
echo *******************************************************
echo .

:EXIT
pause