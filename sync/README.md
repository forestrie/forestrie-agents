# sync

One manifest per Forestrie repo. Each manifest lists the part of this repo that
gets **committed into** that repo, so the guidance still reaches sessions that
never load plugins: Claude Code cloud sessions, and harnesses other than Claude
Code (Codex, Cursor, pi, and others that read `.agents/skills/`).

Terminal Claude Code sessions in the forestrie profile already get all of this,
live, from the `forestrie-core` plugin. The committed copy is a deliberate
**subset**, so a repo carries only its own glossary and rules of the road.

## Apply

[`agentfiles sync`](https://github.com/robinbryce/agentfiles/blob/robin/agent-config-reorg/bin/agentfiles)
reads a manifest and writes the committed layer:

```bash
agentfiles sync ~/Dev/personal/forestrie/canopy \
  --manifest ~/Dev/personal/forestrie/forestrie-agents/sync/canopy.manifest
agentfiles doctor --repo ~/Dev/personal/forestrie/canopy   # reports drift
```

| Writes | From |
|--------|------|
| `.claude/rules/<dest>.md` | each `rule` line (a plain copy) |
| `.agents/skills/<name>/` | each `skill` line, vendored with `npx skills add` |
| `.claude/skills/<name>` | a relative symlink to `../../.agents/skills/<name>` |
| `.claude/settings.json` | `marketplace` and `plugin` lines, merged into what is there |
| `.agents/skills/.synced-from` | the source repo, its SHA and the manifest path |

Commit all of these in the target repo. Edit the content **here**, then re-run the
sync. Never edit the copies in place.

## Format

One directive per line. `#` starts a comment.

| Directive | Meaning |
|-----------|---------|
| `source <dir>` | Where skills and rules come from. A relative path resolves against the manifest's directory, so `..` is this repo. |
| `agents <a,b,c>` | `npx skills` agent ids (default `claude-code,codex,cursor`) |
| `rule <src> [dest]` | Copy `<src>` (relative to `source`) to `.claude/rules/<dest>` |
| `skill <name> …` | Vendor these skills from `source` |
| `marketplace <name> <owner/repo>` | Add a GitHub marketplace to `extraKnownMarketplaces` |
| `plugin <plugin@marketplace>` | Enable a plugin in `enabledPlugins` |

## What each manifest carries

| Manifest | Rules of the road | Language rules | Glossary skill |
|----------|-------------------|----------------|----------------|
| [canopy](./canopy.manifest) | platform, canopy | TypeScript | `arc-canopy` |
| [arbor](./arbor.manifest) | platform, arbor | Go, go-task | `arc-arbor` |
| [univocity](./univocity.manifest) | platform, univocity | Solidity, go-task | `arc-univocity` |
| [univocity-tools](./univocity-tools.manifest) | platform, univocity-tools | TypeScript | `arc-tools` |
| [mandate](./mandate.manifest) | platform, mandate | TypeScript | `arc-mandate` |
| [forest-1](./forest-1.manifest) | platform, forest-1 | go-task | `arc-infra` |
| [arbor-flux](./arbor-flux.manifest) | platform, arbor-flux | none | `arc-infra` |
| [devdocs](./devdocs.manifest) | platform | none | `arc-company` |

Every manifest enables the `forestrie-core` and `mattpocock-skills` plugins for
terminal sessions, and carries the common rules (`commit-conventions`,
`branch-naming`, `breaking-changes`, `plan-docs`, `adr-format`). Each code repo
gets the `review-changes`, `rules-of-the-road-review`, `pre-commit-checks`,
`save-status` and `persist-plan` skills. devdocs gets `plan-with-linear` in place
of the code-review skills.
