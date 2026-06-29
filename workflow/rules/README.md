# workflow/rules

Team-standard rules. Default: **requestable** (load when relevant). Repo overlays
in `forest/agents/rules/` may set harness-specific `alwaysApply`.

Many Forestrie repos already duplicate promoted rules in `.cursor/rules/*.mdc`.
This directory is the **canonical source** — prefer syncing from here rather
than editing copies in place.

| Rule | Scope |
|------|-------|
| [branch-naming.md](./branch-naming.md) | All Forestrie repos — Linear **FOR** |
| [linear-mcp-forestrie.md](./linear-mcp-forestrie.md) | Linear MCP identity checks |
| [go-task-over-shell.md](./go-task-over-shell.md) | Task-based repos |
| [breaking-changes.md](./breaking-changes.md) | All repos |
| [commit-conventions.md](./commit-conventions.md) | All repos |
| [source-order-call-graph.md](./source-order-call-graph.md) | TS/JS repos |
| [types-single-responsibility.md](./types-single-responsibility.md) | TS monorepos (+ Go/Solidity variants in repo overlays) |
| [typescript-comments.md](./typescript-comments.md) | TS repos (canopy, mandate, tools) |
| [go-comments.md](./go-comments.md) | Go repos (arbor) |
| [solidity-comments.md](./solidity-comments.md) | Solidity (univocity) |

Repo-specific rules (e2e Doppler, citty CLI, terraform layout, yaml manifests)
remain in each repo's `.cursor/rules/` — link from repo `AGENTS.md`, do not
duplicate here unless promoting team-wide.
