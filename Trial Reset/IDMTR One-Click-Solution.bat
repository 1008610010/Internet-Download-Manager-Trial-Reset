@echo off

:: Admin rights check
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

@ECHO OFF
TASKKILL /F /IM IDMan.exe
TASKKILL /F /IM IEMonitor.exe
Timeout 2
@ECHO.

::delete key value
::key 1: {7B8E9164-324D-4A2E-A46D-0165FB2000EC}

REG DELETE HKEY_CLASSES_ROOT\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\Wow6432Node\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\Wow6432Node\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f

::key 2: {6DDF00DB-1234-46EC-8356-27E7B2051192}

REG DELETE HKEY_CLASSES_ROOT\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\Wow6432Node\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\Wow6432Node\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f

::key 3: {D5B91409-A8CA-4973-9A0B-59F713D25671}

REG DELETE HKEY_CLASSES_ROOT\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\Wow6432Node\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\Wow6432Node\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f

::key 4: {07999AC3-058B-40BF-984F-69EB1E554CA7}

REG DELETE HKEY_CLASSES_ROOT\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\Wow6432Node\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\Wow6432Node\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f

::key 5: {5ED60779-4DE2-4E07-B862-974CA4FF2E9C}

REG DELETE HKEY_CLASSES_ROOT\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f
REG DELETE HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f
REG DELETE HKEY_CURRENT_USER\Software\Classes\Wow6432Node\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f
REG DELETE HKEY_LOCAL_MACHINE\Software\Classes\Wow6432Node\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f


@ECHO OFF

::delete key value in SID even if not required
::------------------------------------------------------------------------------------------------------------------------------------
::------------------------------------------------------------------------------------------------------------------------------------
setlocal
set cmd="wmic useraccount where name='%username%' get sid"
for /f "skip=1" %%i IN ( ' %cmd% ' ) DO if not defined SID set "SID=%%i"
echo %SID%

REG DELETE HKEY_USERS\%SID%\Software\Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f
REG DELETE HKEY_USERS\%SID%_Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f
REG DELETE HKEY_USERS\%SID%\Software\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f
REG DELETE HKEY_USERS\%SID%_Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f
REG DELETE HKEY_USERS\%SID%\Software\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f
REG DELETE HKEY_USERS\%SID%_Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f
REG DELETE HKEY_USERS\%SID%\Software\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f
REG DELETE HKEY_USERS\%SID%_Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f
REG DELETE HKEY_USERS\%SID%\Software\Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f
REG DELETE HKEY_USERS\%SID%_Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f


::Reset info to default
::------------------------------------------------------------------------------------------------------------------------------------
::------------------------------------------------------------------------------------------------------------------------------------
reg add HKEY_CURRENT_USER\Software\DownloadManager /v FName /f
reg add HKEY_CURRENT_USER\Software\DownloadManager /v LName /f
reg add HKEY_CURRENT_USER\Software\DownloadManager /v Email /f
reg add HKEY_CURRENT_USER\Software\DownloadManager /v Serial /f

REG ADD HKCU\Software\DownloadManager /v CheckUpdtVM /f
REG ADD HKCU\Software\DownloadManager /v scansk /f
REG ADD HKCU\Software\DownloadManager /v tvfrdt /f

::------------------------------------------------------------------------------------------------------------------------------------

reg add HKEY_USERS\%SID%\Software\DownloadManager /v FName /f
reg add HKEY_USERS\%SID%\Software\DownloadManager /v LName /f
reg add HKEY_USERS\%SID%\Software\DownloadManager /v Email /f
reg add HKEY_USERS\%SID%\Software\DownloadManager /v Serial /f

REG ADD HKEY_USERS\%SID%\Software\DownloadManager /v CheckUpdtVM /f
REG ADD HKEY_USERS\%SID%\Software\DownloadManager /v scansk /f
REG ADD HKEY_USERS\%SID%\Software\DownloadManager /v tvfrdt /f

::------------------------------------------------------------------------------------------------------------------------------------

endlocal

::------------------------------------------------------------------------------------------------------------------------------------

reg add "HKEY_LOCAL_MACHINE\Software\Internet Download Manager" /v FName /f
reg add "HKEY_LOCAL_MACHINE\Software\Internet Download Manager" /v LName /f
reg add "HKEY_LOCAL_MACHINE\Software\Internet Download Manager" /v Email /f
reg add "HKEY_LOCAL_MACHINE\Software\Internet Download Manager" /v Serial /f

REG ADD "HKEY_LOCAL_MACHINE\Software\Internet Download Manager" /v CheckUpdtVM /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Internet Download Manager" /v scansk /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Internet Download Manager" /v tvfrdt /f

::------------------------------------------------------------------------------------------------------------------------------------

reg add "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Internet Download Manager" /v FName /f
reg add "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Internet Download Manager" /v LName /f
reg add "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Internet Download Manager" /v Email /f
reg add "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Internet Download Manager" /v Serial /f

REG ADD "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Internet Download Manager" /v CheckUpdtVM /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Internet Download Manager" /v scansk /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Internet Download Manager" /v tvfrdt /f
::------------------------------------------------------------------------------------------------------------------------------------

ECHO complete!

pause