# Quick Start Guide

This guide will help you get up and running with the Medical Record System in just a few minutes. By the end of this guide, you'll have created your first patient record and explored the key features of the application.

## Prerequisites

Before starting this guide, ensure you have:

1. Completed the [Installation Guide](installation.md)
2. The backend server running on `http://localhost:5000`
3. The mobile app installed and running

## Step 1: Launch the Application

1. Open the Medical Record System app on your device
2. You should see the login screen:

![Login Screen](../images/login-screen.png)

## Step 2: Log In

For this quick start, we'll use the test credentials:

1. Select "Employee" login option
2. Enter the following credentials:
   - **Employee ID**: EMP001
   - **Password**: password123
3. Tap the "Login" button

You should now be taken to the home screen.

## Step 3: Explore the Home Screen

The home screen provides an overview of your system:

1. **Statistics Cards**:
   - Today's Entries
   - Total Records
   - Synced Records
   - Pending Records

2. **Quick Actions**:
   - Add Patient Record
   - Search Records
   - My Profile
   - Settings
   - Advanced Dashboard

Take a moment to familiarize yourself with these elements.

## Step 4: Create Your First Patient Record

1. Tap on "Add Patient Record" in the Quick Actions section
2. You'll see the patient entry form:

![Patient Entry Form](../images/patient-entry-form.png)

3. Fill in the following information:
   - **CRN Number**: PAT123456
   - **UHID**: UHID789012
   - **Patient Name**: John Smith
   - **Date of Birth**: 1985-06-15

4. Tap on "Select File" to attach a document:
   - For this demo, you can select any document from your device
   - Multiple files can be attached to a single record

5. Tap the "Save Patient Record" button

You should see a success message indicating that the patient record was saved locally.

## Step 5: Search for Patient Records

1. From the home screen, tap on "Search Records"
2. You'll see the search interface:

![Search Interface](../images/search-interface.png)

3. Try searching for "John Smith" in the search box
4. You should see your newly created patient record in the results
5. Tap on the record to view its details

## Step 6: View Patient Details

The patient details screen shows:

1. **Patient Information**:
   - Name, CRN, UHID, and Date of Birth
   - Sync status indicator

2. **Attached Files**:
   - List of all files associated with the patient
   - File size information
   - Ability to view/download files

3. Try tapping on a file to view it in your device's default viewer

## Step 7: Explore Additional Features

### Profile Management

1. From the home screen, tap on "My Profile"
2. View and edit your profile information
3. Change your password
4. Adjust notification preferences

### Settings

1. From the home screen, tap on "Settings"
2. Explore the various configuration options:
   - Appearance settings
   - Notification preferences
   - Security options
   - Data synchronization settings

### Advanced Dashboard

1. From the home screen, tap on "Advanced Dashboard"
2. View detailed analytics and metrics:
   - Record trends over time
   - System performance indicators
   - Storage usage statistics

## Step 8: Synchronize Data

1. From the search screen or dashboard, look for the "Sync" button
2. Tap "Sync with Server" to synchronize your local records with the backend
3. You should see a notification when the sync completes successfully

## Next Steps

Congratulations! You've successfully:

- Logged into the system
- Created a patient record with attached files
- Searched for and viewed patient details
- Explored the main features of the application

To continue learning about the Medical Record System:

1. Read the [User Guide](../user-guide/index.md) for comprehensive documentation of all features
2. Explore the [Administrator Guide](../admin-guide/index.md) for system administration topics
3. Check out the [API Documentation](../api/index.md) if you're interested in integrations
4. Review the [Security Guide](../security/index.md) for information about data protection

## Troubleshooting

If you encountered any issues during this quick start:

1. Verify that the backend server is running
2. Check your network connection
3. Ensure you're using the correct test credentials
4. Consult the [Installation Guide](installation.md) for detailed setup instructions

## Getting Help

For additional assistance:

1. Visit our [Support Page](https://medicalrecordsystem.com/support)
2. Check the [FAQ](../troubleshooting/faq.md)
3. Join our community forums
4. Contact our support team

We hope you enjoy using the Medical Record System!