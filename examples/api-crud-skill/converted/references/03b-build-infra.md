# Step 3b: Build -- Infrastructure

Generate auth, error handling, tests, and docs.

## Actions

1. Auth middleware:
   - Reuse existing or create JWT middleware
   - Apply to POST/PUT/PATCH/DELETE routes
   - 401 for missing/invalid tokens
   - Role-based filtering if roles exist

2. Error handling -- consistent format for all responses:
   - 400: validation errors with field-level details
   - 401/403: auth errors, 404: not found, 409: conflict
   - 500: generic message (log actual error, never expose internals)
   - Format: `{ "error": "message", "code": "CODE", "details": [] }`

3. Database: add indexes for foreign keys, filter fields, sort fields.

4. Tests:
   - Unit: validation logic, business rules, each error code
   - Integration: full request/response, auth flows, pagination, errors
   - Use factories/fixtures, clean up after each test, separate test DB
   - Target 80%+ coverage

5. OpenAPI 3.0 spec: schemas, query params, error responses, auth, examples.

## Gate

- Auth applied to all mutating endpoints? YES/NO
- All error codes return consistent format? YES/NO
- Tests exist for every endpoint + error scenario? YES/NO
