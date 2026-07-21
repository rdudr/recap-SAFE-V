# Flutter Installation & App Launch Guide

## ⚠️ Current Status: Flutter Not Installed

To run the SAFE-V Flutter app, you need to install Flutter SDK first.

---

## Step-by-Step Installation (Windows)

### Step 1: Download Flutter SDK
1. Go to: https://flutter.dev/docs/get-started/install/windows
2. Download **Flutter SDK** (Windows 64-bit)
3. Current version: Flutter 3.x recommended

### Step 2: Extract Flutter
```
1. Extract the downloaded ZIP file
2. Example location: C:\flutter
3. Note the full path
```

### Step 3: Add to PATH
**Windows 11/10**:
1. Press `Windows Key + R`
2. Type: `sysdm.cpl`
3. Click "Environment Variables"
4. Under "User variables", click "New"
5. Variable name: `PATH`
6. Variable value: `C:\flutter\bin` (or your extraction path)
7. Click OK on all dialogs
8. **Restart PowerShell**

### Step 4: Verify Installation
```powershell
flutter --version
# Should show: Flutter 3.x.x • channel stable
```

### Step 5: Run Flutter Doctor
```powershell
flutter doctor
```

This checks for:
- ✅ Flutter SDK
- ✅ Android Studio (or Xcode for iOS)
- ✅ Emulators
- ✅ VS Code extensions

**Output example**:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.13.x, on Windows 11 22621)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio (version 2022.x)
[✓] VS Code (version 1.84.0)
```

---

## Running the SAFE-V App

### Method 1: Android Emulator

**Prerequisites**:
- Android Studio installed
- Emulator created in Android Studio

**Steps**:
```bash
# 1. Start Android Emulator
# Open Android Studio → Device Manager → Start Emulator

# 2. Navigate to project
cd C:\Users\risha\Desktop\safe-v-bob\app_flutter

# 3. Get dependencies
flutter pub get

# 4. Run app
flutter run -d emulator-5554

# Expected output:
# Building flutter app in release mode...
# Built build\app\outputs\flutter-apk\app-release.apk
# Installing and launching...
# Launching lib\main.dart on Android device in release mode...
# ✅ Application finished with exit code 0
```

### Method 2: iOS Simulator (macOS only)

```bash
# 1. Start iOS Simulator
open -a Simulator

# 2. Navigate to project
cd app_flutter

# 3. Run app
flutter run -d simulator

# Expected output similar to Android
```

### Method 3: Physical Device

**For Android**:
```bash
# 1. Enable Developer Mode on phone
#    Settings → About Phone → Tap Build Number 7 times

# 2. Enable USB Debugging
#    Settings → Developer Options → USB Debugging

# 3. Connect phone via USB

# 4. List devices
flutter devices

# 5. Run app
flutter run -d <device-id>
```

---

## What You'll See When App Launches

### Screen 1: Login Screen (First Screen)
```
╔════════════════════════════════════════╗
║                                        ║
║          🛡️  SAFE-V Bank              ║
║                                        ║
║   Invisible when it's you.            ║
║   A wall when it's not.               ║
║                                        ║
║   ┌────────────────────────────────┐  ║
║   │ Login PIN                   [•••] │  ║
║   └────────────────────────────────┘  ║
║                                        ║
║          ┌─────────────────┐           ║
║          │     Login       │           ║
║          └─────────────────┘           ║
║                                        ║
║   Status: [Risk scoring...]           ║
║                                        ║
╚════════════════════════════════════════╝
```

**What happens**:
- Enter any 6-digit PIN (e.g., 123456)
- App sends to backend: Risk scoring request
- Backend returns decision (ALLOW/STEP_UP/BLOCK)
- Routes to Home Screen or TOTP Screen

### Screen 2: Home Screen
```
╔════════════════════════════════════════╗
║ SAFE-V Bank                        ⚙️  ║
╠════════════════════════════════════════╣
║                                        ║
║  ┌──────────────────────────────────┐  ║
║  │   Account Balance                │  ║
║  │   ₹84,500.00                     │  ║
║  │   •••• 6789 | SAVINGS            │  ║
║  └──────────────────────────────────┘  ║
║                                        ║
║  Quick Actions                         ║
║  ┌──────────────┬──────────────────┐   ║
║  │  💳 UPI Pay  │  ✈️ Travel       │   ║
║  │  👤 Payee    │  🔐 Recovery     │   ║
║  └──────────────┴──────────────────┘   ║
║                                        ║
║  Other Accounts                        ║
║  Business: ₹250,000 •••• 4321          ║
║  Emergency: ₹50,000 •••• 5555          ║
║                                        ║
║  Recent Transactions                   ║
║  ✅ Coffee Shop | ₹2,500 | Risk: 15   ║
║  ✅ Transfer | ₹10,000 | Risk: 28     ║
║  🟡 Shopping | ₹15,000 | Risk: 45     ║
║                                        ║
║  [View All Transactions]               ║
║                                        ║
╚════════════════════════════════════════╝
```

### Screen 3: UPI Payment (Payment Flow)
```
STEP 1: Enter Details
╔════════════════════════════════════════╗
║ UPI Payment                            ║
╠════════════════════════════════════════╣
║                                        ║
║ Recipient UPI ID                       ║
║ ┌────────────────────────────────────┐ ║
║ │ merchant@upi                   [x] │ ║
║ └────────────────────────────────────┘ ║
║                                        ║
║ Amount (₹)                             ║
║ ┌────────────────────────────────────┐ ║
║ │ 15000                          [x] │ ║
║ └────────────────────────────────────┘ ║
║                                        ║
║      ┌─────────────────────────┐       ║
║      │  Continue to Review     │       ║
║      └─────────────────────────┘       ║
║                                        ║
╚════════════════════════════════════════╝

