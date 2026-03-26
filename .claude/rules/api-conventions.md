---
paths:
  - "src/api/**"
  - "src/routes/**"
  - "src/controllers/**"
  - "api/**"
---

# API Conventions

Loaded when working with API, route, or controller files.

## RESTful Design
- Use plural nouns for resources: `/users`, `/orders` — never verbs in URLs
- HTTP methods map to operations: GET=read, POST=create, PUT=replace, PATCH=update, DELETE=remove
- Nest related resources: `/users/:id/orders` — max 2 levels deep

## Error Handling
- Consistent error response shape: `{ "error": { "code", "message", "details?" } }`
- Use appropriate HTTP status codes — 400 for bad input, 401/403 for auth, 404 for missing, 500 for server errors
- Never expose stack traces or internal details in production error responses

## Security & Validation
- Validate all input on every endpoint — reject early with descriptive 400 errors
- Authentication and authorization checks on every non-public endpoint
- Rate limiting: document limits in response headers; return 429 when exceeded

## Pagination & Versioning
- All list endpoints MUST support pagination: `?page=1&limit=20` or cursor-based
- Include total count and next/previous links in paginated responses
- Version APIs via URL prefix (`/v1/`) or header — never break existing consumers
