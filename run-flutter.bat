@echo off
REM SAFE-V Flutter App Launcher
REM Double-click this file to run the app

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║              SAFE-V Flutter App - Launching                   ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Set Flutter path
set PATH=C:\flutter\bin;%PATH%

REM Navigate to project
cd /d "C:\Users\risha\Desktop\safe-v_bob\app_flutter"

echo 📁 Project: C:\Users\risha\Desktop\safe-v_bob\app_flutter
echo 🌐 Running on: Chrome Browser
echo.
echo 🚀 Launching app...
echo.

REM Run Flutter
flutter run -d chrome

pause
