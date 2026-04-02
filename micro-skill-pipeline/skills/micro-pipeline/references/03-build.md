# Step 3: Build

Execute the plan from Step 2. Build components in defined order.

## Actions

1. Build each component in order.
2. After each component, micro-check:
   - Does it match its one-line description from the plan?
   - Does it handle the risk identified in the plan?
3. If a component fails its micro-check, fix it before starting the next one.
4. Run any available linters, type checks, or tests after building code components.

## Gate

Answer YES or NO:

- Have all components from the plan been built?
- Did every component pass its micro-check?
- Does the assembled output match the deliverable description from Step 1?

All YES = proceed to Step 4.
Any NO = identify which component failed and rebuild it.
