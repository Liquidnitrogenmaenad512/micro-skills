# Step 2: Plan

Design the endpoint set and file layout before writing code.

## Actions

1. Map the 5 CRUD endpoints:
   - `GET /resources` -- pagination, sorting, filtering, search
   - `GET /resources/:id` -- with optional `?include=` for relations
   - `POST /resources` -- validation, 201 + Location header
   - `PUT /resources/:id` -- full replacement
   - `PATCH /resources/:id` -- partial update
   - `DELETE /resources/:id` -- 204, soft delete if `deletedAt` exists

2. Plan auth strategy:
   - Check for existing auth middleware; reuse if found
   - Apply auth to POST/PUT/PATCH/DELETE
   - Determine role-based rules (admin/user/public)

3. Plan file layout matching project conventions. Default:
   - `routes/`, `controllers/`, `models/`, `validators/`, `tests/`

4. Check the failure log -- do any patterns apply?

## Gate

- Does every resource field map to a validation rule? YES/NO
- Is the file layout explicit (not "figure it out later")? YES/NO
- Have I checked the failure log? YES/NO

All YES = proceed. Any NO = revise.
