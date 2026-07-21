# SAFE-V Flutter App - Testing & Demo Guide

## Setup & Launch

### 1. Start Backend Service
```bash
cd backend
venv\Scripts\activate           # Windows
# source venv/bin/activate     # macOS/Linux
uvicorn app.main:app --reload
```
**Expected Output**: 
```
Uvicorn running on http://127.0.0.1:8000
```

### 2. Start Flutter App
```bash
cd app_flutter
flutter clean
flutter pub get
flutter run
```

**For specific emulator**:
```bash
flutter run -d emulator-5554              # Android
flutter run -d iPhone\ 15\ Pro            # iOS
```

---

## Testing Scenarios

### **Scenario 1: Login Screen**

**Test Case 1.1: Successful Login**
1. Open app → See Login Screen
2. Enter PIN: `123456`
3. Type slowly (wait between digits)
4. Tap Login
5. **Expected**: Risk score calculated, routed to Home Screen

**Test Case 1.2: Risk Assessment During Login**
1. Enter PIN: `654321`
2. Type very quickly (rapid keystrokes)
3. Tap Login
4. **Expected**: Typing Z-score > 2.0, possible STEP_UP

**Test Case 1.3: Login Error**
1. Backend not running
2. Tap Login
3. **Expected**: SnackBar: "Backend unreachable — is uvicorn running?"

**Dummy Data**: User ID "priya", any 6-digit PIN accepted

---

### **Scenario 2: Home Screen Navigation**

**Test Case 2.1: View Account Balance**
1. After login, see Home Screen
2. **Verify**:
   - Primary account displays ₹84,500
   - Account type shows "SAVINGS"
   - Last 4 digits: •••• 6789

**Test Case 2.2: View Other Accounts**
1. Scroll to "Other Accounts" section
2. **Verify**: 2 additional accounts visible
   - Business Account: ₹250,000 (•••• 4321)
   - Emergency Fund: ₹50,000 (•••• 5555)

**Test Case 2.3: Quick Actions**
1. Tap "UPI Pay" → UPI Payment Screen opens
2. Tap "Travel Mode" → Travel Mode Screen opens
3. Tap "Recovery" → Recovery Screen opens
4. Tap "Add Payee" → SnackBar shows "Coming soon"

**Test Case 2.4: Recent Transactions**
1. Home Screen displays 3 most recent transactions
2. Tap "View All Transactions" → Transaction History opens
3. **Verify**: All 6 transactions visible

**Test Case 2.5: Settings**
1. Tap ⚙️ icon in AppBar
2. **Expected**: Settings Screen opens
3. Verify profile shows "Priya Sharma"

---

### **Scenario 3: UPI Payment Flow**

**Test Case 3.1: Low-Risk Payment (Approve)**
1. Home → UPI Pay
2. Enter:
   - Recipient: `coffee@upi`
   - Amount: `2500`
3. Tap Continue
4. **Expected**: Risk score 15 (GREEN), Decision: ALLOW
5. Tap Confirm Payment
6. **Expected**: Success screen with transaction details

**Test Case 3.2: Medium-Risk Payment (Step-Up)**
1. Home → UPI Pay
2. Enter:
   - Recipient: `merchant@upi`
   - Amount: `15000`
3. Tap Continue
4. **Expected**: Risk score 45 (ORANGE), Decision: STEP_UP
5. Shows "Verify with TOTP" message
6. Tap button to proceed

**Test Case 3.3: High-Risk Payment (Block)**
1. Home → UPI Pay
2. Enter:
   - Recipient: `unknown@upi`
   - Amount: `50000`
3. Tap Continue
4. **Expected**: Risk score 92 (RED), Decision: BLOCK
5. Shows warning with risk signals:
   - Potential SIM swap detected (CRITICAL)
   - Device fingerprint changed (HIGH)
   - New IP geolocation abroad (HIGH)
6. Button disabled

