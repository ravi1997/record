# API Documentation

This document provides comprehensive documentation for the Medical Record System API. The API enables programmatic access to all system functionality, allowing integration with other healthcare systems and custom applications.

## Overview

The Medical Record System API is a RESTful interface that follows standard HTTP conventions. It provides endpoints for managing patient records, files, authentication, and system configuration.

### Base URL

All API requests should be made to the base URL:

```
https://api.medicalrecordsystem.com/v1
```

For local development, use:

```
http://localhost:5000
```

### Authentication

All API requests require authentication. The system supports multiple authentication methods:

1. **Session Authentication**: Cookie-based authentication after login
2. **Token Authentication**: Bearer token in Authorization header
3. **API Keys**: For server-to-server integrations

### Rate Limiting

To ensure fair usage and system stability, the API implements rate limiting:

- **Anonymous Requests**: 100 requests per hour
- **Authenticated Requests**: 1000 requests per hour
- **Admin Requests**: 5000 requests per hour

Exceeding these limits will result in a `429 Too Many Requests` response.

### Response Format

All API responses are returned in JSON format with the following structure:

```json
{
  "success": true,
  "data": {},
  "message": "Optional success message"
}
```

Or in case of errors:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message"
  }
}
```

## Authentication Endpoints

### Employee Login

Authenticate using employee credentials.

```
POST /login/employee
```

#### Request Body

```json
{
  "employee_id": "string",
  "password": "string"
}
```

#### Response

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 123,
      "employee_id": "EMP001",
      "name": "John Smith"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

#### Status Codes

- `200 OK`: Successful authentication
- `401 Unauthorized`: Invalid credentials
- `429 Too Many Requests`: Rate limit exceeded

### Mobile OTP Login

Authenticate using mobile number and OTP.

```
POST /login/mobile
```

#### Request Body

```json
{
  "mobile": "string",
  "otp": "string"
}
```

#### Response

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 123,
      "mobile": "+1234567890",
      "name": "John Smith"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

#### Status Codes

- `200 OK`: Successful authentication
- `400 Bad Request`: Invalid request data
- `401 Unauthorized`: Invalid OTP
- `429 Too Many Requests`: Rate limit exceeded

### Send OTP

Send OTP to a mobile number.

```
POST /login/send-otp
```

#### Request Body

```json
{
  "mobile": "string"
}
```

#### Response

```json
{
  "success": true,
  "data": {
    "message": "OTP sent successfully"
  }
}
```

#### Status Codes

- `200 OK`: OTP sent successfully
- `400 Bad Request`: Invalid mobile number
- `429 Too Many Requests`: Rate limit exceeded

## Patient Endpoints

### Create Patient Record

Create a new patient record with associated files.

```
POST /patients
```

#### Request Headers

```
Authorization: Bearer <token>
Content-Type: multipart/form-data
```

#### Form Data

- `crn` (required): Case Record Number
- `uhid` (required): Unique Health Identifier
- `patient_name` (required): Patient's full name
- `dob` (required): Date of Birth (YYYY-MM-DD)
- `files` (optional): Attached files (multiple allowed)

#### Response

```json
{
  "success": true,
  "data": {
    "patient_id": 123,
    "message": "Patient record created successfully"
  }
}
```

#### Status Codes

- `201 Created`: Patient record created successfully
- `400 Bad Request`: Invalid request data
- `401 Unauthorized`: Missing or invalid authentication
- `413 Payload Too Large`: File size exceeds limit
- `500 Internal Server Error`: Server-side error

### Search Patient Records

Search for patient records by various criteria.

```
GET /patients/search
```

#### Query Parameters

- `search_type` (required): Search field (`crn`, `uhid`, `patient_name`)
- `search_term` (required): Search query string

#### Request Headers

```
Authorization: Bearer <token>
```

#### Response

```json
{
  "success": true,
  "data": [
    {
      "id": 123,
      "crn": "PAT123456",
      "uhid": "UHID789012",
      "patient_name": "John Smith",
      "dob": "1985-06-15",
      "created_at": "2023-01-15T10:30:00Z",
      "files": [
        {
          "id": 456,
          "filename": "lab_results.pdf",
          "file_size": 1024000,
          "upload_date": "2023-01-15T10:35:00Z"
        }
      ]
    }
  ]
}
```

#### Status Codes

- `200 OK`: Search results returned
- `400 Bad Request`: Invalid search parameters
- `401 Unauthorized`: Missing or invalid authentication

### Get Patient Details

Retrieve detailed information about a specific patient.

```
GET /patients/{id}
```

#### Path Parameters

- `id` (required): Patient record ID

#### Request Headers

```
Authorization: Bearer <token>
```

#### Response

```json
{
  "success": true,
  "data": {
    "id": 123,
    "crn": "PAT123456",
    "uhid": "UHID789012",
    "patient_name": "John Smith",
    "dob": "1985-06-15",
    "created_at": "2023-01-15T10:30:00Z",
    "files": [
      {
        "id": 456,
        "filename": "lab_results.pdf",
        "file_size": 1024000,
        "upload_date": "2023-01-15T10:35:00Z"
      }
    ]
  }
}
```

#### Status Codes

- `200 OK`: Patient details returned
- `401 Unauthorized`: Missing or invalid authentication
- `404 Not Found`: Patient record not found

## File Endpoints

### Download File

Download a specific file by ID.

```
GET /files/{id}
```

#### Path Parameters

- `id` (required): File ID

#### Request Headers

```
Authorization: Bearer <token>
```

#### Response

Returns the file content with appropriate Content-Type header.

#### Status Codes

- `200 OK`: File downloaded successfully
- `401 Unauthorized`: Missing or invalid authentication
- `404 Not Found`: File not found

## System Endpoints

### Get Configuration

Retrieve system configuration information.

```
GET /config
```

#### Request Headers

```
Authorization: Bearer <token>
```

#### Response

```json
{
  "success": true,
  "data": {
    "max_file_size": 5242880,
    "allowed_extensions": ["pdf", "doc", "docx", "txt", "jpg", "jpeg", "png"],
    "version": "1.0.0"
  }
}
```

#### Status Codes

- `200 OK`: Configuration returned
- `401 Unauthorized`: Missing or invalid authentication

### Health Check

Check the health status of the API.

```
GET /health
```

#### Response

```json
{
  "success": true,
  "data": {
    "status": "healthy",
    "timestamp": "2023-01-15T10:30:00Z",
    "uptime": "120h30m45s"
  }
}
```

#### Status Codes

- `200 OK`: System is healthy
- `503 Service Unavailable`: System is unhealthy

## Data Models

### Patient Model

```json
{
  "id": 123,
  "crn": "PAT123456",
  "uhid": "UHID789012",
  "patient_name": "John Smith",
  "dob": "1985-06-15",
  "created_at": "2023-01-15T10:30:00Z"
}
```

### File Model

```json
{
  "id": 456,
  "patient_id": 123,
  "filename": "lab_results.pdf",
  "file_size": 1024000,
  "upload_date": "2023-01-15T10:35:00Z"
}
```

### User Model

```json
{
  "id": 789,
  "employee_id": "EMP001",
  "name": "John Smith",
  "created_at": "2023-01-15T10:30:00Z"
}
```

## Error Codes

The API uses standard HTTP status codes along with custom error codes for more specific error handling:

| Error Code | HTTP Status | Description |
|------------|-------------|-------------|
| AUTH_FAILED | 401 | Authentication failed |
| INVALID_CREDENTIALS | 401 | Invalid username or password |
| ACCESS_DENIED | 403 | Insufficient permissions |
| RESOURCE_NOT_FOUND | 404 | Requested resource not found |
| VALIDATION_ERROR | 400 | Request data validation failed |
| RATE_LIMIT_EXCEEDED | 429 | Too many requests |
| INTERNAL_ERROR | 500 | Unexpected server error |
| SERVICE_UNAVAILABLE | 503 | Service temporarily unavailable |

## SDKs and Libraries

Official SDKs are available for popular programming languages:

### Python

```python
from medical_record_system import Client

