#!/bin/bash
# Self-test for the guardrails hook. Feeds each case in cases.tsv to check-command.sh as tool-call JSON and
# compares BLOCK (exit 2) or pass (exit 0) with the expectation. Nothing in cases.tsv is executed.
# Run after any change to check-command.sh: bash plugins/guardrails/tests/run.sh
cd "$(dirname "$0")"
hook=../scripts/check-command.sh
fails=0; total=0
while IFS=$'\t' read -r expected tool command; do
  case "$expected" in ''|\#*) continue ;; esac
  total=$((total + 1))
  esc=$(printf '%s' "$command" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')
  printf '{"tool_name":"%s","tool_input":{"command":"%s"}}' "$tool" "$esc" | bash "$hook" >/dev/null 2>&1
  rc=$?
  if [ $rc -eq 2 ]; then got=BLOCK; elif [ $rc -eq 0 ]; then got=pass; else got="error($rc)"; fi
  if [ "$got" != "$expected" ]; then
    fails=$((fails + 1)); echo "FAIL expected $expected got $got: [$tool] $command"
  fi
done < cases.tsv
echo "$((total - fails))/$total cases passed"
[ $fails -eq 0 ]
