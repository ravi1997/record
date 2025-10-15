# Medical Record System - Project Documentation

## Table of Contents
1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Core Components](#core-components)
6. [Database Design](#database-design)
7. [API Documentation](#api-documentation)
8. [Security Implementation](#security-implementation)
9. [Testing Strategy](#testing-strategy)
10. [Deployment Guide](#deployment-guide)
11. [Troubleshooting](#troubleshooting)

## Overview

The Medical Record System is a comprehensive mobile application designed for healthcare professionals to manage patient records efficiently. The system provides offline capabilities with eventual synchronization to a central server, ensuring data availability even in low-connectivity environments.

### Key Features
- Offline-first architecture with local SQLite database
- Secure authentication (employee credentials and mobile OTP)
- Patient record creation with CRN/UHID identifiers
- File attachment support (documents, images, scans)
- Advanced search functionality
- Data export capabilities (CSV, PDF, JSON)
- Analytics dashboard with visualizations
- Theme customization and accessibility features

## System Architecture

### High-Level Architecture
```
┌─────────────────────┐    ┌─────────────────────┐
│   Mobile App        │    │   Backend Server    │
│   (Flutter)         │    │   (Flask)           │
├─────────────────────┤    ├─────────────────────┤
│  UI Layer           │    │  REST API           │
│  Business Logic     │◄──►│  Business Logic     │
│  Local Storage      │    │  Central Database   │
│  (SQLite)           │    │  (SQLite)            │
└─────────────────────┘    └─────────────────────┘
         │                           │
         ▼                           ▼
   ┌─────────────┐             ┌─────────────┐
   │   Device    │             │   Server    │
   │   Storage   │             │   Host      │
   └─────────────┘             └─────────────┘
```

### Data Flow
1. User interacts with Flutter UI components
2. Business logic layer processes requests
3. Data is stored in local SQLite database
4. Background sync service periodically synchronizes with backend
5. Backend processes and stores data in central database
6. Changes are propagated back to clients during sync

## Technology Stack

### Frontend (Mobile App)
- **Framework**: Flutter (Dart)
- **Database**: SQLite with sqflite package
- **State Management**: Provider pattern
- **Networking**: http package
- **File Handling**: file_picker, path_provider
- **UI Components**: Material Design widgets
- **Document Generation**: pdf, csv packages
- **Local Storage**: shared_preferences

### Backend (Server)
- **Framework**: Flask (Python)
- **Database**: SQLite
- **API**: RESTful endpoints
- **Authentication**: Session-based with token management
- **File Storage**: Local filesystem with organized directory structure
- **Security**: HTTPS, input validation, rate limiting

### Development Tools
- **IDE**: Visual Studio Code
- **Version Control**: Git with GitHub
- **Package Management**: pubspec.yaml, pip
- **Testing**: flutter_test, unittest
- **Documentation**: Markdown, JSDoc

## Project Structure

```
medical-record-system/
├── lib/                          # Flutter application source
│   ├── main.dart                 # Application entry point
│   ├── pages/                    # UI screens
│   │   ├── login_page.dart       # Authentication screen
│   │   ├── home_page.dart        # Main dashboard
│   │   ├── entry_page.dart       # Patient record creation
│   │   ├── search_page.dart      # Record search functionality
│   │   ├── profile_page.dart     # User profile management
│   │   ├── settings_page.dart    # Application settings
│   │   └── dashboard_page.dart   # Advanced analytics
│   ├── services/                # Business logic
│   │   ├── api_service.dart      # Backend API communication
│   │   ├── local_db_service.dart  # Local database operations
│   │   ├── notification_service.dart # Push notifications
│   │   ├── export_service.dart   # Data export functionality
│   │   ├── sync_service.dart     # Data synchronization
│   │   ├── utility_service.dart  # Helper functions
│   │   └── theme_service.dart   # Theme management
│   └── models/                  # Data models
├── backend/                     # Flask backend
│   ├── app.py                   # Flask application
│   ├── requirements.txt         # Python dependencies
│   └── instance/                # Database files
├── assets/                      # Static assets
├── docs/                        # Documentation
├── test/                        # Unit and widget tests
├── android/                     # Android-specific files
├── ios/                         # iOS-specific files
├── web/                         # Web-specific files
├── linux/                       # Linux-specific files
├── macos/                       # macOS-specific files
├── windows/                     # Windows-specific files
├── README.md                    # Project overview
├── CHANGELOG.md                 # Version history
├── LICENSE                      # MIT License
└── pubspec.yaml                 # Flutter dependencies
```

## Core Components

### 1. Authentication System
#### Employee Login
- Validates employee ID and password against backend
- Creates session for authenticated users
- Handles error cases (invalid credentials, network issues)

#### Mobile OTP Login
- Sends OTP to registered mobile number
- Verifies OTP for authentication
- Implements cooldown period to prevent spam

### 2. Patient Record Management
#### Record Creation
- Collects CRN, UHID, patient name, and date of birth
- Validates required fields
- Stores record in local database with sync flag

#### File Attachment
- Allows multiple file selection with size/type restrictions
- Compresses files for efficient storage
- Associates files with patient records

### 3. Search Functionality
#### Query Processing
- Searches across CRN, UHID, and patient name fields
- Implements fuzzy matching for improved results
- Displays paginated results with sorting options

#### Result Display
- Shows key patient information in list format
- Indicates sync status with visual cues
- Provides quick access to record details

### 4. Data Synchronization
#### Background Sync
- Periodically checks for unsynced records
- Transmits data to backend when connectivity is available
- Updates local sync status upon successful transmission

#### Conflict Resolution
- Handles duplicate record detection
- Implements last-write-wins strategy for conflicts
- Logs sync errors for troubleshooting

### 5. Export Services
#### CSV Export
- Generates structured CSV files with patient data
- Includes file metadata and timestamps
- Saves to device storage with user-friendly naming

#### PDF Export
- Creates professional reports with formatting
- Includes charts and visualizations
- Supports multipage documents with pagination

#### JSON Export
- Exports raw data in machine-readable format
- Preserves relationships between entities
- Compatible with external systems and APIs

## Database Design

### Patients Table
```sql
CREATE TABLE patients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    crn TEXT UNIQUE NOT NULL,
    uhid TEXT NOT NULL,
    patient_name TEXT NOT NULL,
    dob TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    synced INTEGER DEFAULT 0
);
```

### Files Table
```sql
CREATE TABLE files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    filename TEXT NOT NULL,
    file_data BLOB,
    file_size INTEGER,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    synced INTEGER DEFAULT 0,
    FOREIGN KEY (patient_id) REFERENCES patients (id)
);
```

### Users Table (Backend)
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### OTP Codes Table (Backend)
```sql
CREATE TABLE otp_codes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mobile TEXT UNIQUE NOT NULL,
    otp TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL
);
```

## API Documentation

### Authentication Endpoints
#### POST /login/employee
- **Description**: Authenticate with employee credentials
- **Request Body**: `{ "employee_id": "string", "password": "string" }`
- **Response**: `{ "success": boolean, "user": { "id": int, "employee_id": "string", "name": "string" } }`

#### POST /login/send-otp
- **Description**: Send OTP to mobile number
- **Request Body**: `{ "mobile": "string" }`
- **Response**: `{ "success": boolean, "otp": "string" }`

#### POST /login/verify-otp
- **Description**: Verify OTP for authentication
- **Request Body**: `{ "mobile": "string", "otp": "string" }`
- **Response**: `{ "success": boolean, "message": "string" }`

### Patient Endpoints
#### POST /patients
- **Description**: Create new patient record with files
- **Request Body**: Multipart form with patient data and file attachments
- **Response**: `{ "success": boolean, "message": "string", "patient_id": int }`

#### GET /patients/search
- **Description**: Search for patient records
- **Query Parameters**: `search_type` (crn|uhid|patient_name), `search_term` (string)
- **Response**: Array of patient objects with file metadata

#### GET /patients/{id}
- **Description**: Get detailed patient information
- **Path Parameter**: `id` (integer)
- **Response**: Complete patient object with all associated files

### File Endpoints
#### GET /files/{id}
- **Description**: Download specific file
- **Path Parameter**: `id` (integer)
- **Response**: File content with appropriate MIME type

### Configuration Endpoints
#### GET /config
- **Description**: Get server configuration
- **Response**: `{ "max_file_size": int, "allowed_extensions": array }`

#### GET /sync
- **Description**: Synchronize data with server
- **Response**: `{ "success": boolean, "message": "string", "synced_records": int }`

## Security Implementation

### Authentication Security
- **Password Hashing**: SHA-256 hashing with salt for credential storage
- **Session Management**: Token-based sessions with expiration
- **Rate Limiting**: Prevent brute-force attacks on login endpoints
- **Input Validation**: Sanitize all user inputs to prevent injection attacks

### Data Protection
- **Encryption**: AES encryption for sensitive patient data at rest
- **Transport Security**: HTTPS for all network communications
- **Access Control**: Role-based permissions for different user types
- **Audit Trail**: Comprehensive logging of all user activities

### Privacy Compliance
- **Data Minimization**: Collect only necessary patient information
- **Retention Policies**: Automated cleanup of old records based on regulations
- **Consent Management**: Track and manage patient consent for data processing
- **Right to Erasure**: Implement procedures for data deletion requests

## Testing Strategy

### Unit Testing
- **Service Layer**: Test all business logic with mock data
- **Database Operations**: Verify CRUD operations and edge cases
- **API Integration**: Validate request/response handling
- **Utility Functions**: Test helper methods with various inputs

### Widget Testing
- **UI Components**: Verify rendering and interaction behavior
- **Form Validation**: Test input validation and error messaging
- **Navigation**: Confirm routing between different screens
- **State Management**: Validate state changes and updates

### Integration Testing
- **End-to-End Flows**: Test complete user journeys from login to data export
- **Database Sync**: Verify synchronization between local and remote databases
- **File Operations**: Test file upload, download, and storage functionality
- **Network Resilience**: Simulate network failures and recovery scenarios

### Performance Testing
- **Load Testing**: Measure response times under various loads
- **Memory Usage**: Monitor application memory consumption
- **Battery Impact**: Assess power consumption during extended use
- **Startup Time**: Optimize application launch performance

## Deployment Guide

### Mobile App Deployment
#### Android
1. Generate signing key: `keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
2. Create `key.properties` file with keystore information
3. Configure `android/app/build.gradle` with signing configuration
4. Build release APK: `flutter build apk --release`
5. Upload to Google Play Console

#### iOS
1. Register app ID in Apple Developer Portal
2. Create distribution certificate and provisioning profile
3. Configure Xcode project with signing information
4. Archive and upload through Xcode Organizer
5. Submit to App Store Connect for review

### Backend Deployment
#### Server Setup
1. Provision cloud server (AWS EC2, GCP Compute Engine, etc.)
2. Install Python 3.8+ and required dependencies
3. Configure firewall rules for HTTP/HTTPS access
4. Set up reverse proxy with Nginx or Apache
5. Configure SSL certificate with Let's Encrypt

#### Database Configuration
1. Initialize SQLite database with schema
2. Set up automated backups with cron jobs
3. Configure read replicas for high availability
4. Implement monitoring and alerting for database health
5. Plan for capacity scaling as data volume grows

### Continuous Integration/Deployment
#### CI Pipeline
1. Set up automated testing on code commits
2. Implement code quality checks and linting
3. Generate build artifacts for different platforms
4. Run security scans on dependencies
5. Automate deployment to staging environments

#### CD Pipeline
1. Implement blue-green deployment strategy
2. Set up rollback mechanisms for failed deployments
3. Configure feature flags for gradual rollouts
4. Monitor application performance post-deployment
5. Automate notifications for deployment status

## Troubleshooting

### Common Issues

#### Database Connection Errors
- **Symptom**: Application fails to start or crashes randomly
- **Solution**: Check database file permissions and available storage space
- **Prevention**: Implement proper database connection pooling and error handling

#### Network Timeout Issues
- **Symptom**: Slow API responses or failed requests
- **Solution**: Increase timeout values and implement retry logic
- **Prevention**: Add network connectivity checks before making requests

#### File Upload Failures
- **Symptom**: Files fail to upload or become corrupted
- **Solution**: Verify file size limits and compression settings
- **Prevention**: Implement chunked uploading for large files

#### Authentication Problems
- **Symptom**: Users unable to login or experiencing frequent logouts
- **Solution**: Check session timeout settings and token validity
- **Prevention**: Implement refresh token mechanism for persistent sessions

### Debugging Tips

#### Mobile App Debugging
1. Use Flutter DevTools for performance profiling
2. Enable verbose logging during development
3. Test on multiple device sizes and orientations
4. Use platform-specific debugging tools (Android Studio, Xcode)
5. Monitor memory usage and identify leaks

#### Backend Debugging
1. Enable detailed logging for API endpoints
2. Use database query profiling tools
3. Monitor server resource utilization
4. Implement distributed tracing for complex requests
5. Set up alerts for error rate spikes

### Performance Optimization

#### Mobile App Optimization
- **Image Loading**: Implement lazy loading and caching for patient photos
- **List Rendering**: Use ListView.builder for efficient scrolling
- **Memory Management**: Dispose of resources properly in widget lifecycle
- **Network Calls**: Batch requests and implement request caching
- **Database Queries**: Add indexes for frequently queried columns

#### Backend Optimization
- **Database Indexing**: Create indexes on commonly searched fields
- **Query Optimization**: Analyze slow queries and optimize execution plans
- **Caching Strategy**: Implement Redis or Memcached for frequently accessed data
- **Load Balancing**: Distribute traffic across multiple server instances
- **CDN Integration**: Serve static assets through content delivery networks

### Migration Procedures

#### Database Schema Updates
1. Create migration scripts for schema changes
2. Test migrations on staging environment first
3. Implement backward compatibility for older app versions
4. Schedule maintenance windows for production updates
5. Maintain rollback procedures for failed migrations

#### API Versioning
1. Use semantic versioning for API endpoints
2. Maintain backward compatibility for existing clients
3. Deprecate old endpoints with advance notice
4. Document breaking changes in release notes
5. Monitor usage of deprecated endpoints for safe removal

---

*This documentation is maintained by the development team and updated with each major release. For questions or clarifications, please contact the project maintainers.*