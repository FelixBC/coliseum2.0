# Coliseum 2.0

Welcome to **Coliseum 2.0**! This is a modern Flutter application designed as a social platform, featuring user authentication, posts, comments, stories, messaging, property booking, and more. This README will help new contributors understand the project structure, where to make changes, and how to get started.

---

## 🚀 Project Overview
Coliseum 2.0 is a full-featured social and booking app built with Flutter. It supports user registration/login, profile management, posting, commenting, messaging, and property booking. The app is designed to be modular, scalable, and easy to extend.

---

## ✨ Features
- User authentication (login/register)
- User profiles
- Posts, comments, and stories
- Messaging between users
- Property booking and details
- Saved properties and posts
- Theming and custom UI components

---

## 📁 Project Structure

```
coliseum/
  ├── android/           # Android native code & configs
  ├── ios/               # iOS native code & configs
  ├── lib/               # Main Flutter/Dart code
  │   ├── constants/     # App-wide constants (routes, theme, etc.)
  │   ├── models/        # Data models (User, Post, Comment, etc.)
  │   ├── services/      # Business logic & API/mock services
  │   ├── viewmodels/    # State management (Provider/ViewModel)
  │   ├── views/         # UI pages/screens (organized by feature)
  │   └── widgets/       # Reusable UI components
  ├── assets/            # Images and static assets
  ├── test/              # Unit/widget tests
  ├── pubspec.yaml       # Flutter dependencies & assets
  └── README.md          # This file
```

---

## 🛠️ Where to Modify

- **UI Pages:**
  - `lib/views/` — Each feature (auth, home, profile, etc.) has its own folder. For example, to modify the login page, edit `lib/views/auth/login_page.dart`.
- **Business Logic:**
  - `lib/services/` — Contains service classes for authentication, posts, users, etc. Add or modify API calls and business logic here.
- **State Management:**
  - `lib/viewmodels/` — ViewModel classes using Provider for state management. Update these to change how data flows between UI and services.
- **Data Models:**
  - `lib/models/` — Dart classes representing app data (User, Post, Comment, etc.). Update or add models as needed.
- **Reusable Widgets:**
  - `lib/widgets/` — Custom UI components (buttons, text fields, cards, etc.).
- **App Constants & Routing:**
  - `lib/constants/` — App-wide constants, theme, and route definitions.
  - `lib/router.dart` — Main app router using GoRouter.
- **Assets:**
  - `assets/images/` — Add or replace images and icons here. Update `pubspec.yaml` if you add new assets.

---

## 🏁 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart (comes with Flutter)
- Android Studio or VS Code (recommended)
- An Android/iOS device or emulator

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/coliseum2.0.git
   cd coliseum2.0/coliseum
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```
   > By default, the app runs on the first available device. Use `flutter devices` to list and select a device.

---

## 🧑‍💻 Adding Features or Fixing Bugs
- **UI changes:** Edit or add files in `lib/views/` and `lib/widgets/`.
- **Business logic:** Update or add services in `lib/services/`.
- **State management:** Modify or create new ViewModels in `lib/viewmodels/`.
- **Data models:** Update or add models in `lib/models/`.
- **Routing:** Add new routes in `lib/constants/routes.dart` and update `lib/router.dart`.
- **Assets:** Place new images in `assets/images/` and update `pubspec.yaml`.

---

## 🤝 Contributing Guidelines
1. Fork the repository and create your branch from `master`.
2. Write clear, descriptive commit messages.
3. Test your changes before submitting a PR.
4. Open a Pull Request with a detailed description of your changes.
5. Follow the existing code style and structure.

---

## 📬 Contact & Support
For questions, suggestions, or support, open an issue on GitHub or contact the project maintainer.

---

**Happy coding!** 🎉
