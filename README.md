# forestrie-agents

Shared agent guidance for **Forestrie** org development. Harness-neutral
markdown for Cursor, Claude Code, and other coding agents.

**Not for Just Games / SentientDogs work** — that lives in
[just-agents](https://github.com/SentientDogs/just-agents).

## What lives here

| Path | Purpose |
|------|---------|
| [AGENTS.md](./AGENTS.md) | Agent bootstrap router — read first |
| [arc-context/](./arc-context/) | Minimal domain glossaries + links |
| [workflow/](./workflow/) | Team-standard [skills](./workflow/skills/) (= slash commands) and [rules](./workflow/rules/) |
| [bin/](./bin/) | [`forestrie-agents-sync`](./bin/forestrie-agents-sync) — installs skills into every harness |
| [vendored/](./vendored/) | Pinned third-party agent content |
| [incubator/](./incubator/) | Provisional per-engineer proposals |
| [harness/](./harness/) | Per-harness install notes |

## Install as Claude Code plugins

This repo is a Claude Code plugin marketplace (`.claude-plugin/marketplace.json`)
with two plugins:

| Plugin | Provides |
|--------|----------|
| `forestrie-core` | team workflow skills (`/forestrie-core:review-changes`, `…:triage`, `…:save-status`, …), team rules as path-scoped background skills, the `require-worktree` hook |
| `mattpocock-skills` | pinned upstream `tdd`, `diagnose`, `grill-with-docs` with tracked patches |

```bash
claude plugin marketplace add forestrie/forestrie-agents     # or a local checkout path
claude plugin install forestrie-core@forestrie-agents
claude plugin install mattpocock-skills@forestrie-agents
```

A marketplace added from a local checkout loads plugins in place, so edits are
live after `/reload-plugins`. Cloud sessions never load plugins; a repo that
needs these skills there commits a synced copy (see
[agentfiles plan 2610-01](https://github.com/robinbryce/agentfiles/tree/robin/agent-config-reorg/docs/plans/plan-2610-01-agent-config-reorg)).

## Layer model

1. **Repo overlay** — `forest/agents/` in each Forestrie repo (wins on conflict)
2. **Common workflow** — this repo's `workflow/`
3. **Vendored** — upstream skills; extend via overlay, do not edit in place
4. **Incubator** — opt-in only; never default

## Promotion policy

Engineers commit provisional guidance under `incubator/<github-login>/`.
To promote to team standard:

1. Sanitize for Forestrie (no personal or external-org references)
2. Open a PR moving content into `workflow/` or `arc-context/`
3. Update indexes in `AGENTS.md` and relevant README files
4. Add harness sync notes if Cursor/Claude paths change

PRs that promote incubator content should mention `agent-guidance-promotion`
in the description.

## Clone layout

Recommended sibling checkout under `~/Dev/personal/forestrie/`:

```text
forestrie-agents/     # this repo
canopy/
arbor/
arbor-flux/
forest-1/
univocity/
univocity-tools/
mandate/
devdocs/
product/
matt-skills/          # full upstream skills (optional sibling)
```

## Per-repo setup

Run this once in each Forestrie repo you work in:

```bash
~/Dev/personal/forestrie/forestrie-agents/bin/forestrie-agents-sync
```

It symlinks every skill in this repo into `.claude/skills/`, `.cursor/skills/`,
`.agents/skills/`, and `.cursor/commands/`, so `/review-changes`,
`/pre-commit-checks`, `/save-status` and the rest work as slash commands in
Claude Code, Cursor, and pi from one canonical source. Generated links are
added to `.git/info/exclude`, so they never appear in `git status`.

Install per-repo, not machine-wide: Claude Code resolves personal skills
*above* project skills, so a global skill would shadow the team's.

A repo may add its own overlay at `forest/agents/skills/<name>/SKILL.md`; it is
applied last and shadows a team or vendored skill of the same name. Many repos
also use root **`AGENTS.md`** as a thin router. See
[harness/cursor.md](./harness/cursor.md) and
[harness/claude-code.md](./harness/claude-code.md).

## Related repos

| Repo | Role |
|------|------|
| [devdocs](https://github.com/forestrie/devdocs) | Platform ADRs, ARCs, ops runbooks, glossary |
| [product](https://github.com/forestrie/product) | Business briefs, decks, product plans |
| [canopy](https://github.com/forestrie/canopy) | SCRAPI Workers API |
| [arbor](https://github.com/forestrie/arbor) | Go microservices (ranger, sealer, custodian) |
| [forest-1](https://github.com/forestrie/forest-1) | GKE platform (Terraform + Flux bootstrap) |
| [arbor-flux](https://github.com/forestrie/arbor-flux) | GitOps manifests for GKE |
| [univocity](https://github.com/forestrie/univocity) | On-chain checkpoint contracts |
| [univocity-tools](https://github.com/forestrie/univocity-tools) | Contract build/deploy CLIs |
| [mandate](https://github.com/forestrie/mandate) | BYOK operator UI and delegation |

## Linear

Team key: **FOR** (Forestrie workspace). Linear MCP uses Cursor OAuth;
direct API use may load `LINEAR_API_KEY` from `~/Dev/personal/forestrie/.envrc`
when present.
