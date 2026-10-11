# sync

One manifest per Forestrie repo. Each manifest lists what
[`agentfiles sync`](https://github.com/robinbryce/agentfiles/blob/1d31020ea50985fc3023b5896a51e074fe238564/bin/agentfiles)
writes into that repo.

**Public repos** (canopy, arbor, univocity, univocity-tools, mandate) get no
copies. Their manifest only names the `forestrie-agents` marketplace and its
plugins. sync turns that into `.claude/settings.json`: the marketplace, the
enabled plugins, and a SessionStart hook that installs the plugins in Claude
Code cloud sessions (guarded by `CLAUDE_CODE_REMOTE=true`). Cloud sessions do
not act on the marketplace entries alone; the hook does, and the skills are
available in the same session. Each public repo owns its rules of the road
as `.claude/rules/rules-of-the-road-<repo>.md`.

**Private repos** (forest-1, arbor-flux, devdocs) still get a committed
**subset** (rules in `.claude/rules/`, skills in `.agents/skills/`), so the
guidance reaches harnesses that never load plugins. This is under review.

Terminal Claude Code sessions in the forestrie profile get all of this, live,
from the `forestrie-core` plugin either way.

## Apply

[`agentfiles sync`](https://github.com/robinbryce/agentfiles/blob/8b60ee4a/bin/agentfiles)
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
| `.claude/settings.json` | `marketplace` and `plugin` lines, merged into what is there, plus the cloud install hook |
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

| Manifest | Copies | Rules of the road | Language rules | Glossary skill |
|----------|--------|-------------------|----------------|----------------|
| [canopy](./canopy.manifest) | none | owned by canopy | from the plugin | from the plugin |
| [arbor](./arbor.manifest) | none | owned by arbor | from the plugin | from the plugin |
| [univocity](./univocity.manifest) | none | owned by univocity | from the plugin | from the plugin |
| [univocity-tools](./univocity-tools.manifest) | none | owned by univocity-tools | from the plugin | from the plugin |
| [mandate](./mandate.manifest) | none | owned by mandate | from the plugin | from the plugin |
| [forest-1](./forest-1.manifest) | subset | platform, forest-1 | go-task | `arc-infra` |
| [arbor-flux](./arbor-flux.manifest) | subset | platform, arbor-flux | none | `arc-infra` |
| [devdocs](./devdocs.manifest) | subset | platform | none | `arc-company` |

Every manifest enables the `forestrie-core` and `mattpocock-skills` plugins.
The private-repo subsets carry the common rules (`commit-conventions`,
`branch-naming`, `breaking-changes`, `plan-docs`, `adr-format`) and the
`review-changes`, `rules-of-the-road-review`, `pre-commit-checks`, `save-status`
and `persist-plan` skills; devdocs gets `plan-with-linear` in place of the
code-review skills.
