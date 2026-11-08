@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Start-ChatGPT.ps1"
if errorlevel 1 (
    echo.
    echo The launcher exited with an error. See the message above.
    pause
)
