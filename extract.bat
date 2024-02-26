:: Extracter
:: 1.0.0
:: Vasyl Lukianenko 
:: 3DGROUND
:: https://3dground.net

echo off
setlocal enabledelayedexpansion
cls

set input=%1
set file=
set dest=
set winrar="C:\Program Files\WinRAR\WinRAR.exe"


for /f "tokens=1,2 delims=;" %%i in (%input%) do (
	set file=%%i
	set dest=%%j
)

mkdir "%dest%"

%winrar% x -y -ibck "%file%" "%dest%" 

cd /d "%dest%"

:extract_loop

set "archives_exist=false"

for /r %%i in (*.zip *.rar) do (
	set "archives_exist=true"
    %winrar% x -y -ibck "%%i" "%dest%%%~ni\"	
	del /q "%%i"
)

if "%archives_exist%"=="true" goto extract_loop

for /r %%i in (*) do (
	attrib -r /d /s "%%i"
    if not "%%~pi"=="%dest%" (
        move "%%i" "%dest%"
    )
)

for /d /r "%dest%" %%d in (*) do (
    rd "%%d" 2>nul
)

exit 0