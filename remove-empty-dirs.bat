:: Remove Empty Dirs
:: 1.0.0
:: Vasyl Lukianenko 
:: 3DGROUND
:: https://3dground.net

echo off

cls

set input=%1
set opt=
set dest=

for /f "tokens=1,2 delims=;" %%i in (%input%) do (
	set dest=%%i
	set opt=%%j
)

cd /d "%dest%"

for /d /r "%dest%" %%d in (*) do (
    rd "%%d" 2>nul
)


exit 0