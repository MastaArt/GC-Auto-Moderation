:: Sync AWS
:: 1.0.0
:: Vasyl Lukianenko 
:: 3DGROUND
:: https://3dground.net

echo off
setlocal enabledelayedexpansion
cls

set input=%1

set dest=
set opt=

for /f "tokens=1,2 delims=;" %%i in (%input%) do (
	set dest=%%i
	set opt=%%j
)

cd C:\Program Files\Amazon\AWSCLIV2\
aws s3 sync s3://dev-gc-processing/ "%dest%" --delete
