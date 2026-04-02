# Step 1: Scope

Extract what resource is being built and what stack to target.

## Actions

1. Detect the tech stack:
   - `package.json` -> Node.js (Express/Fastify/Nest)
   - `requirements.txt` or `pyproject.toml` -> Python (FastAPI/Django/Flask)
   - `go.mod` -> Go (Gin/Echo/Chi)
   - `Gemfile` -> Ruby (Rails/Sinatra)
   - If unclear, ask the user (one question max).

2. Read existing project conventions:
   - File naming style, directory structure, import style
   - Existing middleware patterns, ORM in use

3. Define the resource:
   - Name (singular + plural)
   - Fields with types, constraints (required, length, range, enum, unique, defaults)
   - Relationships (hasMany, belongsTo, manyToMany)
   - Searchable/filterable fields
   - Fields excluded from responses (passwords, internal IDs)

## Gate

- Can I name the resource and its fields in one sentence? YES/NO
- Do I know the framework and ORM? YES/NO
- Have I read the project's existing conventions? YES/NO

All YES = proceed. Any NO = ask the user one clarifying question.
