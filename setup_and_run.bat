@echo off
rem Double-click to create .venv, install the pinned packages, verify them and run the notebook.
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup_and_run.ps1"
pause
