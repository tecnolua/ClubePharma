# ClubePharma Authentication System - Setup Guide

## Overview

This document describes the complete authentication system implemented for the ClubePharma backend API.

## Files Created

### 1. `src/server.js` - Main Express Server
**Location:** `c:\Users\Luana\Documents\Work\ClubePharma\clube_pharma_backend\src\server.js`

**Features:**
- Express app initialization
- CORS configuration (configurable via `FRONTEND_URL` env variable)
- JSON body parser
- Health check endpoint at `/health`
- Route imports and setup
- Global error handling middleware
- Graceful shutdown handlers
- Server startup on PORT from .env

---

### 2. `src/config/database.js` - Prisma Client Singleton
**Location:** `c:\Users\Luana\Documents\Work\ClubePharma\clube_pharma_backend\src\config\database.js`

**Features:**
- Singleton pattern for Prisma client
- Prevents connection pool exhaustion
- Different configurations for development vs production
- Query logging in development mode
- Graceful disconnection on shutdown

---

### 3. `src/utils/jwt.js` - JWT Utility Functions
**Location:** `c:\Users\Luana\Documents\Work\ClubePharma\clube_pharma_backend\src\utils\jwt.js`

**Functions:**
- `generateToken(userId)` - Creates JWT token for authentication (7 days expiry)
- `verifyToken(token)` - Verifies and decodes JWT token
- `generateResetToken(userId)` - Creates password reset token (1 hour expiry)
- `verifyResetToken(token)` - Verifies password reset token

**Environment Variables Required:**
- `JWT_SECRET` - Secret key for signing tokens
- `JWT_EXPIRES_IN` - Token expiration time (default: 7d)

---

### 4. `src/middlewares/auth.js` - Authentication Middleware
**Location:** `c:\Users\Luana\Documents\Work\ClubePharma\clube_pharma_backend\src\middlewares\auth.js`

**Middleware:**
- `authMiddleware` - Requires authentication, attaches user to `req.user`
- `optionalAuthMiddleware` - Optional authentication (for public endpoints with auth benefits)

**Features:**
- Extracts token from `Authorization: Bearer <token>` header
- Verifies token validity
- Fetches user from database
- Attaches user object to request (excluding password)
- Returns 401 for invalid/missing tokens

---

### 5. `src/controllers/authController.js` - Authentication Controller
**Location:** `c:\Users\Luana\Documents\Work\ClubePharma\clube_pharma_backend\src\controllers\authController.js`

**Functions:**

#### `register(req, res)`
- Creates new user account
- Hashes password with bcrypt (10 salt rounds)
- Validates unique email and CPF
- Returns user object and JWT token
- **Validations:** email, password (min 6 chars, uppercase, lowercase, number), name, CPF, phone, planType

#### `login(req, res)`
- Authenticates user credentials
- Compares password hash
- Returns user object and JWT token
- **Validations:** email, password

#### `me(req, res)`
- Returns current authenticated user information
- Requires authentication middleware
- Fetches fresh data from database

#### `forgotPassword(req, res)`
- Generates password reset token
- Saves token to database with 1-hour expiry
- In production: sends email with reset link
- In development: returns token in response
- **Validations:** email

#### `resetPassword(req, res)`
- Verifies reset token
- Updates user password
- Clears reset token from database
- **Validations:** token, newPassword (min 6 chars, uppercase, lowercase, number)

---

### 6. `src/routes/authRoutes.js` - Authentication Routes
**Location:** `c:\Users\Luana\Documents\Work\ClubePharma\clube_pharma_backend\src\routes\authRoutes.js`

**Routes:**

| Method | Endpoint | Access | Description |
|--------|----------|--------|-------------|
| POST | `/api/auth/register` | Public | Register new user |
| POST | `/api/auth/login` | Public | Login user |
| GET | `/api/auth/me` | Private | Get current user |
| POST | `/api/auth/forgot-password` | Public | Request password reset |
| POST | `/api/auth/reset-password` | Public | Reset password with token |

---

## Setup Instructions

### 1. Install Dependencies
```bash
cd c:\Users\Luana\Documents\Work\ClubePharma\clube_pharma_backend
npm install
```

### 2. Configure Environment Variables
Ensure your `.env` file has the following variables:
```env
# Database
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/clubepharma?schema=public"

# Server
PORT=3000
NODE_ENV=development

# JWT
JWT_SECRET=clube_pharma_super_secret_key_2024_change_this_in_production
JWT_EXPIRES_IN=7d

# Frontend URL (for CORS)
FRONTEND_URL=http://localhost:3001
```

### 3. Setup Database
```bash
# Generate Prisma client
npx prisma generate

# Run migrations
npx prisma migrate dev

# (Optional) Open Prisma Studio to view data
npx prisma studio
```

### 4. Start the Server
```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

The server will start at `http://localhost:3000`

---

## API Usage Examples

### 1. Register a New User

