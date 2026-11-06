---
name: unifi-review
description: "Review and optimize a UniFi network from read-only data: AP placement and load, channel and transmit-power plan, band steering, VLAN and firewall layout, client experience, firmware state. Pulls data through the UniFi Integration API (or a configuration export), proposes changes with reasons, and leaves the changes to the admin or to a separately approved script. Use when someone says 'optimize the Wi-Fi', 'UniFi review', 'channel plan', 'why is the gym Wi-Fi slow', 'VLAN design', 'audit the firewall rules', or is designing a new UniFi site."
---

# UniFi review

## Access (facts checked 2026-11; re-check)

- UniFi Network 9.0+ exposes an official **Integration API** authenticated with an API key created in the
  console (Settings, Control Plane, Integrations, or under the account at unifi.ui.com). The key is shown
  once and is scoped to the account and site.
- There is no official Ubiquiti MCP server. Community MCP servers wrap the API (for example
  `sirkirby/unifi-mcp`); some are read-only, some write. Review one before installing, and prefer running it
  on the always-on server that holds the key, reached over SSH, so the key never sits on a laptop.
- Some client actions (block, kick) are not in the official API and need the older private API. Treat those
  as out of scope for automation.

**Start read-only.** If the only key available can write, say so and suggest creating a dedicated
least-privilege admin for the integration.

## Review

1. **Inventory:** sites, gateways, switches, APs with model, firmware, uplink, and PoE budget.
2. **RF:** per AP, channel, width, transmit power, client count, utilization, retries, and neighbor overlap.
   Flag co-channel overlap, 80/160 MHz widths in dense areas, max power everywhere, 2.4 GHz on 40 MHz.
3. **Clients:** experience scores by area and time of day; the spaces with the worst experience.
4. **Segmentation:** VLANs and SSIDs (staff, students, guests, IoT, cameras, management), inter-VLAN rules,
   guest isolation, management plane exposure.
5. **Hygiene:** firmware drift, unused ports enabled, default credentials risk, backups configured.

## Output (`3-final/unifi-review-YYYY-MM-DD.md`)

Lead with the three changes that matter most. For every proposed change: what, from what, to what, why, the
expected effect, and how to roll back. Group by effort (minutes, an afternoon, a project). Include a channel
plan table where relevant.

Changes are made by the admin in the console, or by a script reviewed and approved per `ai-rules.md` rule 16,
one change at a time, during a stated window, with the before-state captured first.

## New sites

For a design (a new building, a campus link), produce a bill of materials with the reasoning per item, a
VLAN plan, a cabling or fiber-versus-wireless-bridge recommendation with what would change the call, and the
open questions only the site owner can answer.
