# ClubePharma Authentication System - Architecture

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT APPLICATION                       │
│                    (React/Vue/Mobile App)                        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ HTTP Requests
                             │ (JSON + JWT Token)
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                         EXPRESS SERVER                           │
│                         (src/server.js)                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    MIDDLEWARE LAYER                       │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  • CORS Configuration                                     │  │
│  │  • JSON Body Parser                                       │  │
│  │  • Express Validator                                      │  │
│  │  • Auth Middleware (src/middlewares/auth.js)             │  │
│  └──────────────────────────────────────────────────────────┘  │
│                             ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                      ROUTING LAYER                        │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  • /health (Health Check)                                │  │
│  │  • /api/auth/* (Auth Routes - src/routes/authRoutes.js)  │  │
│  │    - POST /register                                       │  │
│  │    - POST /login                                          │  │
│  │    - GET  /me (Protected)                                │  │
│  │    - POST /forgot-password                               │  │
│  │    - POST /reset-password                                │  │
│  └──────────────────────────────────────────────────────────┘  │
│                             ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                   CONTROLLER LAYER                        │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │         (src/controllers/authController.js)               │  │
│  │                                                           │  │
│  │  • register(req, res)                                     │  │
│  │  • login(req, res)                                        │  │
│  │  • me(req, res)                                           │  │
│  │  • forgotPassword(req, res)                               │  │
│  │  • resetPassword(req, res)                                │  │
│  └──────────────────────────────────────────────────────────┘  │
│                             ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    UTILITY LAYER                          │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  JWT Utils (src/utils/jwt.js)                            │  │
│  │  • generateToken(userId)                                  │  │
│  │  • verifyToken(token)                                     │  │
│  │  • generateResetToken(userId)                             │  │
│  │  • verifyResetToken(token)                                │  │
│  │                                                           │  │
│  │  bcryptjs (npm package)                                   │  │
│  │  • hash(password, saltRounds)                             │  │
│  │  • compare(password, hash)                                │  │
│  └──────────────────────────────────────────────────────────┘  │
│                             ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    DATABASE LAYER                         │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │         Prisma Client (src/config/database.js)            │  │
│  │         • user.create()                                   │  │
│  │         • user.findUnique()                               │  │
│  │         • user.update()                                   │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ SQL Queries
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      PostgreSQL DATABASE                         │
│                        (localhost:5432)                          │
├─────────────────────────────────────────────────────────────────┤
│  Tables:                                                         │
│  • users                                                         │
│  • family_members                                                │
│  • treatments                                                    │
│  • prescriptions                                                 │
│  • exams                                                         │
│  • products                                                      │
│  • orders                                                        │
│  • appointments                                                  │
│  • doctors                                                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## Authentication Flow Diagrams

### 1. User Registration Flow

```
┌──────────┐                                                      ┌──────────┐
│  Client  │                                                      │  Server  │
└─────┬────┘                                                      └────┬─────┘
      │                                                                │
      │  POST /api/auth/register                                      │
      │  { email, password, name, ... }                               │
      ├──────────────────────────────────────────────────────────────>│
      │                                                                │
      │                                            Validate Input      │
      │                                            ┌─────────────┐    │
      │                                            │ Validation  │    │
      │                                            │ Rules OK?   │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Check if Email      │
      │                                            Already Exists      │
      │                                            ┌─────────────┐    │
      │                                            │ Database    │    │
      │                                            │ Lookup      │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Hash Password       │
      │                                            ┌─────────────┐    │
      │                                            │ bcrypt      │    │
      │                                            │ 10 rounds   │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Create User         │
      │                                            ┌─────────────┐    │
      │                                            │ Database    │    │
      │                                            │ Insert      │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Generate JWT        │
      │                                            ┌─────────────┐    │
      │                                            │ JWT Token   │    │
      │                                            │ 7d expiry   │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │  201 Created                                                   │
      │  { user: {...}, token: "eyJ..." }                             │
      │<──────────────────────────────────────────────────────────────┤
      │                                                                │
      │  Store Token Locally                                          │
      │  (localStorage/cookies)                                       │
      │                                                                │
```

---

### 2. User Login Flow

```
┌──────────┐                                                      ┌──────────┐
│  Client  │                                                      │  Server  │
└─────┬────┘                                                      └────┬─────┘
      │                                                                │
      │  POST /api/auth/login                                         │
      │  { email, password }                                          │
      ├──────────────────────────────────────────────────────────────>│
      │                                                                │
      │                                            Validate Input      │
      │                                            ┌─────────────┐    │
      │                                            │ Validation  │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Find User by Email  │
      │                                            ┌─────────────┐    │
      │                                            │ Database    │    │
      │                                            │ Lookup      │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            User Exists?        │
      │                                            ┌─────────────┐    │
      │                                            │ No → 401    │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Compare Password    │
      │                                            ┌─────────────┐    │
      │                                            │ bcrypt      │    │
      │                                            │ compare()   │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Password Valid?     │
      │                                            ┌─────────────┐    │
      │                                            │ No → 401    │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Generate JWT        │
      │                                            ┌─────────────┐    │
      │                                            │ JWT Token   │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │  200 OK                                                        │
      │  { user: {...}, token: "eyJ..." }                             │
      │<──────────────────────────────────────────────────────────────┤
      │                                                                │
      │  Store Token                                                  │
      │                                                                │
```

---

### 3. Protected Route Access Flow

```
┌──────────┐                                                      ┌──────────┐
│  Client  │                                                      │  Server  │
└─────┬────┘                                                      └────┬─────┘
      │                                                                │
      │  GET /api/auth/me                                             │
      │  Authorization: Bearer eyJ...                                 │
      ├──────────────────────────────────────────────────────────────>│
      │                                                                │
      │                                            Auth Middleware     │
      │                                            ┌─────────────┐    │
      │                                            │ Extract     │    │
      │                                            │ Token       │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Token Exists?       │
      │                                            ┌─────────────┐    │
      │                                            │ No → 401    │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Verify Token        │
      │                                            ┌─────────────┐    │
      │                                            │ JWT Verify  │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Token Valid?        │
      │                                            ┌─────────────┐    │
      │                                            │ No → 401    │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Fetch User          │
      │                                            ┌─────────────┐    │
      │                                            │ Database    │    │
      │                                            │ Lookup      │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            User Exists?        │
      │                                            ┌─────────────┐    │
      │                                            │ No → 401    │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Attach to req.user  │
      │                                            ┌─────────────┐    │
      │                                            │ Continue to │    │
      │                                            │ Controller  │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Execute Controller  │
      │                                            ┌─────────────┐    │
      │                                            │ me(req,res) │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │  200 OK                                                        │
      │  { user: {...} }                                              │
      │<──────────────────────────────────────────────────────────────┤
      │                                                                │
```

---

### 4. Password Reset Flow

```
┌──────────┐                                                      ┌──────────┐
│  Client  │                                                      │  Server  │
└─────┬────┘                                                      └────┬─────┘
      │                                                                │
      │  STEP 1: Request Reset                                        │
      │  POST /api/auth/forgot-password                               │
      │  { email }                                                    │
      ├──────────────────────────────────────────────────────────────>│
      │                                                                │
      │                                            Find User           │
      │                                            ┌─────────────┐    │
      │                                            │ Database    │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Generate Reset Token│
      │                                            ┌─────────────┐    │
      │                                            │ JWT Token   │    │
      │                                            │ 1h expiry   │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Save to Database    │
      │                                            ┌─────────────┐    │
      │                                            │ resetToken  │    │
      │                                            │ expiry      │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Send Email (Prod)   │
      │                                            Return Token (Dev)  │
      │                                                                │
      │  200 OK                                                        │
      │  { resetToken, resetUrl }                                     │
      │<──────────────────────────────────────────────────────────────┤
      │                                                                │
      │  User Receives Email/Token                                    │
      │  Clicks Reset Link                                            │
      │                                                                │
      │  STEP 2: Reset Password                                       │
      │  POST /api/auth/reset-password                                │
      │  { token, newPassword }                                       │
      ├──────────────────────────────────────────────────────────────>│
      │                                                                │
      │                                            Verify Reset Token  │
      │                                            ┌─────────────┐    │
      │                                            │ JWT Verify  │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Find User with Token│
      │                                            ┌─────────────┐    │
      │                                            │ Database    │    │
      │                                            │ Not Expired │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Hash New Password   │
      │                                            ┌─────────────┐    │
      │                                            │ bcrypt      │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │                                            Update User         │
      │                                            ┌─────────────┐    │
      │                                            │ Save Pass   │    │
      │                                            │ Clear Token │    │
      │                                            └──────┬──────┘    │
      │                                                   │            │
      │  200 OK                                                        │
      │  { message: "Password reset successful" }                     │
      │<──────────────────────────────────────────────────────────────┤
      │                                                                │
```

---

## Data Flow Architecture

### Request → Response Lifecycle

```
1. HTTP Request
   ↓
2. Express Server (server.js)
   ↓
3. CORS Middleware
   ↓
4. Body Parser Middleware
   ↓
5. Route Matching (authRoutes.js)
   ↓
6. Input Validation (express-validator)
   ↓
7. Authentication Middleware (auth.js) [if protected route]
   │   ├─ Extract Token
   │   ├─ Verify Token (jwt.js)
   │   ├─ Fetch User (database.js → Prisma)
   │   └─ Attach to req.user
   ↓
8. Controller Function (authController.js)
   │   ├─ Business Logic
   │   ├─ Password Hashing/Verification (bcryptjs)
   │   ├─ Token Generation (jwt.js)
   │   └─ Database Operations (database.js → Prisma)
   ↓
9. Response Generation
   │   ├─ Success: 200/201 with data
   │   └─ Error: 4xx/5xx with message
   ↓
10. Error Handler Middleware (if error occurred)
    ↓
11. HTTP Response
```

---

## File Dependencies Graph

```
server.js
   ├─ dotenv
   ├─ express
   ├─ cors
   └─ authRoutes.js
       ├─ express
       ├─ express-validator
       ├─ authController.js
       │   ├─ bcryptjs
       │   ├─ express-validator
       │   ├─ database.js
       │   │   └─ @prisma/client
       │   └─ jwt.js
       │       └─ jsonwebtoken
       └─ auth.js (middleware)
           ├─ jwt.js
           │   └─ jsonwebtoken
           └─ database.js
               └─ @prisma/client
```

---

## Security Architecture

### Defense Layers

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: Input Validation                              │
│  • Express Validator                                    │
│  • Email format, password strength, data types          │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│  Layer 2: CORS Protection                               │
│  • Whitelist specific origins                           │
│  • Credentials support                                  │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│  Layer 3: Authentication                                │
│  • JWT token verification                               │
│  • Token expiration checks                              │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│  Layer 4: Password Security                             │
│  • bcrypt hashing (10 rounds)                           │
│  • No plaintext passwords                               │
│  • Passwords never in responses                         │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│  Layer 5: Database Security                             │
│  • Prisma ORM (SQL injection prevention)                │
│  • Unique constraints                                   │
│  • Indexed queries                                      │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│  Layer 6: Error Handling                                │
│  • Generic error messages                               │
│  • No stack traces in production                        │
│  • No user enumeration                                  │
└─────────────────────────────────────────────────────────┘
```

---

## Token Architecture

### JWT Token Structure

```
Header
{
  "alg": "HS256",
  "typ": "JWT"
}

Payload (Access Token)
{
  "userId": "uuid",
  "iat": 1234567890,
  "exp": 1234567890
}

Payload (Reset Token)
{
  "userId": "uuid",
  "type": "password_reset",
  "iat": 1234567890,
  "exp": 1234567890
}

Signature
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  JWT_SECRET
)
```

### Token Lifecycle

```
Access Token (7 days):
Generation (Login/Register) → Storage (Client) → Usage (API Calls) → Expiration

Reset Token (1 hour):
Generation (Forgot Password) → Email/Response → Database Storage →
Verification (Reset Password) → Deletion (After Use)
```

---

## Database Schema Relationships

```
User
├─ id (PK)
├─ email (UNIQUE)
├─ password (hashed)
├─ cpf (UNIQUE)
├─ resetToken
└─ resetTokenExpiry

Relations:
├─ familyMembers (1:N) → FamilyMember
├─ treatments (1:N) → Treatment
├─ prescriptions (1:N) → Prescription
├─ exams (1:N) → Exam
├─ appointments (1:N) → Appointment
├─ orders (1:N) → Order
└─ cartItems (1:N) → CartItem
```

---

## Deployment Architecture (Production)

```
┌─────────────────────────────────────────────────────────┐
│                      Load Balancer                       │
│                         (HTTPS)                          │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
┌───────────────┐         ┌───────────────┐
│  App Server 1 │         │  App Server 2 │
│  (Node.js)    │         │  (Node.js)    │
└───────┬───────┘         └───────┬───────┘
        │                         │
        └────────────┬────────────┘
                     ▼
┌─────────────────────────────────────────────────────────┐
│              PostgreSQL Database                         │
│              (Primary + Replicas)                        │
└─────────────────────────────────────────────────────────┘

External Services:
├─ Email Service (SendGrid/AWS SES)
├─ File Storage (AWS S3)
└─ Monitoring (DataDog/New Relic)
```

---

## Performance Characteristics

### Response Times (Expected)
- Health Check: < 5ms
- Register: 100-200ms (bcrypt hashing)
- Login: 100-200ms (bcrypt verification)
- Protected Routes: 10-50ms (token verification + DB lookup)
- Password Reset Request: 100-150ms
- Password Reset: 100-200ms

### Scalability
- **Horizontal:** Stateless JWT allows multiple server instances
- **Vertical:** Efficient DB queries with Prisma
- **Database:** Connection pooling prevents exhaustion

---

## Error Handling Architecture

```
Error Occurs
    ↓
Thrown/Caught in Controller
    ↓
Error Handler Middleware
    ↓
┌─────────────────────────────────┐
│  Is Operational Error?          │
│  (4xx - Client Error)            │
├─────────────────────────────────┤
│  YES → Return Specific Message  │
│  NO → Generic Error Message     │
└─────────────────────────────────┘
    ↓
┌─────────────────────────────────┐
│  Environment Check              │
├─────────────────────────────────┤
│  Development: Include Stack     │
│  Production: Minimal Info       │
└─────────────────────────────────┘
    ↓
JSON Response to Client
```

---

## Summary

This architecture provides:

✅ **Clear separation of concerns**
✅ **Scalable design**
✅ **Secure by default**
✅ **Easy to maintain**
✅ **Production-ready**
✅ **Well-documented**

All components work together to provide a robust, secure, and performant authentication system for the ClubePharma platform.
