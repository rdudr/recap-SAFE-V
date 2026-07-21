# SAFE-V Flutter Installation Script
# Run as Administrator in PowerShell

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         FLUTTER SDK - AUTOMATED INSTALLATION SCRIPT          ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "⚠️  WARNING: This script should be run as Administrator" -ForegroundColor Yellow
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host ""
}

# Step 1: Check if Flutter already installed
Write-Host "📋 STEP 1: Checking for existing Flutter installation..." -ForegroundColor Green
$flutterPath = "C:\flutter"

if (Test-Path $flutterPath) {
    Write-Host "✅ Flutter already installed at: $flutterPath" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "❌ Flutter not found. Beginning installation..." -ForegroundColor Yellow
    Write-Host ""

    # Step 2: Download Flutter
    Write-Host "📋 STEP 2: Downloading Flutter SDK..." -ForegroundColor Green
    Write-Host "Size: ~550 MB | This may take 3-5 minutes..." -ForegroundColor Yellow
    Write-Host ""

    try {
        $url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip"
        $zipPath = "$env:TEMP\flutter.zip"

        Write-Host "Downloading from: Google Cloud Storage" -ForegroundColor Gray
        Write-Host "Destination: $zipPath" -ForegroundColor Gray
        Write-Host ""

        # Download with progress
        $ProgressPreference = 'Continue'
        Invoke-WebRequest -Uri $url -OutFile $zipPath -SkipCertificateCheck -UseBasicParsing

        if (Test-Path $zipPath) {
            Write-Host "✅ Download completed successfully!" -ForegroundColor Green
            Write-Host "File size: $((Get-Item $zipPath).Length / 1MB -as [int]) MB" -ForegroundColor Green
        } else {
            throw "Download failed"
        }
    } catch {
        Write-Host "❌ Download failed: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please download manually from:" -ForegroundColor Yellow
        Write-Host "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip" -ForegroundColor Blue
        Write-Host ""
        Write-Host "Then extract to: C:\flutter" -ForegroundColor Yellow
        exit 1
    }

    Write-Host ""

    # Step 3: Extract Flutter
    Write-Host "📋 STEP 3: Extracting Flutter SDK..." -ForegroundColor Green
    Write-Host "Destination: C:\flutter" -ForegroundColor Gray
    Write-Host "This may take 1-2 minutes..." -ForegroundColor Yellow
    Write-Host ""

    try {
        Expand-Archive -Path $zipPath -DestinationPath "C:\" -Force
        Write-Host "✅ Extraction completed successfully!" -ForegroundColor Green

        # Verify extraction
        if (Test-Path "C:\flutter\bin\flutter.bat") {
            Write-Host "✅ Flutter executable verified" -ForegroundColor Green
        }
    } catch {
        Write-Host "❌ Extraction failed: $_" -ForegroundColor Red
        exit 1
    }

    Write-Host ""

    # Step 4: Cleanup
    Write-Host "📋 STEP 4: Cleaning up temporary files..." -ForegroundColor Green
    try {
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Cleanup completed" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Warning: Could not remove temporary file" -ForegroundColor Yellow
    }

    Write-Host ""
}

# Step 5: Add to PATH
Write-Host "📋 STEP 5: Configuring System PATH..." -ForegroundColor Green
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$flutterBin = "C:\flutter\bin"

if ($currentPath -like "*$flutterBin*") {
    Write-Host "✅ Flutter already in PATH" -ForegroundColor Green
} else {
    Write-Host "Adding $flutterBin to User PATH..." -ForegroundColor Yellow

    if ($currentPath) {
        $newPath = "$currentPath;$flutterBin"
    } else {
        $newPath = $flutterBin
    }

    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "✅ PATH updated successfully" -ForegroundColor Green
}

Write-Host ""

# Step 6: Verify Installation
Write-Host "📋 STEP 6: Verifying Installation..." -ForegroundColor Green
Write-Host ""

$flutterBat = "C:\flutter\bin\flutter.bat"
if (Test-Path $flutterBat) {
    Write-Host "✅ Flutter executable found: $flutterBat" -ForegroundColor Green

    # Try to run flutter version
    $flutterFullPath = Join-Path "C:\flutter\bin" "flutter"
    if (Test-Path $flutterFullPath) {
        Write-Host "✅ Flutter installation verified" -ForegroundColor Green
    }
} else {
    Write-Host "❌ Flutter executable not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "✅ INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""

Write-Host "⚠️  IMPORTANT NEXT STEPS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. ⏻️  RESTART PowerShell (close and open a new window)" -ForegroundColor Red
Write-Host "   This is required to apply the PATH changes" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Verify installation:" -ForegroundColor Yellow
Write-Host "   flutter --version" -ForegroundColor Blue
Write-Host ""
Write-Host "3. Run Flutter Doctor:" -ForegroundColor Yellow
Write-Host "   flutter doctor" -ForegroundColor Blue
Write-Host ""
Write-Host "4. Navigate to SAFE-V project:" -ForegroundColor Yellow
Write-Host "   cd C:\Users\risha\Desktop\safe-v_bob\app_flutter" -ForegroundColor Blue
Write-Host ""
Write-Host "5. Get Flutter dependencies:" -ForegroundColor Yellow
Write-Host "   flutter pub get" -ForegroundColor Blue
Write-Host ""
Write-Host "6. Run the SAFE-V app:" -ForegroundColor Yellow
Write-Host "   flutter run" -ForegroundColor Blue
Write-Host ""

Write-Host "📊 Installation Summary:" -ForegroundColor Cyan
Write-Host "   Installation Location: C:\flutter" -ForegroundColor Yellow
Write-Host "   Flutter Version: 3.19.0" -ForegroundColor Yellow
Write-Host "   PATH Updated: Yes" -ForegroundColor Yellow
Write-Host ""

Write-Host "ℹ️  For Android emulator setup, see: flutter doctor output" -ForegroundColor Cyan
Write-Host ""

Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "Ready to run SAFE-V Flutter App!" -ForegroundColor Magenta
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""

Read-Host "Press Enter to close this window"
