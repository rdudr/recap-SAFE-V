# Run SAFE-V Flutter App - Quick Commands

## ✅ Flutter is Ready!

Flutter SDK is already installed at: `C:\flutter`

---

## 🚀 3 Simple Commands to Run the App

### Command 1: Navigate to Project
```powershell
cd C:\Users\risha\Desktop\safe-v_bob\app_flutter
```

### Command 2: Get Dependencies
```powershell
flutter pub get
```

**What it does:**
- Downloads all required Flutter packages
- Takes 1-2 minutes
- Shows progress in terminal

### Command 3: Run the App
```powershell
flutter run
```

**What it does:**
- Builds the Flutter app
- Launches on connected device/emulator
- First build: 3-5 minutes
- Subsequent: 10-30 seconds with hot reload

---

## 🎮 What You'll See

### Login Screen Appears
```
┌─────────────────────────────────┐
│   🛡️  SAFE-V Bank              │
│                                 │
│  "Invisible when it's you.      │
│   A wall when it's not."        │
│                                 │
│  ┌─────────────────────────┐    │
│  │ Login PIN           [•••]    │
│  └─────────────────────────┘    │
│                                 │
│      ┌──────────────────┐       │
│      │     Login        │       │
│      └──────────────────┘       │
└─────────────────────────────────┘
```

### Test the App
1. Enter any 6-digit PIN (e.g., 123456)
2. Tap Login
3. Navigate to Home Screen
4. Try all 9 screens:
   - UPI Payment
   - Travel Mode
   - TOTP
   - Kill Switch
   - Transactions
   - Settings
   - Recovery

---

## ⚠️ Prerequisites

### Emulator/Device Required
Before running `flutter run`, you need:
- Android Emulator running, OR
- iOS Simulator running, OR
- Physical device connected

### Start Android Emulator
1. Open Android Studio
2. Go to Device Manager
3. Click Play icon on an emulator
4. Wait for it to fully boot

### Verify Devices
```powershell
flutter devices
```

---

## 🔍 Troubleshooting

### Issue: "No device/emulator"
**Solution:**
```powershell
# List devices
flutter devices

# If empty, start emulator in Android Studio first
```

### Issue: "flutter: command not found"
**Solution:**
```powershell
# Add Flutter to PATH manually
$env:PATH = "C:\flutter\bin;$env:PATH"

# Then try again
flutter --version
```

### Issue: "Port 8000 already in use"
**Solution:**
Backend is running on :8000, which is fine. The Flutter app will connect to it.

### Issue: App build fails
**Solution:**
```powershell
flutter clean
flutter pub get
flutter run -v  # verbose mode shows what's wrong
```

---

## ⏱️ Expected Timing

| Step | Time |
|------|------|
| Navigate to project | <1 min |
| flutter pub get | 1-2 min |
| flutter run (first) | 3-5 min |
| flutter run (after) | 10-30 sec |
| **Total first run** | **5-8 min** |

---

## 📱 Full 3-Step Quick Launch

**Copy and paste these commands in PowerShell:**

```powershell
# Step 1: Go to project
cd C:\Users\risha\Desktop\safe-v_bob\app_flutter

# Step 2: Get dependencies
flutter pub get

# Step 3: Run the app
flutter run
```

---

## ✨ Backend Status

Backend is already running:
- **URL**: http://localhost:8000
- **Status**: ✅ Running
- **API Docs**: http://localhost:8000/docs

The Flutter app will automatically connect to it.

---

## 🎯 What to Test After Launch

1. **Login Screen**
   - Enter any 6-digit PIN
   - See risk scoring happen in background
   - Get routed to Home (ALLOW) or TOTP (STEP_UP)

2. **Home Screen**
   - View account balance (₹84,500)
   - See 3 other accounts
   - View recent transactions
   - Access quick action buttons

3. **All 9 Screens**
   - Try UPI Payment (different amounts trigger different risks)
   - Try Travel Mode (TOTP enrollment)
   - Try TOTP Screen (biometric unlock)
   - Try Kill Switch (emergency freeze)
   - View Transactions (filter by status)
   - Change Settings (profile, preferences)
   - Run Recovery (multi-step flow)

---

## 📚 Comprehensive Guides

For more details, see:
- **FINAL_SETUP_INSTRUCTIONS.md** - Full setup guide
- **FLUTTER_INSTALLATION_GUIDE.md** - Visual mockups
- **QUICK_START.md** - 5-minute quickstart
- **FLUTTER_TESTING_GUIDE.md** - Testing scenarios

---

**Ready to go! 🚀**

Just run these 3 commands in PowerShell:
```powershell
cd C:\Users\risha\Desktop\safe-v_bob\app_flutter
flutter pub get
flutter run
```
