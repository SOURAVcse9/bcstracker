<div align="center">

<img src="assets/icon/app_icon.png" alt="BCSTracker Logo" width="120" />

# BCSTracker

**A fully offline BCS Preliminary Syllabus Tracker for Android**

[![Flutter](https://img.shields.io/badge/Flutter-3.19%2B-02569B?logo=flutter)](https://flutter.dev)
[![Android](https://img.shields.io/badge/Android-5.0%2B-3DDC84?logo=android)](https://developer.android.com)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue)](https://github.com/SouravDebnath/bcstracker/releases/latest)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

> Track your BCS preliminary preparation — topic by topic, subject by subject.  
> No internet. No server. Everything stays on your phone.

### ⬇️ [Download Latest APK — v1.0.0](https://github.com/SouravDebnath/bcstracker/releases/download/v1.0.0/app-release.apk)

</div>

---

## ✨ Features

| Feature | Details |
|---|---|
| 📚 **Full Syllabus** | Complete 51st BCS Preliminary syllabus with mark distribution |
| ☑️ **Topic Checkboxes** | Mark topics as started / completed |
| 📅 **Date Tracking** | Per-topic start & end dates with duration display |
| 📊 **Progress Rings** | Subject-wise and overall progress visualization |
| 🏆 **Weighted Score** | Estimated marks earned based on syllabus weightage |
| 🔥 **Study Streak** | Daily streak counter to keep you motivated |
| ⏳ **Exam Countdown** | Set your exam date and track days remaining |
| 📝 **Personal Notes** | Write notes for every topic |
| 🔍 **Search & Filter** | Quickly find incomplete topics |
| 📈 **Statistics** | Bar charts with subject-wise breakdown |
| 🌙 **Dark / Light Mode** | System, light, or dark theme |
| 🔔 **Notifications** | Study reminders via BCSTracker notification channel |
| 🔄 **Reset Progress** | One-tap full progress reset |
| 🔒 **100% Offline** | Zero internet, zero server, zero data collection |

---

## 📱 Screenshots

| Home | Subject Detail | Statistics | Settings |
|---|---|---|---|
| *(coming soon)* | *(coming soon)* | *(coming soon)* | *(coming soon)* |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.19` (stable channel)
- Android Studio or VS Code with Flutter plugin
- Android device or emulator (Android 5.0+)

### Run Locally
```bash
# Clone the repo
git clone https://github.com/SouravDebnath/bcstracker.git
cd bcstracker

# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run
```

### Build Release APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🗂️ Project Structure

```
bcstracker/
├── lib/
│   ├── data/           → Full BCS syllabus data (syllabus_data.dart)
│   ├── models/         → Topic & Subject data models
│   ├── providers/      → ProgressProvider (state + SharedPreferences)
│   ├── screens/        → HomeScreen, SubjectScreen, StatsScreen, SettingsScreen
│   ├── utils/          → Helpers: date_utils.dart, notification_service.dart
│   ├── widgets/        → Reusable UI components
│   ├── theme/          → App theme (light/dark)
│   └── main.dart       → App entry point
├── android/            → Android platform files
├── assets/
│   └── icon/           → App logo
└── pubspec.yaml
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.19+ (Dart) |
| State Management | Provider |
| Local Storage | shared_preferences |
| Charts | fl_chart |
| Notifications | flutter_local_notifications |
| Min SDK | Android 5.0 (API 21) |
| Target SDK | Android SDK 36 |

---

## 🔧 Customization

| Goal | File to edit |
|---|---|
| Change syllabus topics | `lib/data/syllabus_data.dart` |
| Change app colors | `lib/theme/app_theme.dart` → `seed` color |
| Change app icon | `android/app/src/main/res/mipmap-*/ic_launcher.png` |
| Change app name | `android/app/src/main/AndroidManifest.xml` |

---

## 🐛 Troubleshooting

<details>
<summary><strong>Gradle version error</strong></summary>

Update `android/gradle/wrapper/gradle-wrapper.properties`:
```
distributionUrl=https\://services.gradle.org/distributions/gradle-9.1.0-all.zip
```
And `android/settings.gradle` — bump `com.android.application` version to `8.11.1` or higher.
</details>

<details>
<summary><strong>"Different roots" / Kotlin daemon crash on Windows</strong></summary>

Move the project to the same drive as your Flutter SDK (e.g., `C:\Projects\bcstracker`).  
Or add `kotlin.incremental=false` to `android/gradle.properties`.
</details>

<details>
<summary><strong>Could not GET dl.google.com</strong></summary>

Network/firewall issue — not a project bug. Try:
- Disable VPN or switch to mobile hotspot
- Temporarily disable antivirus/firewall
- Run `ping dl.google.com` to test DNS resolution
</details>

<details>
<summary><strong>Corrupted Gradle cache</strong></summary>

```bash
flutter clean
cd android && gradlew --stop && cd ..
# Delete: C:\Users\<you>\.gradle\caches
flutter pub get
flutter build apk --release
```
</details>

---

## 📦 Release

| Version | Date | APK |
|---|---|---|
| [v1.0.0](https://github.com/SouravDebnath/bcstracker/releases/tag/v1.0.0) | September 2026 | [⬇️ Download](https://github.com/SouravDebnath/bcstracker/releases/download/v1.0.0/app-release.apk) |

---

## 👤 Author

**SOURAV DEBNATH**  
GitHub: [@SouravDebnath](https://github.com/SouravDebnath)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

<div align="center">
  Made with ❤️ for BCS aspirants of Bangladesh 🇧🇩
</div>


