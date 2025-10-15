# Medical Record System - Backend

This is the Flask backend for the Medical Record System mobile application.

## Features

- User authentication (employee login and mobile OTP)
- Patient data management (CRN, UHID, Name, DOB)
- File upload support (max 5 files, max 5MB each)
- Search functionality
- Local database synchronization

## Setup

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

2. Run the Flask server:
```bash
python app.py
```

The server will start on `http://localhost:5000`

## API Endpoints

### Authentication

- `POST /login/employee` - Login with employee credentials
- `POST /login/send-otp` - Send OTP to mobile number
- `POST /login/verify-otp` - Verify OTP

### Patient Management

- `POST /patients` - Create a new patient record with files
- `GET /patients/search?search_type=type&search_term=term` - Search for patients
- `GET /patients/{patient_id}` - Get patient details by ID
- `GET /files/{file_id}` - Download a file by ID
- `POST /sync` - Sync local data with server

## Database

The backend uses SQLite for local data storage. The database schema includes:
- `patients` table for patient information
- `files` table for file metadata
- `users` table for employee authentication
- `otp_codes` table for OTP verification