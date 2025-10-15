# Installation Guide

This guide will walk you through the process of installing the Medical Record System on your local machine for development, testing, or production use.

## Prerequisites

Before installing the Medical Record System, ensure you have the following prerequisites installed on your system:

### System Requirements

- Operating System: Windows 10+, macOS 10.15+, Ubuntu 18.04+, or equivalent
- RAM: Minimum 8GB, Recommended 16GB+
- Storage: Minimum 10GB free space
- Internet connection for downloading dependencies

### Development Tools

- Flutter SDK 3.10 or higher
- Dart SDK 2.19 or higher
- Android Studio or Visual Studio Code with Flutter extensions
- Xcode (for iOS development)
- Node.js 16+ (for some build tools)
- Python 3.8+ (for backend development)

### Mobile Development (Optional)

For building mobile apps:

- Android SDK (comes with Android Studio)
- iOS SDK with Xcode (macOS only)
- CocoaPods (iOS dependency manager)

### Backend Development (Optional)

For running the backend server:

- Python 3.8+
- pip package manager
- Virtual environment tools (venv or conda)

## Installation Steps

### 1. Install Flutter

#### Windows/macOS/Linux

1. Download Flutter SDK from [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. Extract the zip file and place the contained flutter in the desired installation location of the hard drive
3. Update your path:
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. Verify installation:
   ```bash
   flutter doctor
   ```

#### Using Package Managers

##### macOS with Homebrew:
```bash
brew install --cask flutter
```

##### Linux with Snap:
```bash
sudo snap install flutter --classic
```

### 2. Install Backend Dependencies

Navigate to the backend directory and install Python dependencies:

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`
pip install -r requirements.txt
```

### 3. Configure the Backend

1. Create a `.env` file in the backend directory:
   ```bash
   touch .env
   ```

2. Add the following configuration:
   ```
   SECRET_KEY=your-secret-key-here
   DATABASE_URL=sqlite:///instance/medical_records.db
   MAX_FILE_SIZE=5242880  # 5MB in bytes
   ```

3. Initialize the database:
   ```bash
   python init_db.py
   ```

### 4. Install Flutter Dependencies

From the root directory, install all Flutter dependencies:

```bash
flutter pub get
```

### 5. Configure Mobile Development (Optional)

#### Android

1. Install Android Studio
2. Set up Android SDK and AVD Manager
3. Accept Android licenses:
   ```bash
   flutter doctor --android-licenses
   ```

#### iOS (macOS only)

1. Install Xcode from the App Store
2. Install CocoaPods:
   ```bash
   sudo gem install cocoapods
   ```

### 6. Run the Backend Server

Start the backend server:

```bash
cd backend
source venv/bin/activate  # On Windows use `venv\Scripts\activate`
python app.py
```

The backend server will start on `http://localhost:5000`.

### 7. Run the Mobile App

Connect a device or start an emulator, then run:

```bash
flutter run
```

For specific target platforms:

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome
```

## Configuration

### Environment Variables

Create a `.env` file in the root directory for the mobile app:

```
BACKEND_URL=http://192.168.1.8:5000
MAX_FILE_SIZE=5242880  # 5MB in bytes
```

### Network Configuration

Ensure your mobile device and development machine are on the same network for local development. Update the backend URL in the app to match your machine's IP address.

## Verification

To verify that the installation was successful:

1. Check that the backend server is running:
   ```bash
   curl http://localhost:5000/health
   ```

2. Launch the mobile app and ensure it connects to the backend:
   - Open the app
   - Try logging in with test credentials
   - Create a test patient record
   - Verify that the record appears in the database

## Troubleshooting

### Common Issues

#### Flutter Doctor Issues

If `flutter doctor` shows issues:

1. Install missing dependencies as recommended
2. Ensure PATH variables are set correctly
3. Restart your terminal/command prompt

#### Database Connection Errors

1. Verify the backend server is running
2. Check that the database file exists and has correct permissions
3. Ensure the database URL in configuration is correct

#### Network Connectivity Issues

1. Verify your device and development machine are on the same network
2. Check firewall settings
3. Try using `10.0.2.2` instead of `localhost` for Android emulators

#### File Permission Errors

1. Ensure the app has storage permissions
2. Check that the database directory is writable
3. Run the app with administrator privileges if necessary

## Updating

To update to the latest version:

1. Pull the latest changes from the repository:
   ```bash
   git pull origin main
   ```

2. Update Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Update backend dependencies:
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

4. Apply database migrations if any:
   ```bash
   python migrate.py
   ```

## Next Steps

After successful installation:

1. Read the [Quick Start Guide](quick-start.md) to begin using the system
2. Explore the [User Guide](../user-guide/index.md) for detailed functionality
3. Review the [Administrator Guide](../admin-guide/index.md) for system administration
4. Check the [Development Guide](../development/index.md) if you plan to contribute

## Support

If you encounter issues during installation:

1. Check the [Troubleshooting Guide](../troubleshooting/common-issues.md)
2. Search existing [GitHub Issues](https://github.com/medical-record-system/medical-record-system/issues)
3. Open a new issue with detailed information about the problem

For commercial support options, visit [our website](https://medicalrecordsystem.com/support).