**Test Case 3.4: Missing Fields Validation**
1. Home → UPI Pay
2. Leave fields empty
3. Tap Continue
4. **Expected**: SnackBar "Please fill all fields"

**Test Case 3.5: Risk Signal Display**
1. Any payment step
2. In Risk Assessment view:
3. **Verify**: Each signal shows:
   - Icon (error/warning/info)
   - Signal name
   - Score
   - Severity badge (CRITICAL/HIGH/MEDIUM/LOW)
   - Color-coded (red/orange/amber/green)

---

### **Scenario 4: Transaction History**

**Test Case 4.1: View All Transactions**
1. Home → View All Transactions
2. **Expected**: 6 transactions visible (3 COMPLETED, 1 PENDING, 1 BLOCKED, 1 FAILED)

**Test Case 4.2: Filter by Status**
1. Transaction History open
2. Tap "Completed" chip
3. **Expected**: Shows 3 completed transactions
4. Tap "Blocked" chip
5. **Expected**: Shows 1 blocked transaction

**Test Case 4.3: Transaction Details Modal**
1. Transaction History open
2. Tap any transaction
3. **Expected**: Bottom sheet shows:
   - Description
   - Amount
   - Status
   - Date & time
   - Recipient name
   - Risk score & decision
4. Tap Close

**Test Case 4.4: Risk Indicator Bar**
1. Transaction History open
2. Each transaction shows progress bar
3. **Verify**: 
   - ✅ Completed: Green bar
   - ⚠️ Pending: Orange bar
   - ❌ Blocked: Red bar

**Dummy Data**:
- Coffee shop: ₹2,500 (Risk: 15, ALLOW)
- Transfer: ₹10,000 (Risk: 28, ALLOW)
- TechStore: ₹15,000 (Risk: 45, STEP_UP, PENDING)
- International: ₹50,000 (Risk: 92, BLOCK)

---

### **Scenario 5: Travel Mode & TOTP**

**Test Case 5.1: Enroll for Travel**
1. Home → Travel Mode
2. Tap "Declare Travel & Enroll TOTP"
3. **Expected**: 
   - Enrollment completes
   - Screen shows QR code
   - "Show My Offline Code" button appears

**Test Case 5.2: View Backup Codes**
1. After enrollment, tap "View Backup Codes"
2. **Expected**: Modal shows:
   - Warning: "Save these codes in a safe place"
   - 5 backup codes in monospace font:
     ```
     8765-4321
     5432-1098
     2109-8765
     8765-4321
     5432-1098
     ```

**Test Case 5.3: Access Offline Code**
1. After enrollment, tap "Show My Offline Code"
2. **Expected**: TOTP Screen opens

**Test Case 5.4: TOTP Biometric Lock**
1. TOTP Screen loads
2. **Expected**: "Biometric Authentication Required" message
3. Tap "Unlock with Biometrics"
4. **Expected**: 
   - On physical device: Biometric prompt
   - On emulator: Skips (no biometric), shows code immediately

**Test Case 5.5: TOTP Code Display**
1. TOTP unlocked
2. **Verify**:
   - Shows 6-digit code (e.g., 123456)
   - Circular progress timer shows seconds left
   - Auto-refreshes every 30 seconds
   - Code changes after 30s

**Test Case 5.6: Offline Functionality**
1. TOTP code showing
2. Enable Airplane Mode (device setting)
3. **Verify**: Code still generates (no internet required)

---

### **Scenario 6: Kill Switch**

**Test Case 6.1: Emergency Freeze**
1. Home → Kill Switch
2. Tap red "FREEZE EVERYTHING" button
3. **Expected**:
   - Loading animation in button
   - After 2 seconds: Success screen

**Test Case 6.2: Freeze Results**
1. After freeze completes, verify:
   - ✅ Card Frozen: TRUE
   - ✅ UPI Frozen: TRUE
   - ✅ Active Sessions Revoked: 2
   - ⏱ Block Time: ~200-300 ms

