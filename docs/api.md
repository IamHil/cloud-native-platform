# API Documentation

Base URL (local): `http://localhost:8000`  
Swagger UI: `http://localhost:8000/docs`  
OpenAPI JSON: `http://localhost:8000/openapi.json`

---

## Health & Metrics

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/` | No | Root welcome message |
| GET | `/health` | No | Liveness/readiness — used by Kubernetes probes |
| GET | `/metrics` | No | Prometheus metrics scrape endpoint |

Example health response:

```json
{
  "status": "healthy",
  "service": "cloud-native-api",
  "version": "1.0.0"
}
```

---

## Authentication

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/auth/register` | No | Create user (password hashed) |
| POST | `/auth/login` | No | Returns JWT access token |

Register body:

```json
{
  "email": "user@example.com",
  "username": "hil",
  "password": "strong-password"
}
```

Login body:

```json
{
  "email": "user@example.com",
  "password": "strong-password"
}
```

Use the token as: `Authorization: Bearer <token>` on protected routes.

---

## Files

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/files/` | Check Swagger | List files in S3 |
| POST | `/files/upload` | Check Swagger | Upload file → S3 + metadata + SQS |
| GET | `/files/metadata` | Check Swagger | List DynamoDB file metadata |

**Pipeline:**

```text
Upload → S3 object
      → DynamoDB metadata
      → SQS message
      → Worker updates status
```

---

## Security notes (Phase 9)

- CORS restricted to configured origins
- Rate limiting (default 60/minute)
- Security headers on responses
- JWT secret must be strong (min 16 chars; weak defaults rejected)
