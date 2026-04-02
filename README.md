# micro-skill-pipeline

**Stop writing 200-line skills that Claude skims. Split them into 5 small steps with hard gates.**

## The Problem

Large SKILL.md files (100-300+ lines) get partially read, partially followed, and produce inconsistent output. Claude skips sections, forgets constraints, and rationalizes "good enough" as done. There's no checkpoint, no verification, no learning from past mistakes.

## The Solution

This plugin converts any monolithic skill into a **5-stage gated pipeline**:

| Stage | What happens | Gate |
|-------|-------------|------|
| 1. Scope | Extract constraints from the request | Can I state the deliverable in one sentence? |
| 2. Plan | Design the approach, check failure log | Does every constraint map to a component? |
| 3. Build | Execute with micro-checks per component | Did every component pass its micro-check? |
| 4. Check | **Hard gate** -- binary YES/NO questions | ALL questions YES. Any NO = fix first. |
| 5. Deliver | Clean up and present output | Output in final location? Summary concise? |

Each stage is a separate file under 40 lines. Claude reads one at a time, completes it, passes its gate, then reads the next. **No skipping ahead.**

The Check step is the hard gate. It contains specific, binary questions -- not "ensure quality" but "does every endpoint have error handling? YES or NO." Any NO means fix before proceeding.

A **failure log** compounds learnings over time. Every time a Check gate catches something, the pattern gets recorded. Next run, Claude reads those patterns before starting.

## Installation

### From local directory

```bash
claude install-plugin /path/to/micro-skill-pipeline
```

### From GitHub marketplace

```bash
# Add the marketplace (one-time)
claude plugin marketplace add github:stevesolun/micro-skill-pipeline

# Install the plugin
claude plugin install micro-skill-pipeline
```

## Quick Start

### 1. Convert an existing skill

```
/skill-convert api-design
```

Just pass the skill name -- the plugin searches your project skills, user skills, agent skills, and installed plugins to find it automatically. You can also pass a full path if you prefer:

```
/skill-convert ~/.claude/skills/api-design/SKILL.md
```

This reads the monolith, splits it into ~10 files (each under 40 lines), extracts YES/NO gate questions, and seeds a failure log.

### 2. Use the converted pipeline

```
/skill-use api-design
```

Claude now runs through Scope -> Plan -> Build -> Check -> Deliver with gates between each step. If the original skill has been updated since conversion, you'll be asked whether to reconvert.

### 3. Or just use any skill normally

When you invoke a skill that has a converted pipeline, a hook notifies you:

```
> Micro-skill pipeline: A converted pipeline exists for 'api-design'.
> Use /skill-use api-design to run the gated pipeline, or proceed with the original.
```

You choose -- the original is never modified or overridden.

## Commands

| Command | What it does |
|---------|-------------|
| `/skill-convert <name-or-path>` | Convert a monolithic skill into a gated pipeline |
| `/skill-use <name>` | Activate and run a converted pipeline |
| `/skill-new <name>` | Scaffold a blank pipeline from scratch |
| `/skill-check [name]` | Run the Check gate against current work |
| `/skill-list` | List all converted skills with staleness status |
| `/skill-fail <desc>` | Log a failure pattern to both project and skill logs |
| `/skill-bypass <name>` | Use the original skill, skipping the pipeline |

### `/skill-convert <name-or-path>`

Convert a monolithic skill into a micro-skill pipeline. Pass a skill name or full path -- the plugin auto-discovers the skill location.

```
/skill-convert api-design                              # by name (auto-finds it)
/skill-convert ~/.claude/skills/my-big-skill/SKILL.md   # by path
```

Skill search order: project skills -> user skills -> agent skills -> installed plugins. If multiple matches are found, you pick which one.

What it does:
1. Reads the source skill, computes SHA256 hash
2. Classifies sections: instructions -> Build, checks/avoid -> Gate questions, reference data -> separate files
3. Creates the pipeline in persistent storage (`${CLAUDE_PLUGIN_DATA}/converted/<name>/`)
4. Extracts YES/NO gate questions into `check-gates.md`
5. Seeds `failure-log.md` with "avoid" items from the original
6. Registers in `registry.json` for staleness tracking

### `/skill-use <name>`

Activate a converted pipeline. This is how you run a converted skill instead of the original.

```
/skill-use api-design
```

What happens:
1. **Staleness check** -- compares the original skill's current hash to the stored hash
2. If the original has been updated since conversion, asks: "Reconvert to pick up changes?" (your failure-log is preserved)
3. If you agree, reconverts automatically; if you decline, uses the existing pipeline
4. **Loads the pipeline** -- runs through Scope -> Plan -> Build -> Check -> Deliver with gates

### `/skill-new <name>`