STEP 2: Risk Assessment
╔════════════════════════════════════════╗
║ Risk Assessment                        ║
╠════════════════════════════════════════╣
║                                        ║
║         Risk Score                     ║
║         🟡 45/100 🟡                   ║
║                                        ║
║  Decision: STEP_UP (Orange)            ║
║                                        ║
║  Risk Signals:                         ║
║  🟡 Unusual amount (20 pts)            ║
║  🟡 New merchant (15 pts)              ║
║  🔵 Different device (10 pts)          ║
║                                        ║
║  Explanation:                          ║
║  "Amount is higher than usual. Please  ║
║   verify with TOTP."                   ║
║                                        ║
║      ┌─────────────────────────┐       ║
║      │ Verify with TOTP        │       ║
║      └─────────────────────────┘       ║
║                                        ║
╚════════════════════════════════════════╝

STEP 3: Success
╔════════════════════════════════════════╗
║ Payment Successful                     ║
╠════════════════════════════════════════╣
║                                        ║
║            ✅ Check Mark               ║
║                                        ║
║  Your payment has been processed       ║
║  successfully.                         ║
║                                        ║
║  Recipient: merchant@upi               ║
║  Amount: ₹15,000                       ║
║  Status: Completed                     ║
║  Reference: #TXN20260721001            ║
║                                        ║
║           ┌─────────────┐              ║
║           │    Done     │              ║
║           └─────────────┘              ║
║                                        ║
╚════════════════════════════════════════╝
```

### Screen 4: Travel Mode (TOTP Enrollment)
```
╔════════════════════════════════════════╗
║ Travel / Abroad Mode                   ║
╠════════════════════════════════════════╣
║                                        ║
║  ✈️  Going abroad? Your Indian SIM    ║
║      may not receive OTPs.             ║
║                                        ║
║      Enroll once while you have        ║
║      network — after that, this app    ║
║      generates codes OFFLINE.          ║
║                                        ║
║    ┌──────────────────────────┐        ║
║    │ Declare Travel & Enroll  │        ║
║    │ TOTP                     │        ║
║    └──────────────────────────┘        ║
║                                        ║
║  [After Enrollment]                    ║
║                                        ║
║  Backup: Scan into Google              ║
║  Authenticator (optional)              ║
║                                        ║
║      ┌─────────────────┐               ║
║      │   [QR CODE]     │               ║
║      │   Scannable     │               ║
║      └─────────────────┘               ║
║                                        ║
║  Backup Codes:                         ║
║  8765-4321                             ║
║  5432-1098                             ║
║  2109-8765                             ║
║  8765-4321                             ║
║  5432-1098                             ║
║                                        ║
║  ┌──────────────────────────────┐     ║
║  │ Show My Offline Code         │     ║
║  └──────────────────────────────┘     ║
║                                        ║
╚════════════════════════════════════════╝
```

### Screen 5: TOTP Screen (Offline Code)
```
╔════════════════════════════════════════╗
║ Offline Travel Code                    ║
╠════════════════════════════════════════╣
║                                        ║
║  🔒 Biometric Authentication           ║
║     Required                           ║
║                                        ║
║  👆 Unlock with Biometrics             ║
║                                        ║
║  [After Biometric Unlock]              ║
║                                        ║
║  Your TOTP Code                        ║
║                                        ║
║        1  2  3  4  5  6                ║
║                                        ║
║        ⭕ 15 s                         ║
║                                        ║
║  Features:                             ║
║  📡 Works without internet             ║
║  📵 No SIM required                    ║
║  ✈️ Airplane mode ready                ║
║  🔒 Secure & encrypted                 ║
║                                        ║
║  Refreshes every 30 seconds            ║
║                                        ║
╚════════════════════════════════════════╝
```

### Screen 6: Kill Switch (Emergency Freeze)
```
BEFORE:
╔════════════════════════════════════════╗
║ Emergency Kill Switch                  ║
╠════════════════════════════════════════╣
║                                        ║
║  ⚠️  Card stolen? Phone snatched?      ║
║      One tap blocks EVERYTHING.        ║
║                                        ║
║  This will immediately:                ║
║  🔴 Freeze debit/credit card           ║
║  🔴 Disable UPI payments               ║
║  🔴 Revoke active sessions             ║
║  🔴 Block new logins                   ║
║  🔴 Alert the bank                     ║
║                                        ║
║              ┌───────┐                 ║
║              │FREEZE │                 ║
║              │ EVERY │                 ║
║              │ THING │                 ║
║              └───────┘                 ║
║           (Large Red Circle)           ║
║                                        ║
║  This action is reversible.            ║
║  Contact support to restore.           ║
║                                        ║
╚════════════════════════════════════════╝

