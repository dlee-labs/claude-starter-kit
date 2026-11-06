#!/bin/bash
# PreToolUse gate for Bash and PowerShell tool calls.
# Reads the tool-call JSON on stdin and blocks (exit 2, reason on stderr) commands that defeat the org's
# safety checks. Deny rules in settings match the command as written; this catches other spellings.
# Runs under bash: macOS/Linux natively, Windows through Git Bash. The hook is set to fail closed, so if this
# script cannot run, the command is blocked rather than waved through.

input="$(cat)"

# Pull the command text out of the JSON without needing jq. Matching on the whole payload would also be
# acceptable; extracting keeps the reasons precise.
cmd="$(printf '%s' "$input" | sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' | head -1)"
[ -z "$cmd" ] && cmd="$input"
# Unescape the common JSON escapes so patterns see what the shell would see.
cmd="$(printf '%s' "$cmd" | sed -e 's/\\"/"/g' -e 's/\\\\/\\/g' -e 's/\\n/ /g' -e 's/\\t/ /g')"
lc="$(printf '%s' "$cmd" | tr 'A-Z' 'a-z')"
# The same text with quoted strings removed, so a flag mentioned inside a commit message is not read as a flag.
bare="$(printf '%s' "$lc" | sed -E "s/\"[^\"]*\"//g; s/'[^']*'//g")"

block() {
  echo "Blocked by the guardrails plugin: $1" >&2
  echo "If this is genuinely needed, the person runs it themselves in their own terminal." >&2
  exit 2
}

# 1. Skipping git hooks (the pre-commit check is the credential and student-data gate).
if printf '%s' "$lc" | grep -Eq 'git([[:space:]]+-c[[:space:]]+[^[:space:]]+)*[[:space:]].*--no-verify'; then
  block "skipping git hooks (--no-verify). Fix what the pre-commit check found instead."
fi
if printf '%s' "$bare" | grep -Eq 'git[[:space:]].*commit([[:space:]]+[^[:space:]]+)*[[:space:]]+-[a-z]*n[a-z]*([[:space:]]|$)'; then
  block "skipping git hooks (git commit -n). Fix what the pre-commit check found instead."
fi
if printf '%s' "$lc" | grep -Eq 'git[[:space:]]+(.*[[:space:]])?-c[[:space:]]*core\.hookspath='; then
  block "overriding core.hooksPath inline, which switches the pre-commit check off for that command."
fi
if printf '%s' "$lc" | grep -Eq 'git[[:space:]]+config.*(--unset[a-z-]*[[:space:]]+core\.hookspath|core\.hookspath[[:space:]]+("|'"'"')?(/dev/null|nul)?("|'"'"')?([[:space:]]|$))' &&
   ! printf '%s' "$lc" | grep -Eq 'core\.hookspath[[:space:]]+("|'"'"')?\.githooks'; then
  block "changing core.hooksPath away from .githooks, which switches the pre-commit check off."
fi

# 2. Force pushes rewrite shared history. --force-with-lease is allowed.
if printf '%s' "$bare" | grep -Eq 'git[[:space:]].*push' &&
   printf '%s' "$bare" | grep -Eq '(--force([[:space:]]|=|$)|[[:space:]]-[a-z]*f[a-z]*([[:space:]]|$)|[[:space:]]\+[^[:space:]]+:)'; then
  block "force push. Use --force-with-lease, or ask the repository owner."
fi

# 3. GAM deletes and wipes, in any spelling of the binary (gam, gam.exe, a full path, & gam in PowerShell).
if printf '%s' "$bare" | grep -Eq '(^|[[:space:]/\\&"'"'"'])gam(\.exe)?[[:space:]"'"'"']+(.*[[:space:]])?(delete|del|purge|wipe|deprovision)([[:space:]]|$)'; then
  block "a GAM delete or wipe. Account deletion runs from the approved action list by the admin's own hand (account-lifecycle skill, stage 4)."
fi

# 4. Recursive deletes at a drive, home or filesystem root.
if printf '%s' "$lc" | grep -Eq 'rm[[:space:]]+(-[a-z]*[[:space:]]+)*-[a-z]*r[a-z]*[[:space:]]+(-[a-z]+[[:space:]]+)*("|'"'"')?(/|~|~/|\$home|/c|c:|c:\\|c:/)("|'"'"')?([[:space:]]|$|\*)'; then
  block "recursive delete at a root folder."
fi
if printf '%s' "$lc" | grep -Eq '(remove-item|rm|del|rd|rmdir)[[:space:]].*-recurse' &&
   printf '%s' "$lc" | grep -Eq '(^|[[:space:]"'"'"'])(c:\\?|c:/|\$home\\?|\$env:userprofile\\?|~\\?|/)("|'"'"')?([[:space:]]|$|\*)'; then
  block "recursive delete at a root folder."
fi

exit 0
