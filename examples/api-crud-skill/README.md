# Example: API CRUD Generator Conversion

This example shows a real 256-line monolithic skill converted into a micro-skill pipeline.

## Before

**1 file, 256 lines** -- `original/SKILL.md`

A single massive SKILL.md covering tech stack detection, resource definition, endpoint generation, auth, validation, error handling, database operations, testing, OpenAPI docs, file organization, a checklist, and an "avoid" list. Claude skims it, misses constraints, and produces inconsistent output.

## After

**9 files, max 35 lines each** -- `converted/`

```
converted/
├── SKILL.md              (26 lines)  -- Pipeline orchestrator
├── check-gates.md        (14 lines)  -- 12 binary YES/NO gate questions
├── failure-log.md        (11 lines)  -- 8 seeded patterns from "avoid" list
└── references/
    ├── 01-scope.md       (28 lines)  -- Stack detection + resource definition
    ├── 02-plan.md        (28 lines)  -- Endpoint mapping + auth + file layout
    ├── 03a-build-endpoints.md (30 lines)  -- CRUD handlers + validation
    ├── 03b-build-infra.md    (32 lines)  -- Auth, errors, tests, OpenAPI
    ├── 04-check.md       (27 lines)  -- Hard gate (universal + domain)
    └── 05-deliver.md     (21 lines)  -- Cleanup + summary
```

## What Changed

| Aspect | Before (monolith) | After (pipeline) |
|--------|-------------------|-----------------|
| Total lines | 256 | 217 (spread across 9 files) |
| Longest file | 256 lines | 35 lines |
| Gate questions | 12-item checklist (easy to skip) | 12 binary YES/NO gates (must all pass) |
| Failure tracking | "Avoid" list (static, ignored) | failure-log.md (grows, read every run) |
| Execution order | Claude picks what to read | Enforced: Scope -> Plan -> Build -> Check -> Deliver |
| Build step | One pass, hope for the best | Micro-checks after each component |
| Check step | "Checklist Before Completing" (honor system) | Hard gate: ANY NO = fix before proceeding |

## Using the Converted Skill

Once converted, the pipeline replaces the monolith. Here's what happens when you ask Claude to "create CRUD endpoints for a `Product` resource":

### Step 1: Scope (Claude reads `01-scope.md`)

Claude detects the stack, reads project conventions, and defines the resource fields. It answers its 3 gate questions:

```
- Can I name the resource and its fields in one sentence? YES -- Product with name, price, category, stock, createdAt
- Do I know the framework and ORM? YES -- Express + Prisma
- Have I read the project's existing conventions? YES -- camelCase files, src/routes/ structure
```

All YES -- proceeds to Step 2. If any NO, Claude asks you one clarifying question.

### Step 2: Plan (Claude reads `02-plan.md`)

Claude maps the 5 endpoints, plans auth (reuses existing JWT middleware found in `src/middleware/auth.ts`), and plans the file layout. Checks failure log -- notes "hardcoded JWT secret" pattern. Gate:

```
- Does every resource field map to a validation rule? YES
- Is the file layout explicit? YES -- 6 files listed with exact paths
- Have I checked the failure log? YES -- 8 patterns noted as constraints
```

### Step 3: Build (Claude reads `03a-build-endpoints.md`, then `03b-build-infra.md`)

Claude builds handlers one at a time. After each handler, micro-check:

```
GET /products -- matches plan? YES. Uses parameterized queries? YES.
POST /products -- matches plan? YES. Uses parameterized queries? YES.
...
```

Then builds auth, error handling, tests, OpenAPI spec. Gate:

```
- Auth applied to all mutating endpoints? YES
- All error codes return consistent format? YES
- Tests exist for every endpoint + error scenario? YES
```

### Step 4: Check -- THE HARD GATE (Claude reads `04-check.md` + `check-gates.md`)

Claude answers ALL 17 questions (5 universal + 12 domain). Example:

```
Universal:
1. Does the output match the deliverable? YES
2. Are all constraints satisfied? YES
3. No dead code or placeholders? YES
4. Usable as-is? YES
5. Code runs, tests pass? YES

Domain (from check-gates.md):
1. Auth on all mutating endpoints? YES
2. All inputs validated? YES
3. POST returns 201 + Location? NO -- Location header missing on POST /products
...
```

**One NO found.** Claude fixes it, then re-runs the entire checklist from question 1. After passing:

```
failure-log.md gets a new line:
- [2026-04-02] check: missing Location header on POST response
```

That pattern is now a permanent constraint for every future run.

### Step 5: Deliver (Claude reads `05-deliver.md`)

Claude cleans up, runs tests one final time, and presents:

```
Created CRUD endpoints for Product resource:
- 6 files generated in src/routes/, src/controllers/, src/models/, src/validators/, tests/
- 94% test coverage
- Reused existing JWT middleware from src/middleware/auth.ts
- Soft delete enabled (Product has deletedAt field)
```

### What's Different From the Monolith?

With the **monolith**, Claude would have read 256 lines, forgotten the Location header requirement buried on line 178, skipped the "Avoid" list at the bottom, and delivered code that looks right but silently violates 2-3 constraints.

With the **pipeline**, the missing Location header was caught at Step 4 gate question #3, fixed, re-verified, and recorded in the failure log so it never happens again.

## How the Conversion Works

### Section Classification

| Original Section | Pipeline Target | Rationale |
|-----------------|----------------|-----------|
| "When to Use", "Tech Stack Detection", "Resource Definition" | `01-scope.md` | Context and constraints |
| "Endpoint Generation", "Auth", "File Organization" | `02-plan.md` | Design before building |
| "Input Validation", handler details, response formats | `03a-build-endpoints.md` | Execution instructions |
| "Error Handling", "Database", "Testing", "OpenAPI" | `03b-build-infra.md` | Infrastructure (split because >40 lines) |
| "Checklist Before Completing" | `check-gates.md` | Converted to YES/NO questions |
| "Avoid" list | `failure-log.md` | Seeded as learned patterns |

### Gate Question Extraction

The original's "Avoid" section and "Checklist" section were converted to binary gates:

| Original | Gate Question |
|----------|--------------|
| "Don't skip validation on any endpoint" | "Does every endpoint validate all user input?" YES/NO |
| "Don't return 200 for creation (use 201)" | "Does POST return 201 with a Location header?" YES/NO |
| "Don't return 200 for deletion (use 204)" | "Does DELETE return 204 (not 200)?" YES/NO |
| "Don't expose internal error details" | "Is sensitive data absent from all error responses?" YES/NO |
| "Don't use string concatenation for SQL" | "Are all SQL queries parameterized?" YES/NO |
| "Don't hardcode authentication secrets" | "Are there no hardcoded secrets in the generated code?" YES/NO |
