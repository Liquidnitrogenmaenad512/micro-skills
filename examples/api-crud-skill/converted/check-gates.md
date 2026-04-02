# Domain Gate Questions -- API CRUD Generator

Answer each YES or NO. Any NO = fix before proceeding.

1. Does every mutating endpoint (POST/PUT/PATCH/DELETE) have auth middleware? YES/NO
2. Does every endpoint validate all user input at the controller level? YES/NO
3. Does POST return 201 with a Location header? YES/NO
4. Does DELETE return 204 (not 200)? YES/NO
5. Does the list endpoint support pagination with a meta object? YES/NO
6. Are all error responses in the consistent format (`error`, `code`, `details`)? YES/NO
7. Is sensitive data (stack traces, DB details, internal paths) absent from all error responses? YES/NO
8. Are all SQL queries parameterized (no string concatenation)? YES/NO
9. Are there integration tests for every endpoint including error scenarios? YES/NO
10. Is the OpenAPI spec complete with schemas, query params, and examples? YES/NO
11. Are there no hardcoded secrets or config values in the generated code? YES/NO
12. Does file naming match the project's existing conventions? YES/NO
