@echo off
REM Build SAFE-V Flutter App as APK for Android

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║         SAFE-V Flutter - Building APK for Android            ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Set Flutter path
set PATH=C:\flutter\bin;%PATH%

REM Navigate to project
cd /d "C:\Users\risha\Desktop\safe-v_bob\app_flutter"

echo 📁 Project: C:\Users\risha\Desktop\safe-v_bob\app_flutter
echo 🔨 Building APK...
echo.
echo ⏱️  This takes 5-10 minutes (first time)
echo.

REM Build APK
flutter build apk --release

echo.
echo ✅ Build complete!
echo 📦 APK location: build\app\outputs\flutter-apk\app-release.apk
echo.

pause
