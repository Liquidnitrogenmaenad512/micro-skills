# Failure Log
One-line patterns learned from past mistakes.

- [2026-04-02] check: forgot Location header on POST 201 responses
- [2026-04-02] check: returned 200 instead of 204 for DELETE
- [2026-04-02] check: used string concat for SQL instead of parameterized
- [2026-04-02] check: exposed stack trace in 500 error response
- [2026-04-02] check: skipped auth middleware on PATCH endpoint
- [2026-04-02] check: no tests for 409 conflict scenario
- [2026-04-02] check: used sync file ops in Node.js handler
- [2026-04-02] check: hardcoded JWT secret in middleware file