**Test Case 6.3: Support Contact**
1. After freeze, tap "Contact Support"
2. **Expected**: SnackBar "Contacting support team..."

**Test Case 6.4: Reset**
1. After freeze, tap "Reset"
2. **Expected**: Return to pre-freeze state

**Test Case 6.5: Impact Preview**
1. Before freeze, see warning card:
   - 🔴 Freeze debit/credit card
   - 🔴 Disable UPI payments
   - 🔴 Revoke active sessions
   - 🔴 Block new logins
   - 🔴 Alert the bank immediately

---

### **Scenario 7: Account Recovery**

**Test Case 7.1: Phone Verification**
1. Home → Recovery
2. Tap "Send OTP"
3. **Expected**: Dialog appears for OTP entry
4. Enter any 6 digits: `123456`
5. Tap Verify
6. **Expected**: Phone verified, move to step 2

**Test Case 7.2: Identity Verification**
1. After phone verification
2. **Expected**: 2 security questions appear:
   - "What is your pet's name?"
   - "In which city were you born?"
3. Enter any answers
4. Tap "Verify Identity"
5. **Expected**: Move to step 3

**Test Case 7.3: Recovery Options**
1. After identity verification
2. **Expected**: 3 recovery options:
   - 📌 Reset PIN
   - 📌 Reset TOTP
   - 📌 Contact Support
3. Tap any option
4. **Expected**: Recovery completes, success screen appears

**Test Case 7.4: Progress Indicator**
1. Throughout recovery process
2. **Verify**: Step indicators update:
   - Step 1: 🔵 Phone Verify → ✅ Phone Verified
   - Step 2: 🔵 Identity Check → ✅ Identity Verified
   - Step 3: 🔵 Recovery → ✅ Account Recovered

**Test Case 7.5: Success Screen**
1. After completing all steps
2. **Expected**: 
   - ✅ Icon (green)
   - "Account Recovered" message
   - Summary table:
     - Phone Verified: ✓
     - Identity Verified: ✓
     - PIN Reset: ✓
   - Done button

---

### **Scenario 8: Settings**

**Test Case 8.1: Profile Display**
1. Home → Settings
2. **Expected**: Profile card shows:
   - Avatar with "PS" initials
   - Name: Priya Sharma
   - Email: priya.sharma@email.com
   - Phone: +91 98765 43210
   - Status badge: ACTIVE (green)

**Test Case 8.2: Toggle Settings**
1. Settings screen
2. **Test toggles**:
   - 🛡️ Two-Factor Auth (toggle on/off)
   - 👆 Biometric Login (toggle on/off)
   - 🔔 Push Notifications (toggle on/off)
3. **Expected**: Toggles respond to taps

**Test Case 8.3: Action Tiles**
1. Settings screen
2. Tap any action tile (e.g., "Change PIN")
3. **Expected**: SnackBar "Feature coming soon"

**Test Case 8.4: About Dialog**
1. Scroll to Support section
2. Tap "About SAFE-V"
3. **Expected**: Dialog shows:
   - Version: 1.0.0
   - Description
   - Built for BOB Hackathon 2026

**Test Case 8.5: Logout**
1. Scroll to bottom
2. Tap red "Logout" button
3. **Expected**: Confirmation dialog
4. Tap "Logout"
5. **Expected**: Routed back to Login Screen

---

## Data Change Testing

### Modifying Dummy Data

Edit `lib/services/dummy_data_service.dart` to test different scenarios:

**Change Balance**:
```dart
balance: 84500.00,  // Change this
```

**Change Transaction Amounts**:
```dart
amount: 2500.00,    // Triggers different risk levels
```

**Add More Transactions**:
```dart
Transaction(
  id: 'txn_007',
  type: 'TRANSFER',
  amount: 25000.00,
  // ... other fields
)
```