**Request:**
```bash
POST http://localhost:3000/api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123",
  "name": "João Silva",
  "cpf": "12345678901",
  "phone": "11987654321",
  "planType": "BASIC"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "uuid-here",
      "email": "user@example.com",
      "name": "João Silva",
      "cpf": "12345678901",
      "phone": "11987654321",
      "avatar": null,
      "planType": "BASIC",
      "createdAt": "2024-10-24T12:00:00.000Z",
      "updatedAt": "2024-10-24T12:00:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

### 2. Login

**Request:**
```bash
POST http://localhost:3000/api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "uuid-here",
      "email": "user@example.com",
      "name": "João Silva",
      "cpf": "12345678901",
      "phone": "11987654321",
      "avatar": null,
      "planType": "BASIC",
      "createdAt": "2024-10-24T12:00:00.000Z",
      "updatedAt": "2024-10-24T12:00:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

### 3. Get Current User (Protected Route)

**Request:**
```bash
GET http://localhost:3000/api/auth/me
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid-here",
      "email": "user@example.com",
      "name": "João Silva",
      "cpf": "12345678901",
      "phone": "11987654321",
      "avatar": null,
      "planType": "BASIC",
      "createdAt": "2024-10-24T12:00:00.000Z",
      "updatedAt": "2024-10-24T12:00:00.000Z"
    }
  }
}
```

---

### 4. Forgot Password

**Request:**
```bash
POST http://localhost:3000/api/auth/forgot-password
Content-Type: application/json

{
  "email": "user@example.com"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "If the email exists, a password reset link has been sent",
  "resetToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "resetUrl": "http://localhost:3001/reset-password?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Note:** In production, `resetToken` and `resetUrl` will not be in the response. Instead, an email will be sent to the user.

---

### 5. Reset Password

**Request:**
```bash
POST http://localhost:3000/api/auth/reset-password
Content-Type: application/json

{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "newPassword": "NewPassword123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password reset successful. You can now login with your new password."
}
```

---

## Error Responses

### Validation Error (400)
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "msg": "Password must be at least 6 characters long",
      "param": "password",
      "location": "body"
    }
  ]
}
```

### Unauthorized (401)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Conflict (409)
```json
{
  "success": false,
  "message": "User with this email already exists"
}
```

### Server Error (500)
```json
{
  "success": false,
  "message": "Failed to register user",
  "error": "Detailed error message (only in development)"
}
```

---

## Security Features

1. **Password Hashing:** Uses bcrypt with 10 salt rounds
2. **JWT Authentication:** Secure token-based authentication
3. **Password Requirements:** Minimum 6 characters, must include uppercase, lowercase, and number
4. **Token Expiration:** Access tokens expire in 7 days, reset tokens in 1 hour
5. **Unique Constraints:** Email and CPF must be unique
6. **Error Messages:** Generic messages to prevent user enumeration
7. **CORS Protection:** Configured for specific frontend URL
8. **Input Validation:** Comprehensive validation using express-validator

---

## Testing with Postman/Insomnia

1. **Import the collection** (create one with the examples above)
2. **Set up environment variables:**
   - `BASE_URL`: `http://localhost:3000`
   - `TOKEN`: (will be set automatically after login)
3. **Test flow:**
   1. Register a new user
   2. Login with credentials
   3. Copy the token from response
   4. Use token in Authorization header for protected routes
   5. Test forgot password flow
   6. Test reset password with token

---

## Next Steps

1. **Email Integration:** Implement email sending for password reset (using nodemailer or similar)
2. **Rate Limiting:** Add rate limiting to prevent brute force attacks
3. **Refresh Tokens:** Implement refresh token mechanism for better security
4. **Email Verification:** Add email verification on registration
5. **OAuth:** Add social login (Google, Facebook, etc.)
6. **2FA:** Implement two-factor authentication
7. **Session Management:** Add ability to view and revoke active sessions
8. **Audit Logging:** Log authentication events for security monitoring

---

## Troubleshooting

### Server won't start
- Check if PORT 3000 is available
- Verify DATABASE_URL in .env is correct
- Ensure PostgreSQL is running

### Database connection errors
- Verify PostgreSQL is running: `pg_ctl status`
- Check DATABASE_URL format
- Run `npx prisma migrate dev` to ensure schema is up to date

### Token errors
- Ensure JWT_SECRET is set in .env
- Check token expiration
- Verify Authorization header format: `Bearer <token>`

### Validation errors
- Check request body matches required format
- Ensure all required fields are provided
- Verify data types and formats

---

## Production Checklist

Before deploying to production:

- [ ] Change JWT_SECRET to a strong, random value
- [ ] Set NODE_ENV=production
- [ ] Configure proper CORS settings
- [ ] Set up email service for password reset
- [ ] Enable HTTPS
- [ ] Add rate limiting
- [ ] Set up proper logging
- [ ] Configure database backups
- [ ] Add monitoring and alerts
- [ ] Review and update security headers
- [ ] Implement refresh tokens
- [ ] Add email verification

---

## Support

For issues or questions, contact the ClubePharma development team.
