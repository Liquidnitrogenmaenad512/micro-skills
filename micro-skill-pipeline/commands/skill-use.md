---
description: Activate a converted micro-skill pipeline by name. Loads the pipeline version and runs it through the gated stages.
argument-hint: <skill-name>
allowed-tools: Read, Write, Bash, Glob, Grep
---

Activate the converted micro-skill pipeline for "$ARGUMENTS".

## Steps

1. **Find the converted skill**: Look for `${CLAUDE_PLUGIN_DATA}/converted/$ARGUMENTS/SKILL.md`.
   If it doesn't exist, report: "No converted pipeline found for '$ARGUMENTS'. Run /skill-list to see available conversions, or /skill-convert to create one."

2. **Staleness check**: Read `${CLAUDE_PLUGIN_DATA}/converted/$ARGUMENTS/original-hash.txt` to get the stored hash. Read `${CLAUDE_PLUGIN_DATA}/registry.json` to get the `sourcePath` for this skill.
   - If `sourcePath` exists and is not "scaffolded":
     - Compute current hash (cross-platform): `(sha256sum "<sourcePath>" 2>/dev/null || shasum -a 256 "<sourcePath>" 2>/dev/null || certutil -hashfile "<sourcePath>" SHA256 2>/dev/null | head -2 | tail -1) | cut -d' ' -f1`
     - Compare to stored hash
     - If different: **the original skill has been updated since conversion**.
       - Show the user: "The original skill at <sourcePath> has changed since this pipeline was created. The converted pipeline may be outdated."
       - Ask the user: "Would you like to reconvert the skill to pick up the changes? (This will update the pipeline while preserving your failure-log.md)"
       - If user agrees: run the reconversion (read the updated original, reclassify sections, rewrite pipeline files, update hash, preserve failure-log.md)
       - If user declines: proceed with the existing pipeline as-is
   - If `sourcePath` no longer exists: warn "Original skill file no longer exists at <sourcePath>. Pipeline may be orphaned."

3. **Load the pipeline**: Read `${CLAUDE_PLUGIN_DATA}/converted/$ARGUMENTS/SKILL.md` and follow its instructions exactly -- execute the gated pipeline stage by stage (Scope, Plan, Build, Check, Deliver).

4. **Read the failure log first**: Before starting the pipeline, read `${CLAUDE_PLUGIN_DATA}/converted/$ARGUMENTS/failure-log.md` and the project-level `failure-log.md` if it exists. Every pattern is a mandatory constraint.
