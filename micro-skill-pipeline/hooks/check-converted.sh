#!/usr/bin/env bash
# PreToolUse hook: check if a Skill invocation has a converted micro-skill pipeline.
# Notifies the user if a converted version exists, with staleness warning if applicable.

PLUGIN_DATA="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/micro-skill-pipeline}"
REGISTRY="$PLUGIN_DATA/registry.json"

# Exit silently if no registry exists
[ -f "$REGISTRY" ] || exit 0

# Extract skill name from TOOL_INPUT JSON (the "skill" field)
SKILL_NAME=$(echo "$TOOL_INPUT" | grep -o '"skill"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
[ -z "$SKILL_NAME" ] && exit 0

# Check if this skill has a converted pipeline
CONVERTED="$PLUGIN_DATA/converted/$SKILL_NAME"
[ -d "$CONVERTED" ] || exit 0

# Staleness check
STALE_MSG=""
HASH_FILE="$CONVERTED/original-hash.txt"
if [ -f "$HASH_FILE" ]; then
  SOURCE=$(grep -o "\"sourcePath\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" "$REGISTRY" | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
  if [ -n "$SOURCE" ] && [ "$SOURCE" != "scaffolded" ] && [ -f "$SOURCE" ]; then
    OLD_HASH=$(tr -d '[:space:]' < "$HASH_FILE")
    NEW_HASH=$( (sha256sum "$SOURCE" 2>/dev/null || shasum -a 256 "$SOURCE" 2>/dev/null) | cut -d' ' -f1)
    if [ -n "$OLD_HASH" ] && [ -n "$NEW_HASH" ] && [ "$OLD_HASH" != "$NEW_HASH" ]; then
      STALE_MSG=" WARNING: The original skill has been updated since conversion."
    fi
  fi
fi

echo "Micro-skill pipeline: A converted pipeline exists for '$SKILL_NAME'.$STALE_MSG Use /skill-use $SKILL_NAME to run the gated pipeline, or proceed with the original."
