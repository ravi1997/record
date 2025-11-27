# Medical Record System - Project Context

## Project Overview

This is a comprehensive medical record management system built with Flutter for mobile devices. The application allows healthcare professionals to create, manage, and sync patient records with associated files. It features a modern UI with Material Design principles, offline support, and data synchronization capabilities.

### Core Features
- **Patient Record Management**: Create and store patient records with CRN, UHID, name, and date of birth
- **File Attachment**: Attach multiple files (documents, images, scans) to each patient record
- **Local Storage**: All data is stored locally on the device using SQLite database
- **Offline Support**: Full functionality available without internet connection
- **Data Synchronization**: Sync records with a remote server when connectivity is available
- **Authentication**: Employee login and mobile OTP login
- **Search & Navigation**: Advanced search capabilities and dashboard
- **Data Management**: Export options (CSV, PDF, JSON) and backup/restore functionality

### Technical Architecture

**Frontend (Flutter):**
- State Management: Provider pattern for efficient state management
- Database: SQLite with sqflite package for local data storage
- File Handling: File picker and compression utilities for document management
- Networking: HTTP client for API communication
- UI Components: Custom widgets following Material Design principles

**Backend (Flask - referenced in documentation):**
- RESTful API: Comprehensive endpoints for data operations
- Database: SQLite for persistent data storage
- Authentication: Secure login and session management

**Security:**
- Data Encryption: AES encryption for sensitive patient information
- Secure Communication: HTTPS for all network requests
- Access Control: Role-based permissions for different user types

## Project Structure

```
medical-record-system/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── pages/                    # UI screens
│   │   ├── login_page.dart       # Authentication screen
│   │   ├── home_page.dart        # Main dashboard
│   │   ├── entry_page.dart       # Patient record creation
│   │   ├── search_page.dart      # Record search functionality
│   │   ├── profile_page.dart     # User profile management
│   │   ├── settings_page.dart    # Application settings
│   │   ├── record_details_page.dart # Record details view
│   │   └── dashboard_page.dart    # Advanced analytics
│   ├── services/                 # Business logic
│   │   ├── api_service.dart      # Backend API communication
│   │   ├── local_db_service.dart # Local database operations
│   │   ├── notification_service.dart # Push notifications
│   │   ├── export_service.dart    # Data export functionality
│   │   ├── sync_service.dart     # Data synchronization
│   │   ├── theme_provider.dart   # Theme management (using ThemeService)
│   │   ├── user_provider.dart    # User state management
│   │   ├── user_service.dart     # User-related operations
│   │   ├── utility_service.dart  # Helper functions
│   │   └── data_service.dart     # Data operations
│   ├── models/                   # Data models (not explicitly shown but implied)
│   └── constants/                # Application constants and themes
│       ├── app_colors.dart       # Color definitions
│       ├── app_constants.dart    # App-wide constants
│       └── theme_constants.dart  # Theme configurations
├── assets/                       # Static assets
├── test/                        # Unit and widget tests
└── backend/                     # Backend server (referenced in documentation)
```

## Current Project State

The project is currently in a state where a critical file `theme_service.dart` was deleted (as shown in git status). The `ThemeProvider` and `main.dart` still reference this missing `ThemeService` class, which would cause compilation errors. There are also various service files (like `error_handling_service.dart` and `logging_service.dart`) in the untracked files that have been added.

## Key Dependencies

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Provider: State management
- sqflite: SQLite database operations
- file_picker: File handling capabilities
- http: API communication
- shared_preferences: Local preferences storage
- pdf: PDF generation for exports
- csv: CSV file handling

## Building and Running

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio or VS Code with Flutter extensions

### Installation
1. Clone the repository
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

### Running the Application
```bash
flutter run
```

### Testing
```bash
flutter test
```

## Development Conventions

The project follows Material Design 3 guidelines with a focus on:
- Clean, intuitive interface
- Consistent theming throughout the application
- Proper error handling and logging
- Responsive layouts for different screen sizes
- Secure data handling practices
- Comprehensive testing of business logic and UI components

## Important Notes

1. **Missing ThemeService**: The project currently has a deleted `theme_service.dart` file that is still referenced in `ThemeProvider.dart` and `main.dart`, which will cause compilation errors.

2. **State Management**: The project uses Provider pattern with `ChangeNotifierProvider` for state management.

3. **Theming**: The project implements a sophisticated theming system with support for light/dark modes and multiple color schemes.

4. **Testing**: The project includes unit tests for various services and pages, following Flutter testing best practices.

## Common Commands

- `flutter pub get` - Install dependencies
- `flutter run` - Run the application
- `flutter test` - Run tests
- `flutter build apk` - Build APK for Android
- `flutter build ios` - Build for iOS
- `flutter analyze` - Run static analysis
- `flutter doctor` - Check development environment