---
description: Temporarily use the original (unconverted) version of a skill, bypassing its micro-skill pipeline.
argument-hint: <skill-name>
allowed-tools: Read, Bash, Glob
---

Bypass the micro-skill pipeline for "$ARGUMENTS" and use the original skill instead.

## Steps

1. Read `${CLAUDE_PLUGIN_DATA}/registry.json` to find the entry for "$ARGUMENTS".
   If not found: "No converted pipeline exists for '$ARGUMENTS'. Nothing to bypass."

2. Get the `sourcePath` from the registry entry.
   If the file no longer exists: "Original skill file not found at <sourcePath>."

3. Read and follow the original skill at `sourcePath` directly, without the gated pipeline.

4. After completion, remind the user: "You used the original skill without gates. Run /skill-check $ARGUMENTS to verify the output against the pipeline's gate questions."
