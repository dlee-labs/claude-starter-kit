# Toolbox

Optional tools that have earned a place. Every third-party skill, plugin or MCP server runs with your
permissions: read it before installing, and add it to the sanctioned list (`ai-rules.md` rule 29) before using
it with org data. Facts checked 2026-11; re-check before adopting.

| Tool | What it is | Use it for | Notes |
|---|---|---|---|
| **Matt Pocock skills** | `mattpocock-skills` in Anthropic's official plugin marketplace: `grilling`, `tdd`, `diagnosing-bugs`, `prototype`, `research`, `code-review` | Grilling: Claude interviews you until a plan has no open decisions. Replaces mega-prompts | Start here |
| **skill-creator** | Anthropic's skill for writing and testing skills | Turning a task you did twice into a skill | |
| **Compound Engineering** | `EveryInc/compound-engineering-plugin`: `ce-plan`, `ce-work`, `ce-code-review` | A plan-then-build loop for anything bigger than a script | |
| **Fathom** | Meeting recorder and transcripts | Searchable call notes Claude can work from | Nonprofit seats reported by third parties; confirm with Fathom. Policy decides which meetings may be recorded; never meetings about a specific student |
| **CLI Printing Press** | `mvanhorn/cli-printing-press`: generates a Go CLI and MCP server from an API spec or captured traffic | Giving Claude a safe, scriptable tool for an admin API with no connector | Needs Go |
| **Composio** | Token broker: one sign-in, hundreds of app integrations | Personal productivity | One more processor holding sign-ins. Review before org use; keep send and delete tools off |
| **REA** | `morluto/rea`: reverse-engineering MCP server (binaries, web apps, packet captures) | What does this vendor app or device actually send? Reading a pcap | Only on software and networks you own or are licensed to examine |
| **Impeccable** | Frontend design and critique skill (impeccable.style) | Making an internal page or status dashboard clear and accessible | |
| **HyperFrames** | `heygen-com/hyperframes`, open source: HTML rendered to MP4 | Staff training videos from a script | Needs Node 22+ and FFmpeg |
| **UniFi MCP (community)** | e.g. `sirkirby/unifi-mcp` over the official Integration API | Read-only network review from Claude | Run it on the server that holds the key |
| **GAM** | Open-source Google Workspace admin CLI | Account lifecycle, reports | Its OAuth sign-in is the admin's own; keep it off shared machines |
