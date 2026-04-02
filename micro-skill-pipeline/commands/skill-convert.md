---
description: Convert an existing monolithic skill into a micro-skill pipeline with gated steps. Accepts a skill name or a full path. Stores the converted pipeline in the plugin's persistent data directory.
argument-hint: <skill-name-or-path>
allowed-tools: Read, Write, Bash, Glob, Grep
---

Convert a skill into a micro-skill pipeline. `$ARGUMENTS` can be a **skill name** or a **file path**.

## Step 0: Resolve the skill

If `$ARGUMENTS` looks like a file path (contains `/` or `\` or ends in `.md`), use it directly.

Otherwise, treat it as a **skill name** and search for it in these locations (stop at first match):
1. `.claude/skills/$ARGUMENTS/SKILL.md` (project-level)
2. `~/.claude/skills/$ARGUMENTS/SKILL.md` (user-level)
3. `~/.claude/.agents/skills/$ARGUMENTS/SKILL.md` (agent skills)
4. `~/.claude/plugins/` -- search recursively: `find ~/.claude/plugins -path "*/$ARGUMENTS/SKILL.md" -type f`
5. If multiple matches found, list them and ask the user which one to convert.
6. If no match found, report: "Could not find skill '$ARGUMENTS'. Provide the full path instead."

## Steps

1. Read the resolved skill file. Compute SHA256 hash (cross-platform):
   `(sha256sum "<path>" 2>/dev/null || shasum -a 256 "<path>" 2>/dev/null || certutil -hashfile "<path>" SHA256 2>/dev/null | head -2 | tail -1) | cut -d' ' -f1`

2. Classify each section of the source:
   - "Do this" instructions -> Build step (03-build.md)
   - "Check/avoid/ensure" instructions -> convert to YES/NO questions using the Gate Question Extraction Rules below, then write to `check-gates.md`
   - Reference data (tables, lists, examples) -> Separate reference files
   - QA/validation prose (non-convertible to YES/NO) -> universal check context in 04-check.md
   - Context/scope instructions -> Scope step (01-scope.md)

3. Determine the skill name from the source filename or directory name.

4. Create the pipeline directory:
   `${CLAUDE_PLUGIN_DATA}/converted/<skill-name>/`

5. Build the pipeline files (each under 40 lines):
   - `SKILL.md` -- orchestrator referencing the 5 stages, under 30 lines
   - `references/01-scope.md` -- constraints relevant to this skill's domain
   - `references/02-plan.md` -- design step specific to this skill's output type
   - `references/03-build.md` -- execution instructions from the original
   - `references/04-check.md` -- universal checks plus extracted domain checks
   - `references/05-deliver.md` -- finalization steps
   - `check-gates.md` -- domain-specific YES/NO gate questions
   - `failure-log.md` -- seeded with "avoid" items from the original skill

6. Write the source hash:
   `echo "<hash>" > ${CLAUDE_PLUGIN_DATA}/converted/<skill-name>/original-hash.txt`

7. If any file exceeds 40 lines, split it (e.g., `03a-build-layout.md`, `03b-build-content.md`).

8. Reference data (color palettes, font tables, API specs) goes into separate files under `references/` -- loaded on demand, not inlined.

9. Update the registry at `${CLAUDE_PLUGIN_DATA}/registry.json`:
   - If registry doesn't exist, create it with `{"version": 1, "conversions": []}`
   - Add or update the entry for this skill name
   - Include: name, sourcePath (absolute), sourceHash, convertedAt (ISO 8601), gateCount, pipelineFiles count, totalLines count

10. Show the user a before/after comparison:
    - Original: N lines in M files
    - Pipeline: N files, max K lines each, M gate questions

11. Ask the user to review the gate questions in `check-gates.md` -- these are the highest-value part and should reflect real failure modes, not generic statements.

## Gate Question Extraction Rules

When extracting gate questions from the source skill:
- Every question MUST be answerable YES or NO
- Every question MUST be specific: "Does every API endpoint have auth?" not "Is security handled?"
- Convert "avoid X" into "Is the output free of X? YES/NO"
- Convert "ensure X" into "Does the output include X? YES/NO"
- Convert "never do X" into "Is X absent from the output? YES/NO"
- Discard any instruction that cannot become a binary gate question