AFTER:
╔════════════════════════════════════════╗
║ Account Frozen Successfully            ║
╠════════════════════════════════════════╣
║                                        ║
║             ✅ Check Mark              ║
║                                        ║
║  ✅ Card Frozen: TRUE                  ║
║  ✅ UPI Frozen: TRUE                   ║
║  ✅ Sessions Revoked: 2                ║
║  ⏱ Block Time: 234 ms                 ║
║                                        ║
║  Bank has been notified.               ║
║  SMS confirmation sent.                ║
║                                        ║
║  ┌─────────────┬──────────────┐        ║
║  │   Reset     │ Contact Supp │        ║
║  └─────────────┴──────────────┘        ║
║                                        ║
╚════════════════════════════════════════╝
```

---

## Troubleshooting

### Issue: `flutter: The term 'flutter' is not recognized`
**Solution**: 
- Add `C:\flutter\bin` to PATH
- Restart PowerShell after adding to PATH

### Issue: `No emulator installed`
**Solution**:
- Open Android Studio
- Tools → Device Manager
- Create Virtual Device
- Download system image
- Start emulator
- Run `flutter devices` to verify

### Issue: `Gradle build failed`
**Solution**:
```bash
cd app_flutter
flutter clean
flutter pub get
flutter run
```

### Issue: `Connection refused`
**Solution**:
- Make sure backend is running: `http://localhost:8000/health`
- Update API URL if needed in `lib/core/api_client.dart`

---

## Launch Command Summary

```bash
# Navigate to project
cd C:\Users\risha\Desktop\safe-v_bob\app_flutter

# Get dependencies
flutter pub get

# List available devices
flutter devices

# Run on Android emulator
flutter run -d emulator-5554

# Run on iOS simulator (macOS)
flutter run -d simulator

# Run on physical device
flutter run -d <device-id>

# Run with verbose output (debugging)
flutter run -v

# Run in release mode (faster)
flutter run --release
```

---

## Expected Startup Time

- **First run**: 3-5 minutes (building APK)
- **Subsequent runs**: 10-30 seconds (hot reload)
- **Full rebuild**: 2-3 minutes

---

## Next Steps

1. ✅ Install Flutter SDK
2. ✅ Add to PATH
3. ✅ Verify with `flutter --version`
4. ✅ Run `flutter doctor`
5. ✅ Set up Android/iOS emulator
6. ✅ Navigate to `app_flutter` directory
7. ✅ Run `flutter pub get`
8. ✅ Run `flutter run`
9. ✅ Test all 9 screens

---

**Once Flutter is installed, the app will launch in seconds!** 🚀

For detailed Flutter setup: https://flutter.dev/docs/get-started/install
