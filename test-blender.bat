@echo off
cls

set file=c:\Users\MM\Downloads\TestAutomation\61699\decor molding.blend
set script1=blender-gen-ini.py
set script2=blender-render.py
set blend=C:\Program Files\Blender Foundation\Blender 4.1\blender.exe

if not exist "%file%" (
    echo File not found: %file%
    pause
)

rem call blender-bg-run.bat "%blend%;%file%;%script1%"
call blender-bg-run.bat "%blend%;%file%;%script2%"

pause