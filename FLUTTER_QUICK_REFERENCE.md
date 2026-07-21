# SAFE-V Flutter App - Quick Reference Guide

## Screen Navigation Map

```
┌─────────────────────────────────────────────────┐
│                   Login Screen                   │
│         (PIN + Typing Cadence Capture)          │
└────────────────────┬────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────┐
│                 Home Screen                      │
│      ┌──────────────────────────────────┐       │
│      │ Account Balance Card             │       │
│      └──────────────────────────────────┘       │
│      ┌──────────────────────────────────┐       │
│      │ Quick Actions (4 buttons)        │       │
│      │ • UPI Pay ────────────┐          │       │
│      │ • Add Payee           │          │       │
│      │ • Travel Mode ────────┼──────┐   │       │
│      │ • Recovery ───────┐   │      │   │       │
│      └──────────────────┼──┼──────┼┘   │       │
│      ┌──────────────────┼──┼──────────┐ │       │
│      │ Other Accounts   │  │          │ │       │
│      └──────────────────┼──┼──────────┘ │       │
│      ┌──────────────────┼──┼──────────┐ │       │
│      │ Recent Txns      │  │          │ │       │
│      │ View All ────────┼──┼────┐     │ │       │
│      └──────────────────┼──┼────┼─────┘ │       │
│      ⚙️ Settings Button ──┤  │    │     │       │
└────────────────────────┼──┼────┼─────┘       │
                         │  │    │             │
         ┌───────────────┘  │    │             │
         │                  │    │             │
         ▼                  │    │             │
    ┌─────────────┐         │    │             │
    │  Settings   │         │    │             │
    │  - Profile  │         │    │             │
    │  - 2FA      │         │    │             │
    │  - Notifs   │         │    │             │
    │  - Logout   │         │    │             │
    └─────────────┘         │    │             │
                            │    │             │
         ┌──────────────────┘    │             │
         │                       │             │
         ▼                       ▼             ▼
    ┌─────────────┐    ┌──────────────┐  ┌────────────┐
    │ Transaction │    │ UPI Payment  │  │ Recovery   │
    │ History     │    │ - Details    │  │ - Phone    │
    │ - Filter    │    │ - Risk Assess│  │ - Identity │
    │ - Details   │    │ - Confirm    │  │ - Complete │
    └─────────────┘    └──────────────┘  └────────────┘
                            
         ┌──────────────────────────────────────┐
         │         Travel Mode Screen            │
         │                                       │
         │      ┌──────────────────────────┐    │
         │      │ Enroll for Travel        │    │
         │      │ ↓                        │    │
         │      │ QR Code Display          │    │
         │      │ ↓                        │    │
         │      │ View Backup Codes        │    │
         │      │ ↓                        │    │
         │      │ TOTP Screen ─────────┐   │    │
         │      └──────────────────────┼───┘    │
         │                             │        │
         │         ┌───────────────────┘        │
         │         ▼                            │
         │    ┌─────────────┐                   │
         │    │ TOTP Screen │                   │
         │    │ - Biometric │                   │
         │    │ - Code      │                   │
         │    │ - Timer     │                   │
         │    └─────────────┘                   │
         └──────────────────────────────────────┘
```

## Screen Details

### 1. **Login Screen** 📱
**Path**: `features/auth/login_screen.dart`

**Features**:
- 6-digit PIN input
- Typing cadence capture (inter-keystroke timings)
- Risk scoring via backend
- Three outcomes:
  - ✅ ALLOW → Home Screen
  - ⚠️ STEP_UP → TOTP Screen
  - ❌ BLOCK → Display reason

**Dummy Data**:
- User: Priya (ID: priya)
- Device ID: device_abc123xyz

---

### 2. **Home Screen** 🏠
**Path**: `features/home/home_screen.dart`

**Components**:
```
┌─ Primary Account Card ─────────────────┐
│ ₹84,500.00 (Savings Account)           │
│ •••• 6789                              │
│ Account Type: SAVINGS                  │
└────────────────────────────────────────┘

┌─ Quick Actions Grid (2x2) ─────────────┐
│ 🔄 UPI Pay      | 👤 Add Payee         │
│ ✈️ Travel       | 🔐 Recovery          │
└────────────────────────────────────────┘

┌─ Other Accounts ───────────────────────┐
│ Current Account    •••• 4321  ₹250,000 │
│ Emergency Fund     •••• 5555  ₹50,000  │
└────────────────────────────────────────┘

┌─ Recent Transactions ──────────────────┐
│ ✅ Coffee Shop     2,500 INR (3h ago)  │
│ ✅ Transfer        10,000 INR (5h ago) │
│ ❌ TechStore (blocked)  15,000 INR     │
│ [View All Transactions]                │
└────────────────────────────────────────┘
```

