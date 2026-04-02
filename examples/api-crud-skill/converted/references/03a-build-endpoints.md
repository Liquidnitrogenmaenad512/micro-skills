# Step 3a: Build -- Endpoints

Generate the CRUD endpoints and validation layer.

## Actions

1. Create the model/schema file with all fields, types, and constraints.

2. Create the validation layer:
   - Use project's validation library (Zod/Joi/Pydantic/etc.)
   - Validate: required fields, string length, number range, email format, enum values, date format
   - Sanitize strings to prevent XSS

3. Create the 5 route handlers:
   - GET list: pagination (`?page=&limit=`, max 100), sorting, filtering, search
   - GET by ID: 404 if missing, optional `?include=` for relations
   - POST: validate, return 201 + Location header + created resource
   - PUT: validate all fields, 404 if missing, return 200
   - PATCH: validate provided fields only, 404 if missing, return 200
   - DELETE: 404 if missing, soft delete if `deletedAt`, return 204

4. Micro-check each handler:
   - Does it match its plan description? YES/NO
   - Does it use parameterized queries (not string concatenation)? YES/NO

## Gate

- All 5 handlers built? YES/NO
- Every handler passes its micro-check? YES/NO
