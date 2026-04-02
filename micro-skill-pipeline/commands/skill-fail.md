---
description: Append a failure pattern to both project-level and skill-level failure logs.
argument-hint: <what went wrong> [--skill <skill-name>]
allowed-tools: Read, Write, Glob
---

Append a failure pattern to the failure logs.

## Steps

1. **Project-level log**: Find `failure-log.md` in the project root.
   If it doesn't exist, create it with the header:
   ```
   # Failure Log
   One-line patterns learned from past mistakes.
   ```

2. **Skill-level log**: If a skill name is specified via `--skill <name>` or can be inferred from context, find `failure-log.md` in `${CLAUDE_PLUGIN_DATA}/converted/<skill-name>/`.
   If it doesn't exist, create it with the same header.
   If the skill name cannot be determined, skip the skill-level log and note that only the project-level log was updated.

3. Compress the description to under 10 words if needed.

4. Append this line to both logs (use YYYY-MM-DD format for the date):
   `- [YYYY-MM-DD] check: $ARGUMENTS`

5. Confirm what was added and to which logs.