---

### 3. **UPI Payment Screen** 💳
**Path**: `features/payments/upi_pay_screen.dart`

**Step 1: Payment Details**
- Recipient UPI ID input
- Amount input
- Backend scoring call

**Step 2: Risk Assessment**
```
Risk Score: 45/100
Decision: STEP_UP (Orange)

Risk Signals:
🟡 Unusual amount (20 pts)
🟡 New merchant (15 pts)
🔵 Different device (10 pts)

Explanation: "Higher than usual..."
Action: "Verify with TOTP"
```

**Step 3: Success**
- Transaction confirmation
- Reference number
- Receipt details

**Decision Colors**:
- 🟢 0-45: ALLOW (Green)
- 🟡 45-75: STEP_UP (Orange)
- 🔴 75-100: BLOCK (Red)

---

### 4. **Travel Mode Screen** ✈️
**Path**: `features/travel/travel_mode_screen.dart`

**Flow**:
1. **Initial Screen**
   - Explanation of offline TOTP
   - "Declare Travel & Enroll TOTP" button

2. **After Enrollment**
   - QR Code display (for Google Authenticator backup)
   - Backup codes list (10 codes)
   - "Show My Offline Code" button

**Data Shown**:
- Device Name: iPhone 14 Pro
- Created: 30 days ago
- Status: Active

---

### 5. **TOTP Screen** 🔐
**Path**: `features/travel/totp_screen.dart`

**Locked State**:
- "Biometric Authentication Required"
- Fingerprint unlock button

**Unlocked State**:
```
┌──────────────────────────┐
│  Your TOTP Code          │
├──────────────────────────┤
│      123456              │
│     ⭕ 15 s              │
├──────────────────────────┤
│ Features:                │
│ 📡 Works without internet│
│ 📵 No SIM required       │
│ ✈️ Airplane mode ready   │
│ 🔒 Secure & encrypted    │
└──────────────────────────┘
```

**Auto-refresh**: Every 30 seconds with countdown timer

---

### 6. **Transaction History Screen** 📊
**Path**: `features/transactions/transaction_history_screen.dart`

**Filter Chips**: ALL | COMPLETED | PENDING | BLOCKED

**Transaction Cards**:
```
✅ Coffee Shop Payment
   Brew Haven Cafe • 21/07/2026
   ₹2,500
   ━━━━━━━━━━━━ Risk: 15 (ALLOW)
```

**Bottom Sheet Details**:
- Description
- Amount & Currency
- Status & Timestamp
- Recipient Info
- Risk Score & Decision

**Sorting**: By date (newest first)

---

### 7. **Kill Switch Screen** 🚨
**Path**: `features/safety/kill_switch_screen.dart`

**Before Activation**:
```
Emergency Account Freeze
"One tap blocks everything"

This will immediately:
🔴 Freeze debit/credit card
🔴 Disable UPI payments
🔴 Revoke active sessions
🔴 Block new logins
🔴 Alert the bank immediately

[FREEZE EVERYTHING] (Large red circle)
```

**After Activation**:
```
✅ Card Frozen: TRUE
✅ UPI Frozen: TRUE
✅ Sessions Revoked: 2
⏱ Block Time: 234 ms (RBI compliance)

"Bank has been notified. SMS sent."
```

---

### 8. **Settings Screen** ⚙️
**Path**: `features/settings/settings_screen.dart`

**Profile Section**:
- Avatar with initials
- Name, Email, Phone
- Account Status badge

**Security**:
- 🛡️ Two-Factor Auth (toggle)
- 👆 Biometric Login (toggle)
- 🔑 Change PIN (action)
- 🔐 Manage API Keys (action)

**Notifications**:
- 🔔 Push Notifications (toggle)
- ⚙️ Notification Settings (action)

**Account**:
- 📋 Login History
- 📱 Active Sessions
- 📥 Export Data

**Support**:
- ❓ Help & FAQ
- 🐛 Report Issue
- ℹ️ About SAFE-V

