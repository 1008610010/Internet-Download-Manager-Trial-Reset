@echo off

::================================================================================================
:: Run Script as Administrator

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

::================================================================================================

mode con: cols=80 lines=15
color f0

:maindlg
cls
echo  ##############################################################################
echo  ##                     Internet Download Manager v6.28.x                    ##
echo  ##                                 Trial Reset                              ##
echo  ##                                                                          ##
echo  ##                                 by CHEF-KOCH                             ##
echo  ##############################################################################
echo.
echo  Select your option:
echo.
echo   1:  Activate Internet Download Manager
echo   2:  Deactivate Internet Download Manager
echo   3:  Fix RegKey-Permission after a IDM Update
echo   4:  Exit

:select
set /p product="Select your option: "
echo.

if not defined product goto error
if %product%==1 goto option1
if %product%==2 goto option2
if %product%==3 goto option3
if %product%==4 goto end

:error
echo Error! Try select correct option again.
echo.
goto select

:choice
choice /n /m "Select your option: "
echo.
IF ERRORLEVEL 1 goto option1
IF ERRORLEVEL 2 goto option2
IF ERRORLEVEL 3 goto option3
IF ERRORLEVEL 4 goto end

:option1
taskkill /f /im IDMan.exe
del key1.txt /q
del key2.txt /q

SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192}" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192}" -ot reg -actn setprot -op "dacl:np"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7}" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7}" -ot reg -actn setprot -op "dacl:np"
reg delete HKCU\SOFTWARE\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f
reg delete HKCU\SOFTWARE\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f
reg delete HKCU\SOFTWARE\DownloadManager /v tvfrdt /f
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v FName /f
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v LName /f
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v Email /f
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v Serial /f
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v FName /f /reg:32
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v LName /f /reg:32
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v Email /f /reg:32
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v Serial /f /reg:32
cls
echo.
echo.
echo.
set /p fname=Choose Your Registration Name: 
reg add HKCU\SOFTWARE\DownloadManager /v FName /t REG_SZ /d "%fname%" /f
reg add HKCU\SOFTWARE\DownloadManager /v LName /t REG_SZ /d "" /f
reg add HKCU\SOFTWARE\DownloadManager /v Email /t REG_SZ /d "dummy@tonec.com" /f
reg add HKCU\SOFTWARE\DownloadManager /v Serial /t REG_SZ /d "00000-00000-00000-00000" /f
call :scanskvert HKEY_CURRENT_USER Software\DownloadManager scansk
:scanskvert
echo Windows Registry Editor Version 5.00 > scansk.reg
echo [%~1\%~2] >> scansk.reg
echo "%~3"=hex(0):6f,4e,79,b5,cc,8b,50,bb,f4,b7,e2,6d,2e,38,d2,8b,ad,10,0b,03,a6,1b,53,30,6b,b8,8b,92,d6,04,22,c7,55,b9,a5,33,4d,a8,4e,9b,00,00,00,00,00,00,00,00,00,00 >> scansk.reg
reg  import scansk.reg
del scansk.reg /q

setlocal enabledelayedexpansion

cls
echo.
echo.
echo.
echo Wait a moment for catching some nasty IDM registry keys...

for /F "tokens=2*" %%A in ('reg query "HKCU\SOFTWARE\DownloadManager" /v ExePath') do set IDMAN=%%B

set PM=procmon.exe
start %PM% /AcceptEula /Minimized /LoadConfig Procmon.pmc /Quiet /BackingFile idm.pml
%PM% /waitforidle
"%IDMAN%" /n /d https://download.sysinternals.com/files/ProcessExplorer.zip /p %~dp0 /q
%PM% /Terminate
%PM% /AcceptEula /Minimized /Quiet /OpenLog idm.pml /SaveApplyFilter /SaveAs idm.xml


for /f "tokens=*" %%a in ('findstr /i "<Path>HKCU" idm.xml') do echo %%a>>idmkeys.txt

for /f "tokens=1*delims=:" %%b in ('findstr /n "^" idmkeys.txt') do if %%b equ 1 echo %%c>>key1.txt
for /f "tokens=1*delims=:" %%b in ('findstr /n "^" idmkeys.txt') do if %%b equ 2 echo %%c>>key2.txt


set input=key1.txt
set output=tempkey1-1.txt
set "substr1=WOW6432Node\"

(
    FOR /F "usebackq delims=" %%G IN ("%input%") DO (
        set line=%%G
        echo !line:%substr1%=!
    )
) > %output%

set input=tempkey1-1.txt
set output=tempkey1-2.txt
set "substr2=^<Path^>"

(
    FOR /F "usebackq delims=" %%G IN ("%input%") DO (
        set line=%%G
        echo !line:%substr2%=!
    )
) > %output%

