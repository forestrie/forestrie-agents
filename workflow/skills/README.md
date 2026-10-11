# workflow/skills

Team-standard **skills**. Each is a directory containing `SKILL.md`, following
the [Agent Skills](https://agentskills.io) open standard, and becomes the slash
command `/<name>` in Claude Code, Cursor, and pi alike.

| Skill | When |
|-------|------|
| [/setup-clone](./setup-clone/SKILL.md) | New machine or fresh clone |
| [/pre-commit-checks](./pre-commit-checks/SKILL.md) | Before commit |
| [/review-changes](./review-changes/SKILL.md) | PR/stack review, Graphite-aware |
| [/plan-with-linear](./plan-with-linear/SKILL.md) | Planning against a FOR issue |
| [/persist-plan](./persist-plan/SKILL.md) | Persist an approved plan as a canonical `docs/plans/` doc |
| [/triage](./triage/SKILL.md) | Issue triage |
| [/fork-mandate](./fork-mandate/SKILL.md) | Fork a mandate instance against lane-b |
| [/save-status](./save-status/SKILL.md) | Checkpoint work in flight for a fresh session |
| [/rules-of-the-road-review](./rules-of-the-road-review/SKILL.md) | Check a diff/plan against the fundamental invariants in [rules-of-the-road/](../../rules-of-the-road/README.md) — the design-invariant core of a review |

Pinned upstream skills ship separately, as the `mattpocock-skills` plugin from
[vendored/matt-skills/](../../vendored/matt-skills/): `/tdd`, `/diagnose`,
`/grill-with-docs`. Do not edit vendored files in place; add a tracked patch
under `vendored/matt-skills/patches/`.

## Install

These ship in the `forestrie-core` plugin for terminal Claude Code sessions
([harness/claude-code.md](../../harness/claude-code.md)). A subset is committed
into each org repo by `agentfiles sync` ([sync/](../../sync/README.md)) for cloud
sessions and other tools
([harness/other-tools.md](../../harness/other-tools.md)).
