# Medical Record System

A comprehensive medical record management system built with Flutter for mobile devices. This application allows healthcare professionals to create, manage, and sync patient records with associated files.

## Features

### Core Functionality
- **Patient Record Management**: Create and store patient records with CRN, UHID, name, and date of birth
- **File Attachment**: Attach multiple files (documents, images, scans) to each patient record
- **Local Storage**: All data is stored locally on the device using SQLite database
- **Offline Support**: Full functionality available without internet connection
- **Data Synchronization**: Sync records with a remote server when connectivity is available

### Authentication
- **Employee Login**: Secure login with employee ID and password
- **Mobile OTP Login**: Alternative login method using mobile number and OTP verification

### Search & Navigation
- **Advanced Search**: Search patient records by CRN, UHID, or patient name
- **Dashboard**: Overview of key metrics and recent activity
- **Profile Management**: User profile with personal information
- **Settings**: Application configuration and preferences

### Data Management
- **Export Options**: Export data in CSV, PDF, and JSON formats
- **Backup & Restore**: Create backups of all patient data
- **Data Visualization**: Analytics dashboard with charts and graphs

### UI/UX Features
- **Modern Design**: Clean, intuitive interface with Material Design principles
- **Responsive Layout**: Adapts to different screen sizes and orientations
- **Dark/Light Mode**: Automatic theme switching based on system preferences
- **Customizable Themes**: Multiple color schemes to choose from
- **Animations**: Smooth transitions and micro-interactions for enhanced user experience

## Technical Architecture

### Frontend (Flutter)
- **State Management**: Provider pattern for efficient state management
- **Database**: SQLite with sqflite package for local data storage
- **File Handling**: File picker and compression utilities for document management
- **Networking**: HTTP client for API communication
- **UI Components**: Custom widgets for consistent design language

### Backend (Flask)
- **RESTful API**: Comprehensive endpoints for data operations
- **Database**: SQLite for persistent data storage
- **Authentication**: Secure login and session management
- **File Storage**: Organized file system for patient documents
- **Data Validation**: Input sanitization and validation

### Security
- **Data Encryption**: AES encryption for sensitive patient information
- **Secure Communication**: HTTPS for all network requests
- **Access Control**: Role-based permissions for different user types
- **Audit Trail**: Logging of all user activities

## Getting Started

### Prerequisites
- Flutter SDK (3.10 or higher)
- Dart SDK (2.19 or higher)
- Android Studio or VS Code with Flutter extensions
- Python 3.8+ for backend development

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/medical-record-system.git
   cd medical-record-system
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Install backend dependencies**:
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

4. **Run the backend server**:
   ```bash
   python app.py
   ```

5. **Run the Flutter app**:
   ```bash
   cd ..
   flutter run
   ```

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
│   │   └── dashboard_page.dart    # Advanced analytics
│   ├── services/                 # Business logic
│   │   ├── api_service.dart      # Backend API communication
│   │   ├── local_db_service.dart # Local database operations
│   │   ├── notification_service.dart # Push notifications
│   │   ├── export_service.dart    # Data export functionality
│   │   ├── sync_service.dart     # Data synchronization
│   │   ├── utility_service.dart  # Helper functions
│   │   └── theme_service.dart   # Theme management
│   └── models/                   # Data models
├── backend/
│   ├── app.py                    # Flask application
│   ├── requirements.txt          # Python dependencies
│   └── instance/                 # Database files
├── assets/                       # Static assets
└── test/                        # Unit and widget tests
```

## Development Workflow

### Adding New Features
1. Create a new branch for feature development
2. Implement the feature following the established patterns
3. Write unit tests for new functionality
4. Update documentation as needed
5. Submit a pull request for code review

### Testing
- **Unit Tests**: Test business logic and service classes
- **Widget Tests**: Verify UI component behavior
- **Integration Tests**: End-to-end testing of critical flows
- **Performance Tests**: Monitor app responsiveness and memory usage

### Deployment
- **Android**: Generate signed APK/APK for Google Play Store
- **iOS**: Archive and distribute through App Store Connect
- **Backend**: Deploy to cloud hosting provider (AWS, GCP, Azure)

## Contributing

We welcome contributions from the community! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a pull request

Please ensure your code follows the project's coding standards and includes appropriate tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please open an issue on GitHub or contact the development team at support@medicalrecordsystem.com.

## Acknowledgments

- Thanks to all contributors who have helped shape this project
- Special recognition to the open-source community for providing excellent libraries and tools
- Inspired by modern healthcare management systems and best practices
