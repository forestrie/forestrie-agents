# forestrie-agents

Shared agent guidance for the **Forestrie** org, shipped two ways:

- as Claude Code **plugins** (this repo is the `forestrie-agents` marketplace),
  for terminal sessions in the forestrie profile;
- as a **committed layer** that [`agentfiles sync`](./sync/README.md) copies
  into each org repo, for cloud sessions and other harnesses.

Agents working in an org repo do not read this file. They get the skills and
rules through those two channels. This file is for changing this repo.

## Org map

| Repo | Visibility | What | Rules of the road | Glossary skill |
|------|------------|------|-------------------|----------------|
| [canopy](https://github.com/forestrie/canopy) | public | SCRAPI Workers API | [canopy](./rules-of-the-road/canopy.md) | [arc-canopy](./arc-context/arc-canopy/SKILL.md) |
| [arbor](https://github.com/forestrie/arbor) | public | Go services on GKE | [arbor](./rules-of-the-road/arbor.md) | [arc-arbor](./arc-context/arc-arbor/SKILL.md) |
| [univocity](https://github.com/forestrie/univocity) | public | On-chain checkpoint contracts | [univocity](./rules-of-the-road/univocity.md) | [arc-univocity](./arc-context/arc-univocity/SKILL.md) |
| [univocity-tools](https://github.com/forestrie/univocity-tools) | public | Contract build and deploy CLIs | [univocity-tools](./rules-of-the-road/univocity-tools.md) | [arc-tools](./arc-context/arc-tools/SKILL.md) |
| [mandate](https://github.com/forestrie/mandate) | public | BYOK operator UI and delegation | [mandate](./rules-of-the-road/mandate.md) | [arc-mandate](./arc-context/arc-mandate/SKILL.md) |
| [forest-1](https://github.com/forestrie/forest-1) | private | GKE platform (Terraform + Flux) | [forest-1](./rules-of-the-road/forest-1.md) | [arc-infra](./arc-context/arc-infra/SKILL.md) |
| [arbor-flux](https://github.com/forestrie/arbor-flux) | private | GitOps manifests | [arbor-flux](./rules-of-the-road/arbor-flux.md) | [arc-infra](./arc-context/arc-infra/SKILL.md) |
| [devdocs](https://github.com/forestrie/devdocs) | private | ADRs, ARCs, runbooks | [platform](./rules-of-the-road/platform.md) only | [arc-company](./arc-context/arc-company/SKILL.md) |
| [protocol](https://github.com/forestrie/protocol) | public | Protocol spec, glossary, platform rules (`P1`–`P16`) | owns platform | — |
| [product](https://github.com/forestrie/product) | private | Briefs, decks, product plans | — | [arc-company](./arc-context/arc-company/SKILL.md) |

Each row with a rules-of-the-road file has a [sync manifest](./sync/). The
clone layout on a workstation is in [workspace/AGENTS.md](./workspace/AGENTS.md).

**Visibility matters.** This repo is private, and synced copies land in public
repos. Write nothing here that cannot be public: no secrets, no customer
names, no internal hostnames.

## Layout

| Path | What | Ships as |
|------|------|----------|
| [workflow/skills/](./workflow/skills/) | Team skills (`/review-changes`, `/triage`, …) | plugin `forestrie-core`; subset synced |
| [workflow/rules/](./workflow/rules/) | Team rules: `user-invocable: false`, often `paths:`-scoped | plugin `forestrie-core`; synced to `.claude/rules/` |
| [arc-context/](./arc-context/) | Domain glossaries as `arc-*` background skills | plugin `forestrie-core`; one synced per repo |
| [rules-of-the-road/](./rules-of-the-road/) | Fundamental invariants, cited by id (`P4`, `canopy/C3`) | synced to `.claude/rules/rules-of-the-road-*.md` |
| [sync/](./sync/) | Per-repo manifests for `agentfiles sync` | — |
| [vendored/matt-skills/](./vendored/matt-skills/) | Upstream `tdd`, `diagnose`, `grill-with-docs` with tracked patches | plugin `mattpocock-skills` |
| [harness/](./harness/) | Claude Code and other-tool notes; the `require-worktree` hook | hook ships in `forestrie-core` |
| [workspace/](./workspace/) | Workstation `AGENTS.md`, installed by `agentfiles bootstrap` | — |
| [incubator/](./incubator/) | Per-engineer drafts; never loaded by default | — |

## Contributing

**Add or change a skill or rule.** Edit `workflow/skills/<name>/SKILL.md` or
`workflow/rules/<name>/SKILL.md`. Frontmatter must be valid YAML: quote any
value that contains `: `. A rule sets `user-invocable: false`, and `paths:`
when it applies to certain files only.

**Add a glossary.** Create `arc-context/arc-<name>/SKILL.md` with
`user-invocable: false` and a `description` that names the work it covers.

**Change a rule of the road.** Keep it one imperative, one-sentence why, one
link (see [rules-of-the-road/README.md](./rules-of-the-road/README.md)). Use
absolute GitHub links only, since the file is copied into other repos.

**Check before opening a PR:**

```bash
claude plugin validate .
npx skills@1.7.2 add . --list          # every skill listed, none "Skipped"
```

**After merge, re-sync** each affected repo and commit there:

```bash
agentfiles sync <repo> --manifest sync/<repo>.manifest
agentfiles doctor --repo <repo>        # "no drift"
```

**Promote from the incubator.** Sanitise for Forestrie, move it into
`workflow/` or `arc-context/`, update the indexes, and mention
`agent-guidance-promotion` in the PR.

**Linear:** team key **FOR**.
