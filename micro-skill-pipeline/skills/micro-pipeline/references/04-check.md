# Step 4: Check

The hard gate. Assume there are problems. Your job is to find them.
Answer every question YES or NO. Do not rationalize a NO into "mostly yes."

## Universal Checks

1. Does the output match the deliverable defined in Step 1?
2. Are all explicit constraints from Step 1 satisfied?
3. Does every element serve a purpose (no dead code, no placeholder text, no filler)?
4. Would this output be usable as-is, with no manual fixes needed?
5. If code: does it run without errors? Did linting/tests pass?
6. If file: is the format correct and complete?
7. If multi-component: do the components integrate correctly?

## Project-Specific Checks

Look for a file named `check-gates.md` in the project root or `.claude/` directory.
If it exists, read it and answer every question in it as additional gates.
If it doesn't exist, skip this section.

## Failure Log Checks

8. Re-read `failure-log.md`. Does the output violate any listed pattern?

## On Failure

- For each NO: state what is wrong in one sentence.
- Fix each issue.
- Re-run this entire checklist from question 1.
- After passing: append a one-line failure pattern to `failure-log.md`:
  `- [YYYY-MM-DD] check: [what went wrong in <10 words]`
