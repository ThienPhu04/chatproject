# Chat AI

An intelligent conversation application powered by Google Gemini AI, built with Flutter following Clean Architecture principles.

## 📋 Overview

Chat AI is a multi-platform mobile application that enables users to engage in natural conversations with an AI assistant. The app features user authentication, persistent message history, text-to-speech capabilities, and seamless content sharing across platforms.

**Repository**: [ThienPhu04/chatproject](https://github.com/ThienPhu04/chatproject)

## ✨ Key Features

- **🤖 AI-Powered Chat**: Real-time conversations using Google Gemini 2.0 Flash API with full conversation context
- **🔐 Multi-Method Authentication**: Email, Google, Apple, and Facebook Sign-In via Firebase
- **💾 Offline Persistence**: Message history and chat sessions stored locally with Hive
- **🔊 Text-to-Speech**: Built-in TTS playback for AI responses
- **🌍 Multilingual Support**: Full UI localization (English, Vietnamese) with EasyLocalization
- **🎨 Dynamic Theming**: Light/Dark mode with persistent user preferences
- **🔗 Deep Linking**: Share chat conversations across platforms with custom URL scheme
- **💬 Message Suggestions**: Pre-loaded prompt suggestions for enhanced user experience
- **📱 Responsive Design**: Modern, adaptive UI with smooth navigation and animations
- **🔔 Push Notifications**: Firebase Cloud Messaging integration
- **⚙️ Multi-Flavor Support**: Dev, Staging, and Production build configurations

## 🏗️ Architecture

The project follows **Clean Architecture** with clear separation of concerns:

```
Presentation Layer (Cubits, Pages, Widgets)
    ↓
Domain Layer (Entities, Repositories, UseCases)
    ↓
Data Layer (DataSources, Models, Repositories)
    ↓
Core Layer (Services, Theme, Router, Config)
```

### Technology Stack

| Category | Technologies |
|----------|--------------|
| **State Management** | Bloc/Cubit |
| **Navigation** | GoRouter |
| **HTTP Client** | Dio |
| **Local Database** | Hive |
| **Authentication** | Firebase Auth |
| **AI Integration** | Google Gemini API |
| **Localization** | Easy Localization |
| **Code Generation** | Build Runner, Freezed |
| **Persistence** | SharedPreferences, Hive |

## 📦 Prerequisites

- Flutter 3.16.0+
- Dart 3.2.0+
- Firebase account with configured project
- Google Gemini API key
- Xcode 15+ (for iOS)
- Android Studio with NDK (for Android)

## 🚀 Getting Started

### 1. Clone Repository
```bash
git clone https://github.com/ThienPhu04/chatproject.git
cd finalproject
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Firebase
- Update Firebase configuration in `lib/firebase_options.dart`
- Add `google-services.json` (Android)
- Add `GoogleService-Info.plist` (iOS)

### 4. Set Environment Variables
Create `.env` file in project root:
```env
GEMINI_API_KEY=your_gemini_api_key
```

### 5. Generate Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Build & Run
```bash
# Development flavor
flutter run -t lib/main.dart --flavor dev

# Production flavor
flutter run -t lib/main.dart --flavor prod
```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── firebase_options.dart              # Firebase configuration
├── app_export.dart                    # Centralized exports
│
├── core/                              # Shared resources
│   ├── config/                        # Environment & flavor config
│   ├── constant/                      # App constants
│   ├── error/                         # Error handling
│   ├── network/                       # Network configuration
│   ├── router/                        # GoRouter setup
│   ├── services/                      # TTS, FCM services
│   ├── theme/                         # Colors, themes
│   └── utils/                         # Utility functions
│
├── features/                          # Feature modules
│   ├── auth/                          # Authentication
│   │   └── [data, domain, presentation]
│   ├── chat/                          # Chat functionality
│   │   └── [data, domain, presentation]
│   ├── chat_history/                  # Message history
│   │   └── [data, domain, presentation]
│   ├── setting/                       # User settings
│   │   └── [data, domain, presentation]
│   ├── share/                         # Deep linking
│   │   └── [data, domain, presentation]
│   └── onboarding/                    # Onboarding flow
│       └── [data, domain, presentation]
│
└── gen/                               # Generated files (assets, localization)
```

## 🔐 Features Breakdown

### Authentication
- Multi-provider sign-in (Email, Google, Apple, Facebook)
- Secure token management with Firebase
- User profile management
- Logout with session cleanup

### Chat System
- **AI Integration**: Gemini 2.0 Flash API with streaming responses
- **Message Management**: Send, receive, and store messages locally
- **Conversation Context**: Full history passed to maintain context
- **Suggestions**: Pre-loaded prompts displayed when starting conversations
- **Status Tracking**: Real-time message delivery status

### Persistence
- **Hive Database**: Local NoSQL storage for messages and sessions
- **Offline Mode**: Access message history without internet
- **Data Sync**: Automatic sync when connection restored

### Localization
- **Supported Languages**: English (en), Vietnamese (vi)
- **Dynamic Switching**: Change language at runtime
- **Persistent Settings**: User language preference saved

### Theme System
- **Light/Dark Modes**: Material 3 design system
- **Persistent Theme**: User preference saved and restored
- **Dynamic Colors**: Automatic color palette adjustment

## 🛠️ Development Commands

```bash
# Run dev flavor with hot reload
flutter run -d chrome --flavor dev

# Build for production
flutter build apk --release --flavor prod
flutter build ipa --release --flavor prod

# Run tests
flutter test

# Generate code
dart run build_runner build

# Format code
dart format lib/

# Analyze code
flutter analyze
```

## 📝 State Management

The app uses **Cubit** pattern with the following state managers:

| Cubit | Responsibility |
|-------|-----------------|
| `AuthCubit` | User authentication state |
| `ChatCubit` | Chat messages and AI responses |
| `ChatHistoryCubit` | Chat session management |
| `TtsCubit` | Text-to-speech playback |
| `SettingsCubit` | User preferences (language, theme) |
| `ShareCubit` | Deep link generation |
| `AppCubit` | Global app state |

## 🌐 API Integration

### Google Gemini API
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent`
- **Authentication**: API key via environment variables
- **Features**: Streaming responses, context awareness, error handling

## 📱 Platform Support

- ✅ Android (API 21+)
- ✅ iOS (13.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ✅ macOS (10.13+)
- ✅ Windows (10+)
- ✅ Linux

## 📄 License

This project is private. For inquiries, contact the repository owner.

## 👤 Author

**Đoàn Thiên Phú**

- GitHub: [@ThienPhu04](https://github.com/ThienPhu04)
- Portfolio: https://github.com/ThienPhu04/chatproject

## 🤝 Contributing

This is a private project. For contributions or inquiries, please contact the repository owner.

---

**Last Updated**: March 2026
