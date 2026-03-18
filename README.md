<div align="center">

# 🪷 Sattva

**A culturally personalised health habit tracker for the South Indian lifestyle**

<img src="https://github.com/Danedie04/Sattva-app/blob/main/Screen%20shots/Overview.png" width="1000" height="900"/>


![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=flat-square&logo=firebase)
![Claude AI](https://img.shields.io/badge/Claude_AI-Sonnet-7C3AED?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

*Rooted in Ayurveda · Powered by AI · Built with Flutter*

</div>

---

## ✨ What is Sattva?

**Sattva** (Sanskrit: *सत्त्व* — purity, clarity, balance) is a mobile habit tracker that respects your culture. Unlike generic wellness apps that ignore local food and lifestyle, Sattva is built around the South Indian daily routine — idli mornings, sambar afternoons, and early nights.

It combines a **premium dark UI**, **Firebase real-time sync**, a **16-day streak tracker**, and an **AI wellness coach** grounded in Bhagavad Gita philosophy and Ayurvedic wisdom.

---

## 📱 Screenshots

| Login | Dashboard | AI Coach | Progress | Streak |
|:---:|:---:|:---:|:---:|:---:|
| ![Login](https://github.com/Danedie04/Sattva-app/blob/main/Screen%20shots/Screenshot%201.png) | ![Dashboard](https://github.com/Danedie04/Sattva-app/blob/main/Screen%20shots/Screenshot%202.png) | ![Coach](https://github.com/Danedie04/Sattva-app/blob/main/Screen%20shots/Screenshot%203.png) | ![Progress](https://github.com/Danedie04/Sattva-app/blob/main/Screen%20shots/Screenshot%204.png) | ![Streak](https://github.com/Danedie04/Sattva-app/blob/main/Screen%20shots/Screenshot%205.png) |

---

## 🧱 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart) |
| Auth | Firebase Authentication (Email + Anonymous) |
| Database | Cloud Firestore (real-time) |
| AI Coach | Claude API (claude-haiku-4-5) |
| State | Provider + ChangeNotifier |
| UI | google_fonts · flutter_animate |
| Notifications | flutter_local_notifications |

---

## 🗂️ Project Structure

```
sattva_app/
├── lib/
│   ├── core/
│   │   ├── theme.dart          # Cormorant Garamond + DM Sans design system
│   │   └── constants.dart      # Palette, spacing, border radius
│   ├── models/
│   │   └── habit.dart          # Habit model with Firestore toMap/fromMap
│   ├── data/
│   │   └── default_habits.dart # 10 South Indian daily habits
│   ├── providers/
│   │   └── habit_provider.dart # Real-time Firestore state (ChangeNotifier)
│   ├── services/
│   │   ├── auth_service.dart       # Firebase Auth (email + anonymous)
│   │   ├── firestore_service.dart  # CRUD + streak summaries
│   │   └── notification_service.dart
│   ├── screens/
│   │   ├── auth_screen.dart        # Login / Sign Up UI
│   │   ├── home_shell.dart         # Bottom nav shell
│   │   ├── dashboard_screen.dart   # Today's habits
│   │   ├── progress_screen.dart    # Daily breakdown
│   │   ├── streak_screen.dart      # 16-day analytics grid
│   │   ├── ai_coach_screen.dart    # AI chat interface
│   │   └── settings_screen.dart
│   ├── widgets/
│   │   ├── habit_tile.dart         # Animated habit row
│   │   └── progress_card.dart      # Ring chart progress widget
│   └── utils/
│       └── quote_generator.dart    # Krishna / Thirukkural quotes
└── pubspec.yaml
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Firebase project (see setup below)
- Anthropic API key

### 1 · Clone & Install

```bash
git clone https://github.com/yourusername/sattva_app.git
cd sattva_app
flutter pub get
```

### 2 · Firebase Setup

1. Go to [console.firebase.google.com](https://console.firebase.google.com) → Create project
2. Enable **Authentication** → Email/Password + Anonymous
3. Enable **Firestore** → Start in test mode → Region: `asia-south1`
4. Add Android app → download `google-services.json` → place in `android/app/`
5. Add iOS app (optional) → download `GoogleService-Info.plist` → add to Xcode

**Firestore Security Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 3 · Add Your API Key

In `lib/screens/ai_coach_screen.dart`:
```dart
static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY';
```

> ⚠️ **Production note**: Never ship API keys in client code. Route through your own backend.

### 4 · Run

```bash
flutter run
```

---

## 🔥 Firestore Data Model

```
users/
  {uid}/
    daily_habits/
      2024-01-15/           ← date key (YYYY-MM-DD)
        habits/
          habit_1/          ← { name, time, emoji, completed, completedAt }
          habit_2/
          ...
    summaries/
      2024-01-15/           ← { date, completed, total, percent, savedAt }
```

---

## 🧘 Default Habits (South Indian Lifestyle)

| # | Habit | Time |
|---|---|---|
| 1 | 🌅 Wake Up | 5:30 AM |
| 2 | 💧 Drink Warm Water | 6:00 AM |
| 3 | 🧘 Morning Walk / Yoga | 6:30 AM |
| 4 | 🍽️ Breakfast (Idli / Dosa) | 8:30 AM |
| 5 | 🍌 Fruit (Banana / Papaya) | 11:00 AM |
| 6 | 🥤 Hydration | Every 1 hr |
| 7 | 🍛 Lunch (Rice + Sambar) | 1:30 PM |
| 8 | 🥜 Evening Snack | 5:00 PM |
| 9 | 🌙 Dinner | 8:00 PM |
| 10 | 📵 No Screen | 10:00 PM |

---

## 🤖 AI Coach — Sattva Coach

The AI Coach is a Claude-powered wellness assistant personalised to:

- Your **real-time habit progress** (passed as context with every message)
- **South Indian foods** — idli, dosa, rasam, kozhukattai, sambar
- **Ayurvedic principles** — doshas, meal timing, sleep rhythms
- **Bhagavad Gita & Thirukkural** wisdom — discipline as devotion

**Quick prompts available:**
- Why is my energy low after lunch?
- Best time to drink water?
- How to sleep better tonight?
- What should I eat before yoga?

---

## 📦 Build APK

```bash
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

**App Bundle (Play Store):**
```bash
flutter build appbundle
# → build/app/outputs/bundle/release/app-release.aab
```

---

## 🎨 Design System

| Token | Value |
|---|---|
| Background | `#08090E` |
| Surface | `#0F1119` |
| Card | `#13161F` |
| Accent (violet) | `#B57BFF` |
| Accent Glow | `#7C3AED` |
| Gold | `#E8C97E` |
| Display font | Cormorant Garamond |
| Body font | DM Sans |
| Mono font | DM Mono |

---

## 🗺️ Roadmap

- [ ] Push notifications (scheduled per habit time)
- [ ] Custom habit creator
- [ ] Onboarding flow
- [ ] Weekly analytics charts
- [ ] Shared family streaks
- [ ] Tamil / Kannada localisation

---

## 🙏 Philosophy

> *"You have the right to perform your duty, not the results."*
> — Bhagavad Gita 2:47

Sattva is built on the belief that small, consistent daily actions — not dramatic transformations — create lasting health. The app rewards showing up, not perfection.

---

## 📄 License

MIT © 2024 — Built with 🪷 and discipline.