Scaffold a blank pipeline from scratch. Asks for a description, trigger condition, and 3-5 domain-specific gate questions.

```
/skill-new api-reviewer
```

### `/skill-check [skill-name]`

Run the Check gate against current work. Merges gates from three sources:
- **Universal** (7 built-in questions)
- **Project-level** (`check-gates.md` in project root)
- **Skill-level** (from the converted skill's directory)

```
/skill-check frontend-design
```

### `/skill-list`

Show all converted skills with staleness detection:

```
| Name             | Converted  | Gates | Files | Status |
|------------------|------------|-------|-------|--------|
| frontend-design  | 2026-04-02 | 8     | 7     | OK     |
| api-scaffold     | 2026-03-15 | 5     | 9     | STALE  |
```

STALE = the original skill has changed since conversion. Run `/skill-convert` again or let `/skill-use` handle the reconversion.

### `/skill-bypass <name>`

Use the original skill directly, skipping the pipeline. After completion, reminds you to run `/skill-check` to verify output against the pipeline's gate questions.

```
/skill-bypass api-design
```

### `/skill-fail <description>`

Log a failure pattern (under 10 words). Gets appended to both project-level and skill-level failure logs.

```
/skill-fail forgot to validate input params
```

## Usage Example: Full Workflow

```
# 1. You have a big skill that Claude keeps getting wrong
/skill-convert api-design

# Output:
#   Original: 523 lines in 1 file
#   Pipeline: 10 files, max 30 lines each, 12 gate questions
#   Review the gate questions in check-gates.md

# 2. Next time you need API design work, use the pipeline
/skill-use api-design

# Claude now runs:
#   Step 1 (Scope): reads 01-scope.md, identifies constraints, passes gate
#   Step 2 (Plan): reads 02-plan.md, maps endpoints, passes gate
#   Step 3 (Build): reads 03a + 03b, implements with micro-checks
#   Step 4 (Check): answers 12 YES/NO questions -- finds missing Location header
#     -> fixes it, re-runs checklist, appends "missing Location header" to failure-log.md
#   Step 5 (Deliver): cleans up, presents summary

# 3. Months later, the original skill gets updated by its author
/skill-use api-design

# Output:
#   "The original skill has changed since conversion. Reconvert?"
#   -> Yes: reconverts with updated content, preserves your failure-log
#   -> No: uses existing pipeline as-is

# 4. Check your inventory anytime
/skill-list

# 5. If a gate catches a new issue, it's logged automatically
# Or log one manually:
/skill-fail returned 200 for DELETE instead of 204
```

## Project-Level Customization

Drop these files in your project root:

- **`check-gates.md`** -- domain-specific YES/NO gate questions (merged with skill-level gates at Check time)
- **`failure-log.md`** -- grows automatically, read before every pipeline run

## How Converted Skills Are Stored

Converted pipelines live in the plugin's persistent data directory (`${CLAUDE_PLUGIN_DATA}/converted/`):

```
converted/
└── my-skill/
    ├── SKILL.md              # Pipeline orchestrator (~30 lines)
    ├── check-gates.md        # Domain-specific YES/NO gates
    ├── failure-log.md        # Learned patterns
    ├── original-hash.txt     # SHA256 for staleness detection
    └── references/
        ├── 01-scope.md       # Extract constraints
        ├── 02-plan.md        # Design approach
        ├── 03-build.md       # Execute with micro-checks
        ├── 04-check.md       # Hard gate
        └── 05-deliver.md     # Finalize
```

This survives plugin updates. A `registry.json` indexes all conversions. The original skill is **never modified** -- the pipeline is a separate copy.

## Key Principles

1. **Small files get read.** Every reference file stays under 40 lines.
2. **Specific gates beat vague validation.** "Does every endpoint have auth?" catches bugs. "Ensure quality" catches nothing.
3. **Failure patterns compound.** The failure log is the system's long-term memory.
4. **Gates force honesty.** YES/NO with "any NO = fix before proceeding" removes the escape hatch.
5. **Fresh eyes catch more.** The `gate-checker` agent reviews output with zero build context.

## Example

See [examples/api-crud-skill/](examples/api-crud-skill/) for a full before/after conversion of a 256-line skill into a micro-skill pipeline, with a walkthrough of each pipeline stage.

## Design

See [docs/plans/2026-04-02-micro-skills-plugin-design.md](docs/plans/2026-04-02-micro-skills-plugin-design.md) for architecture decisions.

## Citation

If you use this plugin or build on it, please cite this repository:

```
Steve Solun, "micro-skill-pipeline" (2026), GitHub repository
https://github.com/stevesolun/micro-skill-pipeline
```

## License

MIT

---

<sub>Inspired by [this LinkedIn post](https://tinyurl.com/4jpaaf9p).</sub>
