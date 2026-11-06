#!/bin/bash
# Sync CONTEXT/ into the onboarding plugin's references and build the ambient CLAUDE.md template.
# CONTEXT/ is the only place these documents are edited. Run after any change to CONTEXT/, then commit.
set -euo pipefail
cd "$(dirname "$0")/.."
STAMP="$(date +%F)"
REFS="plugins/onboarding/skills/welcome/references"
mkdir -p "$REFS"

for f in CONTEXT/*.md; do
  name="$(basename "$f")"
  { printf '<!-- synced: %s from claude-starter-kit %s. Build artifact, do not hand-edit. -->\n' "$STAMP" "$f"
    cat "$f"; } > "$REFS/$name"
done

# Remove references whose CONTEXT source is gone (hand-authored files are listed to survive).
for existing in "$REFS"/*; do
  name="$(basename "$existing")"
  case "$name" in personal-files-schema.md|CLAUDE.md.template) continue ;; esac
  [ -f "CONTEXT/$name" ] || { rm -f "$existing"; echo "pruned $name"; }
done

{
  printf '<!-- deployed-from: claude-starter-kit, built %s\n' "$STAMP"
  printf '     Generated from CONTEXT/ai-rules.md + CONTEXT/working-with-claude.md. Do not hand-edit:\n'
  printf '     change the source, rebuild, and re-run /welcome. -->\n\n'
  printf '# [ORG NAME] — Claude working rules\n\n'
  printf 'Two parts, both in force. Part 1 is what may and may not be done with org data and systems. Part 2\n'
  printf 'is posture, output and where files go. Referenced documents live in this folder'"'"'s CONTEXT/.\n\n---\n\n'
  cat CONTEXT/ai-rules.md
  printf '\n\n---\n\n'
  cat CONTEXT/working-with-claude.md
} > "$REFS/CLAUDE.md.template"

echo "built $REFS (stamp $STAMP)"
claude plugin validate . >/dev/null 2>&1 && echo "marketplace valid" || echo "WARN: claude plugin validate failed or unavailable"
