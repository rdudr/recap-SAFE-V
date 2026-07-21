@echo off
REM ============================================================================
REM SAFE-V: Setup & Start Script
REM PSB Hackathon Series 2026 - IIT Gandhinagar
REM ============================================================================

setlocal enabledelayedexpansion

cls
echo.
echo ============================================================================
echo.
echo                    SAFE-V - IDENTITY TRUST ENGINE
echo.
echo          Prototype for BOB Hackathon 2026 (IIT Gandhinagar)
echo.
echo ============================================================================
echo.
echo This script will:
echo   1. Verify your Python installation
echo   2. Set up a virtual environment (venv) for the Backend
echo   3. Install all Python dependencies (FastAPI, scikit-learn, shap, etc.)
echo   4. Verify your Flutter installation and run 'flutter pub get'
echo   5. Start the FastAPI Backend Server (with reload on port 8000)
echo.
echo ============================================================================
echo.
pause

REM ----------------------------------------------------------------------------
REM 1. Check Python
REM ----------------------------------------------------------------------------
echo Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo [ERROR] Python was not found on your system!
    echo Please download and install Python 3.11+ from https://www.python.org/
    echo Make sure to check "Add Python to PATH" during installation.
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo [OK] Found: %PYTHON_VERSION%
echo.

REM ----------------------------------------------------------------------------
REM 2. Setup / Verify Backend Virtual Environment
REM ----------------------------------------------------------------------------
echo ============================================================================
echo SETTING UP BACKEND VIRTUAL ENVIRONMENT
echo ============================================================================
echo.

if not exist "backend\requirements.txt" (
    echo [ERROR] backend\requirements.txt not found!
    echo Please make sure you are running this script from the project root.
    pause
    exit /b 1
)

if not exist "backend\venv" (
    echo Creating virtual environment inside backend\venv...
    python -m venv backend\venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment!
        pause
        exit /b 1
    )
    echo [OK] Virtual environment created successfully.
) else (
    echo [OK] Virtual environment folder already exists at backend\venv.
)
echo.

REM ----------------------------------------------------------------------------
REM 3. Install Python Dependencies
REM ----------------------------------------------------------------------------
echo Installing Python backend requirements (this may take a few minutes)...
call backend\venv\Scripts\pip install -r backend\requirements.txt
if errorlevel 1 (
    echo [ERROR] Failed to install Python dependencies.
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)
echo [OK] All backend Python dependencies are verified and installed!
echo.

REM ----------------------------------------------------------------------------
REM 4. Check Flutter & Install Flutter Dependencies
REM ----------------------------------------------------------------------------
echo ============================================================================
echo VERIFYING FLUTTER DEVELOPMENT ENVIRONMENT
echo ============================================================================
echo.

where flutter >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Flutter SDK was not found in your PATH.
    echo.
    echo To run the mobile app:
    echo   1. Please download and install Flutter from https://docs.flutter.dev/get-started/install
    echo   2. Make sure the flutter tool is in your system PATH.
    echo   3. Run 'cd app_flutter && flutter pub get && flutter run'
    echo.
) else (
    echo [OK] Flutter SDK found.
    echo Installing app_flutter dependencies (flutter pub get)...
    cd app_flutter
    call flutter pub get
    if errorlevel 1 (
        echo [WARNING] Failed to run 'flutter pub get' automatically.
    ) else (
        echo [OK] Flutter app dependencies updated successfully!
    )
    cd ..
)
echo.

REM ----------------------------------------------------------------------------
REM 5. Start Backend Server
REM ----------------------------------------------------------------------------
echo ============================================================================
echo STARTING SERVERS
echo ============================================================================
echo.
echo Starting SAFE-V Trust Engine (FastAPI) on port 8000...
echo This will run: uvicorn app.main:app --reload in a new terminal.
echo.

start "SAFE-V Backend Server" cmd /k "title SAFE-V Backend Server && cd backend && venv\Scripts\activate && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"

echo.
echo ============================================================================
echo SETUP COMPLETE & SERVER STARTED!
echo ============================================================================
echo.
echo Backend Server details:
echo   - Base URL: http://localhost:8000
echo   - Interactive API Docs: http://localhost:8000/docs
echo   - SOC Events Feed: http://localhost:8000/v1/events
echo.
echo Flutter Mobile Client:
echo   - Go to app_flutter/ directory
echo   - Start an emulator or plug in a device
echo   - Run: flutter run
echo.
echo ============================================================================
echo.
pause
