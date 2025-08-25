# Test System API Documentation

## Overview

The Test System API is a MuleSoft-based System API designed for direct KYC (Know Your Customer) data access and basic validation. This API serves as a foundational layer in a MuleSoft architecture, providing secure and reliable access to customer verification data.

**Version:** v1  
**Base URI:** `/test-system-api`  
**Runtime:** MuleSoft 4.4.0  
**Port:** 8082 (default configuration)

## Table of Contents

1. [Authentication & Headers](#authentication--headers)
2. [Endpoints](#endpoints)
3. [Data Types](#data-types)
4. [Error Handling](#error-handling)
5. [Implementation Details](#implementation-details)
6. [Examples](#examples)
7. [Testing](#testing)

## Authentication & Headers

### Optional Headers

| Header | Type | Required | Description |
|--------|------|----------|-------------|
| `X-System-ID` | string | No | System identifier for data access tracking and monitoring |
| `Content-Type` | string | Yes | Must be `application/json` for POST requests |
| `Accept` | string | Yes | Must be `application/json` |

### Security Notes

- No authentication is currently required for this System API
- The `X-System-ID` header is optional but recommended for tracking and monitoring purposes
- All requests and responses use JSON format

## Endpoints

### POST /kyc

**Display Name:** System KYC Data Access  
**Description:** System API for direct KYC data access and basic validation

#### Request

**Method:** `POST`  
**Path:** `/test-system-api/kyc`  
**Content-Type:** `application/json`

#### Request Schema

```json
{
  "type": "object",
  "properties": {
    "account": {
      "type": "string",
      "required": true,
      "description": "Account number"
    },
    "First Name": {
      "type": "string",
      "required": true,
      "description": "Customer first name"
    },
    "Last Name": {
      "type": "string",
      "required": true,
      "description": "Customer last name"
    },
    "amount": {
      "type": "number",
      "format": "double",
      "required": true,
      "description": "Transaction amount"
    },
    "currency": {
      "type": "string",
      "required": true,
      "description": "Currency code"
    },
    "Birthday": {
      "type": "string",
      "required": true,
      "description": "Date of birth in MM-DD-YYYY format"
    }
  }
}
```

#### Response Schema

**Success Response (200):**

```json
{
  "type": "object",
  "properties": {
    "response code": {
      "type": "integer",
      "description": "HTTP response code"
    },
    "response message": {
      "type": "string",
      "description": "Response message"
    }
  }
}
```

## Data Types

### KycRequest

| Field | Type | Required | Format | Description | Example |
|-------|------|----------|--------|-------------|---------|
| `account` | string | Yes | - | Account number | "019231203" |
| `First Name` | string | Yes | - | Customer first name | "Katie" |
| `Last Name` | string | Yes | - | Customer last name | "Hunter" |
| `amount` | number | Yes | double | Transaction amount | 100.00 |
| `currency` | string | Yes | - | Currency code | "PHP" |
| `Birthday` | string | Yes | MM-DD-YYYY | Date of birth | "10-30-1992" |

### KycResponse

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `response code` | integer | HTTP response code | 200 |
| `response message` | string | Response message | "Successful kyc" |

## Error Handling

The API implements comprehensive error handling for various scenarios:

### Standard HTTP Error Responses

| Status Code | Description | Response Body |
|-------------|-------------|---------------|
| 200 | Success | KycResponse object |
| 400 | Bad Request | `{"message": "Bad request"}` |
| 404 | Not Found | `{"message": "Resource not found"}` |
| 405 | Method Not Allowed | `{"message": "Method not allowed"}` |
| 406 | Not Acceptable | `{"message": "Not acceptable"}` |
| 415 | Unsupported Media Type | `{"message": "Unsupported media type"}` |
| 500 | Internal Server Error | `{"message": "Internal server error"}` |
| 501 | Not Implemented | `{"message": "Not Implemented"}` |

### Error Response Format

All error responses follow a consistent JSON format:

```json
{
  "message": "Error description"
}
```

## Implementation Details

### Flow Architecture

The Test System API is implemented using MuleSoft's APIKit framework with the following flow structure:

#### 1. Main API Flow (`test-system-api-main`)
- **Purpose:** Entry point for all API requests
- **Configuration:** HTTP Listener on port 8082
- **Path:** `/test-system-api/*`
- **Features:** 
  - APIKit router for request routing
  - Comprehensive error handling for all APIKit error types
  - Automatic JSON response formatting

#### 2. KYC Endpoint Flow (`post:\kyc:test-system-api-config`)
- **Purpose:** Handles POST requests to the /kyc endpoint
- **Implementation:** Delegates to the `system-kyc-subflow`

#### 3. System KYC Subflow (`system-kyc-subflow`)
- **Purpose:** Core business logic for KYC processing
- **Features:**
  - Request logging with account number
  - Response transformation to standard format
  - Success logging
- **Processing:** Currently returns a successful response for all valid requests

### Logging

The API includes comprehensive logging at key points:

- **Request Logging:** Logs incoming KYC requests with account number
- **Response Logging:** Logs successful completion of KYC processing
- **Error Logging:** Automatic error logging through MuleSoft error handlers

### Configuration

- **HTTP Listener:** Configured on host `0.0.0.0`, port `8082`
- **RAML Specification:** Located at `api/test-system-api.raml`
- **Data Types:** Defined in `libraries/data-types.raml`
- **Traits:** Defined in `libraries/traits.raml`

## Examples

### Example 1: Valid KYC Request

**Request:**
```bash
POST /test-system-api/kyc
Content-Type: application/json
X-System-ID: SYSTEM001

{
  "account": "019231203",
  "First Name": "Katie",
  "Last Name": "Hunter",
  "amount": 100.00,
  "currency": "PHP",
  "Birthday": "10-30-1992"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "response code": 200,
  "response message": "Successful kyc"
}
```

### Example 2: Alternative Valid Request

**Request:**
```bash
POST /test-system-api/kyc
Content-Type: application/json

{
  "account": "987654321",
  "First Name": "John",
  "Last Name": "Doe",
  "amount": 250.50,
  "currency": "USD",
  "Birthday": "05-15-1985"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "response code": 200,
  "response message": "Successful kyc"
}
```

### Example 3: Invalid Request (Missing Required Field)

**Request:**
```bash
POST /test-system-api/kyc
Content-Type: application/json

{
  "account": "019231203",
  "First Name": "Katie"
}
```

**Response:**
```json
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "message": "Bad request"
}
```

### Example 4: Invalid Method

**Request:**
```bash
GET /test-system-api/kyc
```

**Response:**
```json
HTTP/1.1 405 Method Not Allowed
Content-Type: application/json

{
  "message": "Method not allowed"
}
```

## Testing

### MUnit Test Coverage

The API includes comprehensive MUnit tests covering various scenarios:

#### Test 1: Valid KYC Request
- **Test Name:** `test-valid-kyc-request`
- **Description:** Test successful KYC processing in System API
- **Validation:** 
  - Response code equals 200
  - Response message equals "Successful kyc"

#### Test 2: Different Account Number
- **Test Name:** `test-kyc-request-with-different-account`
- **Description:** Test KYC processing with different account number
- **Validation:**
  - Response code equals 200
  - Response message equals "Successful kyc"

### Running Tests

To run the MUnit tests:

```bash
mvn clean test
```

### Test Data

The tests use the following sample data:

**Test Case 1:**
```json
{
  "account": "019231203",
  "First Name": "Katie",
  "Last Name": "Hunter",
  "amount": 100.00,
  "currency": "PHP",
  "Birthday": "10-30-1992"
}
```

**Test Case 2:**
```json
{
  "account": "987654321",
  "First Name": "John",
  "Last Name": "Doe",
  "amount": 250.50,
  "currency": "USD",
  "Birthday": "05-15-1985"
}
```

## Development Information

### Project Structure

```
test-system-api/
├── src/
│   ├── main/
│   │   ├── mule/
│   │   │   ├── test-system-api.xml      # Main API flows
│   │   │   └── system-kyc.xml           # KYC subflow
│   │   └── resources/
│   │       ├── api/
│   │       │   ├── test-system-api.raml # Main API specification
│   │       │   └── libraries/
│   │       │       ├── data-types.raml  # Data type definitions
│   │       │       └── traits.raml      # API traits
│   │       └── log4j2.xml               # Logging configuration
│   └── test/
│       └── munit/
│           └── system-kyc-test.xml      # MUnit tests
├── pom.xml                              # Maven configuration
└── mule-artifact.json                   # Mule artifact descriptor
```

### Dependencies

- **MuleSoft Runtime:** 4.4.0
- **HTTP Connector:** 1.7.1
- **APIKit Module:** 1.8.1
- **MUnit:** 2.3.13

### Build Information

- **Group ID:** com.mycompany
- **Artifact ID:** test-system-api
- **Version:** 1.0.0-SNAPSHOT
- **Packaging:** mule-application

## API Design Patterns

This System API follows MuleSoft's recommended patterns:

1. **System API Layer:** Provides direct access to system data with minimal transformation
2. **RAML-First Design:** API specification defined before implementation
3. **Consistent Error Handling:** Standardized error responses across all endpoints
4. **Comprehensive Logging:** Request and response logging for monitoring and debugging
5. **Modular Design:** Separation of concerns with subflows for business logic

## Monitoring and Observability

### Logging Levels

- **INFO:** Request processing and successful responses
- **ERROR:** Automatic error logging through MuleSoft error handlers

### Tracking

- Use the optional `X-System-ID` header for request tracking
- Account numbers are logged for audit purposes
- Response times and status codes are automatically tracked by MuleSoft runtime

---

**Last Updated:** August 2024  
**API Version:** v1  
**Documentation Version:** 1.0