**Modify Risk Assessment**:
```dart
RiskAssessment(
  overallScore: 50.0,   // Change risk
  decision: 'STEP_UP',  // ALLOW/STEP_UP/BLOCK
  // ... other fields
)
```

---

## Backend Integration Testing

### If Backend is Running

**Test Case B1: Real Risk Scoring**
1. Backend running on http://localhost:8000
2. Login with PIN
3. **Expected**: Real risk score from backend
4. Check backend logs for event

**Test Case B2: Risk Decision**
1. Backend running
2. Make UPI payment
3. Backend calculates actual score
4. **Expected**: ALLOW/STEP_UP/BLOCK based on logic

**Test Case B3: Check Swagger Docs**
1. Open http://localhost:8000/docs
2. **Expected**: Backend API documentation
3. Test endpoints:
   - `POST /v1/score` (risk scoring)
   - `POST /v1/totp/enroll` (TOTP enrollment)
   - `POST /v1/killswitch` (emergency freeze)
   - `GET /v1/events` (event log)

---

## Performance Testing

### Load Testing Checklist

- [ ] Scroll transaction list smoothly (100+ items if added)
- [ ] Quick navigation between 9 screens
- [ ] No lag when displaying risk assessment
- [ ] TOTP timer updates smoothly
- [ ] Images/QR codes render quickly
- [ ] Transitions are smooth (not janky)

### Memory Usage

- [ ] No memory leaks on screen transitions
- [ ] Dummy data doesn't cause memory bloat
- [ ] TOTP screen doesn't waste battery with timers

---

## Accessibility Testing

### Keyboard Navigation
- [ ] Tab through all interactive elements
- [ ] Buttons have visible focus indicators
- [ ] Enter/Space activates buttons

### Screen Reader
- [ ] Labels are descriptive
- [ ] Semantic structure is correct
- [ ] Icons have alt text (contentDescription)

### Colors
- [ ] Text contrast ≥ 4.5:1
- [ ] Don't rely on color alone (use icons + color)
- [ ] Red/green colorblind safe (add patterns/icons)

---

## Troubleshooting

### App won't start
```bash
flutter clean
flutter pub get
flutter run -v
```

### Build errors
```bash
flutter doctor    # Check environment
flutter pub upgrade  # Update dependencies
```

### Hot reload not working
```bash
# Try hot restart
press 'R' in terminal

# Or full restart
flutter run
```

### Backend connection error
```
Error: Backend unreachable
→ Check if uvicorn is running
→ Check API URL (should be 10.0.2.2:8000 for emulator)
```

### Biometric not working on emulator
```
→ Normal behavior (emulator limitation)
→ App falls back to showing code directly
→ Works on physical device
```

---

## Success Criteria

All tests should pass with:
- ✅ No crashes
- ✅ Smooth UI transitions
- ✅ Correct data displayed
- ✅ All buttons functional
- ✅ Forms validate input
- ✅ Backend integration (if running)
- ✅ No console errors

---

## Demo Script (2 minutes)

```
1. Launch app → Login Screen (5s)
2. Enter PIN → See risk assessment (10s)
3. Home Screen → Highlight key features (15s)
   - Account balance
   - Quick actions
   - Recent transactions
4. Demo UPI Payment → Show risk assessment (30s)
5. Show Travel Mode & TOTP → Code generation (20s)
6. Kill Switch → Emergency freeze (10s)
7. Settings → User profile (10s)
8. Logout → Back to login (5s)

Total: ~2 minutes
```

---

## Notes for Reviewers

- All screens use **dummy data** (no real transactions)
- UI is **complete** but backend integration may need adjustment
- **Risk assessment** is fully functional with visual indicators
- **TOTP generation** works offline (no internet required)
- **Kill switch** simulates account freeze
- Code is **well-structured** and easy to extend
- No **production secrets** in the codebase

---

**Last Updated**: July 21, 2026
**Status**: ✅ Ready for Testing
