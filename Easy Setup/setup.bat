@echo off
pushd %~dp0
    :: Running prompt elevated
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

setx PATH "%PATH%;C:\Python27;C:\Python27\Scripts;"

popd

C:\Python27\python get-pip.py
cd ..
C:\Python27\Scripts\pip install -r requirements.txt
C:\Python27\Scripts\pip install -r requirements.txt --upgrade
rename credentials.example.json credentials.json
set /p API= Enter your Google API key here:

    (
    echo {
    echo "gmaps_key" : "%API%"
    echo }
    ) > credentials.json