---
name: setup-clone
description: Bootstrap a Forestrie engineering checkout on a new machine: clone layout, toolchain, Doppler, and per-repo agent wiring.
when_to_use: The user is on a new machine, says "set up my checkout", "fresh clone", or is missing sibling Forestrie repos.
---

# setup-clone

Bootstrap a Forestrie engineering checkout on a new machine.

## 1. Prerequisites

- macOS or Linux with `git`, `gh`, `mise`, `jq`
- GitHub access to [forestrie](https://github.com/forestrie) org
- Doppler CLI (secrets): `brew install dopplerhq/cli/doppler`

## 2. Clone layout

Recommended sibling layout under `~/Dev/personal/forestrie/`:

```text
forestrie-agents/       # this repo — shared agent guidance
devdocs/                # platform ADRs, ARCs, ops, glossary
product/                # business briefs and decks
canopy/
arbor/
arbor-flux/
forest-1/
univocity/
univocity-tools/
mandate/
matt-skills/            # optional — full upstream skills repo
draft-bryce-cose-receipts-mmr-profile/   # optional — MMR COSE I-D
```

```bash
mkdir -p ~/Dev/personal/forestrie
cd ~/Dev/personal/forestrie
gh repo clone forestrie/forestrie-agents
gh repo clone forestrie/devdocs
gh repo clone forestrie/canopy
gh repo clone forestrie/arbor
# ... other repos as needed for your task
```

Open [forestrie.code-workspace](../../../README.md) (or create one) with the repos you
use daily.

## 3. Secrets

Load team secrets via direnv in the parent folder or `.envrc`:

```bash
# ~/Dev/personal/forestrie/.envrc — canonical secret store (not committed)
export LINEAR_API_KEY=...
```

Doppler projects by repo:

| Repo | Doppler project | Typical config |
|------|-----------------|----------------|
| canopy | `canopy` | `dev`, `prod` |
| univocity | `univocity` | `dev` |
| univocity-tools deploy | `univocity` | per task docs |

Do **not** commit repo-root `.env` files with secrets.

## 4. Per-repo toolchain

| Repo | Setup |
|------|-------|
| canopy | `pnpm install`; local secrets in `packages/apps/canopy-api/.dev.vars` |
| arbor | `cd services/<name> && go test ./...`; see DEVELOPMENT.md |
| univocity | `mise trust && mise install`; Foundry v1.5.1 via foundryup |
| univocity-tools | `mise install`; `bun install` |
| forest-1 | Terraform per DEVELOPMENT.md |
| mandate | `pnpm install` |

## 5. Agent guidance

In each repo, read root `AGENTS.md` (or `forest/agents/AGENTS.md`) before
coding. Common process lives in
[forestrie-agents](https://github.com/forestrie/forestrie-agents).

Platform vocabulary: [devdocs/glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md).

## 6. Git worktrees

Home clones stay on **`main`**. Feature work uses worktrees under
`../.worktrees/` — see each repo's `AGENTS.md` for the exact `git worktree add`
invocation.

For Claude Code, wire up
[harness/claude-code.md § Hooks](../../../harness/claude-code.md#hooks) in each
repo's `.claude/settings.json` so plan execution is blocked outside a
worktree.
