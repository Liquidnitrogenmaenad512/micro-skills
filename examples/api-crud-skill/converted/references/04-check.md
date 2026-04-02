# Step 4: Check

Hard gate. Assume there are problems. Find them.
Answer every question YES or NO. "Mostly yes" = NO.

## Universal Checks

1. Does the output match the deliverable from Step 1? YES/NO
2. Are all constraints from Step 1 satisfied? YES/NO
3. Does every element serve a purpose (no dead code, no placeholders)? YES/NO
4. Is the output usable as-is with no manual fixes? YES/NO
5. Does the code run without errors? Did linting/tests pass? YES/NO

## Domain Checks

Load `check-gates.md` and answer every question there.

## Failure Log

6. Re-read `failure-log.md`. Does the output violate any pattern? YES/NO

## On Failure

- For each NO: state what is wrong in one sentence.
- Fix each issue.
- Re-run this entire checklist from question 1.
- After passing: append a pattern to `failure-log.md`:
  `- [YYYY-MM-DD] check: [what went wrong in <10 words]`
