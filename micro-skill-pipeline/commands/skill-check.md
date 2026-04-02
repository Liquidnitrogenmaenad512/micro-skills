---
description: Run the micro-skill pipeline Check gate against the current output. Merges universal, project-level, and skill-level gate questions.
argument-hint: [skill-name]
allowed-tools: Read, Bash, Grep, Glob
---

Run the Check gate from the micro-skill pipeline against the current work.

If `$ARGUMENTS` specifies a skill name, use it to load skill-level gates. If not specified and the active skill cannot be inferred from context, ask: "Which converted skill is active? Run /skill-list to see options."

## Steps

1. **Load universal gate questions** (always applied):
   1. Does the output match what was requested?
   2. Are all stated constraints satisfied?
   3. Does every element serve a purpose (no dead code, no placeholder text)?
   4. Is the output usable as-is with no manual fixes?
   5. If code: does it run without errors?
   6. If file: is the format correct and complete?
   7. If multi-component: do components integrate correctly?

2. **Load project-level gates**: Look for `check-gates.md` in the project root or `.claude/` directory. If found, add all questions to the gate list.

3. **Load skill-level gates**: If a specific converted skill is active (identified by context or user specification), look for `check-gates.md` in `${CLAUDE_PLUGIN_DATA}/converted/<skill-name>/`. If found, add all questions.

4. **Load failure logs**: Merge patterns from:
   - Project-level `failure-log.md` (project root)
   - Skill-level `failure-log.md` (`${CLAUDE_PLUGIN_DATA}/converted/<skill-name>/`)
   Each pattern becomes an additional constraint to check against.

5. **Answer every question YES or NO.** Be honest. "Mostly yes" = NO.

6. **Report results:**
   - List each question with its YES/NO answer and source (universal/project/skill)
   - For each NO: state what is wrong in one sentence
   - Offer to fix each failure

7. **After fixing and re-passing all gates:**
   - Ask whether to append new failure patterns to `failure-log.md`
   - If yes, append to both project-level and skill-level logs
