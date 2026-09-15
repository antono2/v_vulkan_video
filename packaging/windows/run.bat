@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"
if "%~1"=="" (
  v_vulkan_video.exe "res\20240917_095400.mp4"
) else (
  v_vulkan_video.exe %*
)
set "PLAYER_EXIT_CODE=%ERRORLEVEL%"
exit /b %PLAYER_EXIT_CODE%