set input=tempkey1-2.txt
set output=key1.txt
set "substr3=^</Path^>"

(
    FOR /F "usebackq delims=" %%G IN ("%input%") DO (
        set line=%%G
        echo !line:%substr3%=!
    )
) > %output%


set input=key2.txt
set output=tempkey2-1.txt
set "substr1=WOW6432Node\"

(
    FOR /F "usebackq delims=" %%G IN ("%input%") DO (
        set line=%%G
        echo !line:%substr1%=!
    )
) > %output%

set input=tempkey2-1.txt
set output=tempkey2-2.txt
set "substr2=^<Path^>"

(
    FOR /F "usebackq delims=" %%G IN ("%input%") DO (
        set line=%%G
        echo !line:%substr2%=!
    )
) > %output%

set input=tempkey2-2.txt
set output=key2.txt
set "substr3=^</Path^>"

(
    FOR /F "usebackq delims=" %%G IN ("%input%") DO (
        set line=%%G
        echo !line:%substr3%=!
    )
) > %output%

EndLocal

set /p key1=<key1.txt
set /p key2=<key2.txt

SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192}" -ot reg -actn setowner -ownr "n:System" -actn setprot -op "dacl:p_nc" -actn clear -clr "dacl"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671}" -ot reg -actn setowner -ownr "n:System" -actn setprot -op "dacl:p_nc"
SetACL.exe -on "%key1%" -ot reg -actn setowner -ownr "n:System" -actn setprot -op "dacl:p_nc"
SetACL.exe -on "%key2%" -ot reg -actn setowner -ownr "n:System" -actn setprot -op "dacl:p_nc"


del ProcessExplorer.zip /q
del idm.pml /q
del idm.xml /q
del idmkeys.txt /q
del tempkey1-1.txt /q
del tempkey1-2.txt /q
del tempkey2-1.txt /q
del tempkey2-2.txt /q

cls
echo.
echo.
echo.
echo The activation process is done!
echo.
echo To go back to the main dialog, press any key...
pause>nul
goto maindlg

:option2
taskkill /f /im IDMan.exe

set /p key1=<key1.txt
set /p key2=<key2.txt

SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192}" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7}" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671}" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC}" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C}" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "%key1%" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "%key2%" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192}" -ot reg -actn setprot -op "dacl:np"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7}" -ot reg -actn setprot -op "dacl:np"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671}" -ot reg -actn setprot -op "dacl:np"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC}" -ot reg -actn setprot -op "dacl:np"
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C}" -ot reg -actn setprot -op "dacl:np"
SetACL.exe -on "%key1%" -ot reg -actn setprot -op "dacl:np"
SetACL.exe -on "%key2%" -ot reg -actn setprot -op "dacl:np"

reg delete HKCU\SOFTWARE\DownloadManager /v scansk /f
reg delete HKCU\SOFTWARE\DownloadManager /v tvfrdt /f
reg delete HKCU\SOFTWARE\DownloadManager /v FName /f
reg delete HKCU\SOFTWARE\DownloadManager /v LName /f
reg delete HKCU\SOFTWARE\DownloadManager /v Email /f
reg delete HKCU\SOFTWARE\DownloadManager /v Serial /f

reg delete "HKLM\SOFTWARE\Internet Download Manager" /v FName /f
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v LName /f
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v Email /f
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v Serial /f
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v FName /f /reg:32
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v LName /f /reg:32
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v Email /f /reg:32
reg delete "HKLM\SOFTWARE\Internet Download Manager" /v Serial /f /reg:32

reg delete HKCU\SOFTWARE\Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f
reg delete HKCU\SOFTWARE\Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f
reg delete HKCU\SOFTWARE\Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f /reg:32
reg delete HKCU\SOFTWARE\Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f /reg:32
reg delete HKCU\SOFTWARE\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f
reg delete HKCU\SOFTWARE\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f
reg delete HKCU\SOFTWARE\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f
reg delete HKCU\SOFTWARE\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f /reg:32
reg delete HKCU\SOFTWARE\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f /reg:32
reg delete HKCU\SOFTWARE\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f /reg:32

cls
echo.
echo.
echo.
echo Deactivation done!
echo.
echo To retunr to the main dialog, press any key...
pause>nul
goto maindlg


:option3
taskkill /f /im IDMan.exe
SetACL.exe -on "HKCU\SOFTWARE\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192}" -ot reg -actn setowner -ownr "n:System" -actn setprot -op "dacl:p_nc" -actn clear -clr "dacl"
cls
echo.
echo.
echo.
echo Fixing RegKey-permission after update done!
echo.
echo To return to the main dialog, press any key...
pause>nul
goto maindlg

:end
exit
