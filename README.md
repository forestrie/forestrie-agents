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
| [workflow/](./workflow/) | Team-standard commands, skills, rules |
| [vendored/](./vendored/) | Pinned third-party agent content |
| [incubator/](./incubator/) | Provisional per-engineer proposals |
| [harness/](./harness/) | Per-harness install notes |

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

Each Forestrie repo should contain (or point at):

```text
forest/agents/
├── AGENTS.md
├── commands/
├── skills/
└── rules/
```

Many repos already use root **`AGENTS.md`** as a thin router — that is
equivalent. See [harness/cursor.md](./harness/cursor.md) for syncing
`.cursor/` from `forest/agents/`.

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
