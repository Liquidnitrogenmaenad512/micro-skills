# Step 2: Plan

Design the approach before writing any code or content.

## Actions

1. Break the deliverable into components (sections, functions, files, layers).
2. For each component, note:
   - What it does (one line).
   - What it depends on (inputs from other components).
   - What can go wrong (one known risk).
3. Define the build order (which component first, which last).
4. Check the failure log -- do any past patterns apply? Add them as constraints.

## Gate

Answer YES or NO:

- Does every constraint from Step 1 map to at least one component?
- Is the build order explicit (not "figure it out as I go")?
- Have I checked the failure log?

All YES = proceed to Step 3.
Any NO = revise the plan.