client = Client(api_key='your-api-key')
patients = client.search_patients('patient_name', 'John Smith')
```

### JavaScript

```javascript
import { MedicalRecordClient } from '@medical-record-system/client';

const client = new MedicalRecordClient({ apiKey: 'your-api-key' });
const patients = await client.searchPatients('patient_name', 'John Smith');
```

### Java

```java
import com.medicalrecordsystem.Client;

Client client = new Client("your-api-key");
List<Patient> patients = client.searchPatients("patient_name", "John Smith");
```

## Best Practices

### Security Recommendations

1. Always use HTTPS in production
2. Store API keys securely and never expose them in client-side code
3. Implement proper error handling to avoid exposing sensitive information
4. Regularly rotate API keys
5. Use the principle of least privilege when assigning permissions

### Performance Optimization

1. Implement caching for frequently accessed data
2. Use pagination for large result sets
3. Batch multiple operations when possible
4. Monitor API usage and adjust rate limits accordingly
5. Compress large payloads when transmitting

### Error Handling

1. Always check HTTP status codes
2. Implement exponential backoff for rate-limited requests
3. Log errors with sufficient context for debugging
4. Provide user-friendly error messages in your applications
5. Handle network timeouts gracefully

## Versioning

The API uses semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Incompatible API changes
- **MINOR**: Backward-compatible functionality additions
- **PATCH**: Backward-compatible bug fixes

Version numbers are included in the base URL:
```
https://api.medicalrecordsystem.com/v1/
```

## Support

For API-related questions and support:

1. Check the [API Reference](https://medicalrecordsystem.com/api/reference)
2. Join our [Developer Community](https://medicalrecordsystem.com/community)
3. Contact our [Support Team](https://medicalrecordsystem.com/support)

For enterprise customers:
1. Dedicated API support via SLA
2. Custom integration assistance
3. Priority access to new features
4. 24/7 technical support

## Changelog

### v1.0.0 (2025-10-14)
- Initial release
- Full CRUD operations for patient records
- File attachment and management
- Authentication and authorization
- Search and filtering capabilities
- System health monitoring

---

*This API documentation is automatically generated and updated with each release. For the most current information, visit [https://medicalrecordsystem.com/api](https://medicalrecordsystem.com/api).*