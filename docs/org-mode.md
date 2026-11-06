# Org mode: enforce the kit for everyone with managed settings

The one-prompt setup configures one person's machine, and every rule in it can be changed by that person.
**Managed settings** are the org version: an Owner sets them once, every Claude Code session in the org reads
them at startup, and users cannot override them. This is how "default-deny new tools" (`ai-rules.md` rule 29)
stops being a request and becomes a setting. Facts checked against Anthropic's docs 2026-11-05.

## What `TEMPLATES/managed-settings.json` does

| Key | Effect |
|---|---|
| `strictKnownMarketplaces` | Plugins may come only from Anthropic's official marketplace, this kit's repo, and personal skills folders. Adding any other marketplace fails with "blocked by enterprise policy" |
| `extraKnownMarketplaces` | Registers both marketplaces on every machine. `autoUpdate: true` keeps the kit current in the background, so a fix you push reaches everyone without asking them to update |
| `enabledPlugins` | Installs and force-enables `onboarding` and `guardrails` for everyone. Users cannot disable them |
| `disableSideloadFlags` | Blocks loading plugins from a local folder or URL at launch (`--plugin-dir` and friends), which would otherwise bypass the allowlist |
| `permissions.deny` / `permissions.ask` | The kit's guardrail rules, enforced for everyone, for both the Bash and the PowerShell tool |

`it-admin` is deliberately not in `enabledPlugins`: server-managed settings apply to the whole org at once and
cannot target a group, and the IT skills are for IT staff. They install it themselves from the allowed
marketplace.

## Before you turn it on

1. **Fork or copy the kit into a private GitHub repo in your org** and replace `YOUR-GITHUB-ORG` (two places) with the real
   owner. Keep the `strictKnownMarketplaces` and `extraKnownMarketplaces` sources identical: the allowlist
   compares them exactly, and a mismatch means the kit is blocked by its own policy.
2. **Every staff member needs read access to that repo** with git credentials already stored on their
   machine (`gh auth login`, then `gh auth setup-git`). Staff without GitHub accounts: use the alternative
   below instead of `extraKnownMarketplaces`.
3. **Fill in the org rules first** (`CONTEXT/ai-rules.md`, `ai-use-policy.md`), run `tools/build.sh`, and
   push. Everyone receives what you push.

## Turn it on

1. In claude.ai: **Organization settings > Claude Code > Managed settings**. This needs the **Owner** role.
2. Paste the edited JSON and save.
3. On one machine, start a new Claude Code session and run `/status`: the `Setting sources` line should
   include managed settings. Run `/plugin` to see both marketplaces and the force-enabled plugins.
4. In interactive sessions, users see a security approval dialog for the delivered settings and accept it.

Only one managed source applies on a machine by default: if server-managed settings deliver any key, a local
`managed-settings.json` or MDM policy on that machine is ignored for these keys.

## Staff without GitHub accounts

**Organization settings > Plugins & skills** on claude.ai can sync this repo to members' accounts through the
org's own GitHub connection, so individual staff need no git credentials. Requirements: the repository must be
private (your org's copy, not this public one), and plugins cannot have a top-level `bin/` folder (this kit has none). Synced plugins reach Claude Code
as "synced plugins"; they are separate from the managed keys above, so keep `strictKnownMarketplaces` and the
permission rules in managed settings either way.

## What managed settings cannot do

- Target one group (IT vs teachers). One configuration per org; use separate endpoint-managed files or MDM
  profiles per group if you need that.
- Hide `/plugin`. The allowlist plus `disableSideloadFlags` is the nearest equivalent.
- Stop a script that opens files itself from reading a secret. Read deny rules cover Claude's file tools and
  shell file commands Claude Code recognizes (`cat`, `head`, `tail`, `sed`); full OS-level enforcement is the sandbox, which runs on macOS,
  Linux and WSL2, not native Windows.

## Changing it later

Edit the JSON in the same admin page. A bad change applies to everyone at their next session, so test on one
machine with a local `managed-settings.json` first if the change is large.
