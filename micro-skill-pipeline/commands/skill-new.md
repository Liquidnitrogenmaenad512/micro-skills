---
description: Scaffold a new micro-skill pipeline with gated steps and failure log in persistent storage
argument-hint: <skill-name>
allowed-tools: Read, Write, Bash
---

Create a new micro-skill pipeline for "$ARGUMENTS" in the plugin's persistent data directory.

## What to create

```
${CLAUDE_PLUGIN_DATA}/converted/$ARGUMENTS/
├── SKILL.md                  # Orchestrator (~30 lines)
├── failure-log.md            # Empty, ready for entries
├── check-gates.md            # Domain-specific YES/NO gate questions
└── references/
    ├── 01-scope.md           # Extract constraints
    ├── 02-plan.md            # Design before building
    ├── 03-build.md           # Execute with micro-checks
    ├── 04-check.md           # Hard gate: YES/NO, no hand-waving
    └── 05-deliver.md         # Clean up and present
```

## Instructions

1. Validate `$ARGUMENTS`: must contain only alphanumeric characters, hyphens, and underscores. If empty, ask for a name. If it contains spaces or special characters, suggest a sanitized version (e.g., "my skill!" -> "my-skill") and confirm.
2. Ask the user what this skill does (one sentence) and when it should trigger.
3. Ask for 3-5 domain-specific gate questions for `check-gates.md`. These must be:
   - Specific ("Is every API endpoint authenticated?") not vague ("Is security handled?")
   - Binary YES/NO, no wiggle room
   - Based on real failure modes if the user knows them
4. Create the directory: `${CLAUDE_PLUGIN_DATA}/converted/$ARGUMENTS/`
5. Create the directory structure with the standard pipeline reference files.
6. Customize the SKILL.md with the skill name, description, and trigger.
7. Write the domain-specific gate questions into `check-gates.md`.
8. Seed `failure-log.md` with header and any known failure patterns the user provides.
9. Update the registry at `${CLAUDE_PLUGIN_DATA}/registry.json`:
   - If registry doesn't exist, create it with `{"version": 1, "conversions": []}`
   - Add entry with: name, sourcePath: "scaffolded", sourceHash: "", convertedAt, gateCount, pipelineFiles: 7, totalLines
10. Keep every file under 40 lines. If a file is getting long, split it.
