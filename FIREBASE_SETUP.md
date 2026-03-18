# Sattva — Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click "Add project" → name it `sattva-app`
3. Disable Google Analytics (optional) → Create project

---

## Step 2: Enable Authentication

1. In Firebase Console → **Build → Authentication**
2. Click "Get started"
3. Enable **Email/Password** provider
4. Enable **Anonymous** provider (for guest login)

---

## Step 3: Create Firestore Database

1. **Build → Firestore Database** → Create database
2. Start in **test mode** (you'll tighten rules later)
3. Choose a region (e.g., `asia-south1` for India)

### Firestore Security Rules (paste this):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## Step 4: Add Android App

1. **Project Settings → Your apps → Add app → Android**
2. Package name: `com.yourname.sattva_app`
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`

### android/build.gradle — add to `dependencies`:
```groovy
classpath 'com.google.gms:google-services:4.4.2'
```

### android/app/build.gradle — add at bottom:
```groovy
apply plugin: 'com.google.gms.google-services'
```

---

## Step 5: Add iOS App (optional)

1. **Project Settings → Add app → iOS**
2. Bundle ID: `com.yourname.sattvaApp`
3. Download `GoogleService-Info.plist`
4. Drag it into Xcode under `Runner/`

---

## Step 6: Install & Run

```bash
flutter pub get
flutter run
```

---

## Firestore Data Structure

```
users/
  {uid}/
    daily_habits/
      2024-01-15/          ← today's date
        habits/
          habit_1/         ← { name, time, emoji, completed, completedAt }
          habit_2/
          ...
    summaries/
      2024-01-15/          ← { date, completed, total, percent, savedAt }
```

---

## Features enabled by Firebase

| Feature              | How it works                          |
|----------------------|---------------------------------------|
| User login           | Email/Password + Anonymous auth       |
| Real-time sync       | Firestore snapshot listener           |
| Daily habits         | Auto-seeded per user per day          |
| Streak tracking      | summaries collection, last 16 days    |
| Offline support      | Firestore offline cache (automatic)   |

---

## Build APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```
