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

Pinned upstream skills install alongside these from
[vendored/matt-skills/](../../vendored/matt-skills/): `/tdd`, `/diagnose`,
`/grill-with-docs`. Do not edit vendored files in place — add an overlay here
under the same name and it will shadow the vendored one.

## Install

```bash
<path-to>/forestrie-agents/bin/forestrie-agents-sync      # run in the repo you're working in
```

That symlinks every skill into `.claude/skills/`, `.cursor/skills/`,
`.agents/skills/`, and `.cursor/commands/`, and excludes those paths via
`.git/info/exclude` so they never get committed. See
[harness/claude-code.md](../../harness/claude-code.md) and
[harness/cursor.md](../../harness/cursor.md).

## Commands are skills now

This directory replaces the former `workflow/commands/`. Claude Code has merged
custom commands into skills — `.claude/commands/deploy.md` and
`.claude/skills/deploy/SKILL.md` both produce `/deploy` — and Cursor reads the
same layout. The directory form is what every harness understands, and it lets
a skill carry its own scripts and reference files.

## Writing one

```text
workflow/skills/<name>/
├── SKILL.md          # frontmatter + instructions
└── scripts/          # optional; reachable as ${CLAUDE_SKILL_DIR}/scripts/...
```

| Frontmatter | Why |
|-------------|-----|
| `name` | Display label — keep equal to the directory name, which sets the command |
| `description` | How the agent decides to auto-apply it. Lead with the use case |
| `when_to_use` | Trigger phrases; appended to `description` in the skill listing |
| `argument-hint` | Autocomplete hint, e.g. `"[FOR-123]"` |
| `disable-model-invocation` | `true` for workflows that must only run on explicit `/name` |
| `allowed-tools` | Pre-approved tools for the invoking turn |

Reference arguments with `$ARGUMENTS` (or `$0`, `$1`) in the body.