**Action**: Logout (red button)

---

### 9. **Account Recovery Screen** 🔄
**Path**: `features/account/recovery_screen.dart`

**Step 1: Phone Verification**
- Display registered phone
- Send OTP button
- Enter OTP in dialog

**Step 2: Identity Verification**
- Security questions
- Answer fields
- Verify button

**Step 3: Recovery Options**
- Reset PIN
- Reset TOTP
- Contact Support

**Success Screen**:
- ✅ Recovery Summary
- Done button

---

## Dummy Data Reference

### Users
```
Priya Sharma
├─ ID: priya
├─ Email: priya.sharma@email.com
├─ Phone: +91-9876543210
├─ Status: ACTIVE
└─ Last Login: 2h ago

Rajesh Kumar
├─ ID: rajesh
├─ Email: rajesh.kumar@email.com
├─ Status: ACTIVE (abroad)
└─ Last Login: 1h ago

Anisha Patel
├─ ID: anisha
├─ Email: anisha.patel@email.com
├─ Status: PROBATION
└─ Last Login: 1 day ago
```

### Accounts
```
1. Savings Account (Primary)
   └─ Balance: ₹84,500
   └─ Account: •••• 6789

2. Business Account
   └─ Balance: ₹250,000
   └─ Account: •••• 4321

3. Emergency Fund
   └─ Balance: ₹50,000
   └─ Account: •••• 5555
```

### Risk Scenarios
```
Low Risk (Score: 15)
├─ Amount: ₹2,500
├─ Decision: ALLOW
└─ Example: Coffee shop payment

Medium Risk (Score: 45)
├─ Amount: ₹15,000
├─ Decision: STEP_UP
└─ Example: New online merchant

High Risk (Score: 92)
├─ Amount: ₹50,000
├─ Decision: BLOCK
└─ Signals: SIM swap, device change, abroad IP
```

---

## Key Interactions

### Flow 1: Complete a Payment
```
Home → UPI Pay → Enter Details → Risk Assessment → Decision → Success
```

### Flow 2: Travel Enrollment
```
Home → Travel Mode → Enroll → QR Code → TOTP → Show Code
```

### Flow 3: Account Issues
```
Home → Recovery → Phone Verify → Identity Check → Recovery Option → Done
```

### Flow 4: Emergency
```
Home → Kill Switch → Confirm → Freeze Complete → Contact Support
```

---

## UI Components Used

| Component | Count | Example |
|-----------|-------|---------|
| Cards | 20+ | Account cards, transaction tiles |
| Buttons | 15+ | Filled, outlined, icon buttons |
| Text Fields | 8 | PIN, amount, OTP inputs |
| Progress Indicators | 4 | Circular, linear, countdown |
| Dialogs | 5 | OTP, confirmation, details |
| Bottom Sheets | 3 | Transaction details, backup codes |
| Icons | 50+ | Material Design icons |
| Chips | 6 | Filter chips for transactions |
| Badges | 8 | Status badges (COMPLETED, BLOCKED, etc.) |

---

## Color Usage

```
Primary (BoB Orange):  #F37021
├─ Buttons & Links
├─ Icons
└─ Progress indicators

Success (Green):       #4CAF50  (COMPLETED, ALLOW)
Warning (Orange):      #FF9800  (PENDING, STEP_UP)
Error (Red):           #F44336  (BLOCKED, BLOCK)
Info (Blue):           #2196F3  (Information)
Neutral (Grey):        #9E9E9E  (Disabled, secondary text)
```

---

## Performance Notes

- ✅ All screens render instantly with dummy data
- ✅ No heavy computations
- ✅ Images are small (QR codes, icons)
- ✅ Smooth navigation transitions
- ✅ Ready for state management integration (Provider/Riverpod)

---

## Development Checklist

- [x] All models created
- [x] Dummy data service implemented
- [x] 9 screens fully built
- [x] Navigation configured
- [x] Risk visualization added
- [x] Forms & input handling
- [x] Modal dialogs
- [x] Bottom sheets
- [x] Status indicators
- [ ] Backend API integration
- [ ] State management (Provider)
- [ ] Local persistence (Hive/SQLite)
- [ ] Push notifications
- [ ] Analytics logging
- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests

---

**Last Updated**: July 21, 2026
**Status**: ✅ Complete - Ready for Testing
