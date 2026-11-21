@echo off
rem Select the source bundle's modules, then let V discover the x64 toolchain and build.
setlocal
set "VMODULES=%~dp0..\.."
v run "%~dp0..\..\scripts\build_windows.vsh" --modules "%~dp0..\..\..\modules"
exit /b %errorlevel%
