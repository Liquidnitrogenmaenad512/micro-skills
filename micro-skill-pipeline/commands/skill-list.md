---
description: List all converted micro-skill pipelines with staleness status
allowed-tools: Read, Bash, Glob
---

List all converted micro-skill pipelines from the registry.

## Steps

1. Read `${CLAUDE_PLUGIN_DATA}/registry.json`.
   If it doesn't exist, report "No converted skills found. Use /skill-convert or /skill-new to create one."

2. For each entry in `conversions`:
   a. Display: name, convertedAt date, gateCount, pipelineFiles count
   b. If `sourcePath` is not "scaffolded" and file exists:
      - Compute current hash (cross-platform): `(sha256sum "<sourcePath>" 2>/dev/null || shasum -a 256 "<sourcePath>" 2>/dev/null || certutil -hashfile "<sourcePath>" SHA256 2>/dev/null | head -2 | tail -1) | cut -d' ' -f1`
      - Compare to `sourceHash`
      - If different: mark as STALE with warning "Original skill has changed since conversion"
   c. If `sourcePath` file no longer exists: mark as ORPHANED

3. Display summary table:

| Name | Converted | Gates | Files | Status |
|------|-----------|-------|-------|--------|

4. For STALE skills, suggest: "Run /skill-convert <sourcePath> to reconvert."
