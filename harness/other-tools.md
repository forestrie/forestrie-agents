# Other tools: Cursor, Codex, pi and the rest

Every harness here reads the same two things: `AGENTS.md` and `SKILL.md`
directories. There are no per-harness adapters to keep in sync.

## In a synced repo (the default)

[`agentfiles sync`](../sync/README.md) commits `.agents/skills/<name>/`, the
open [Agent Skills](https://agentskills.io) path.

| Tool | Reads |
|------|-------|
| Cursor | `AGENTS.md`, `.agents/skills/`, `.claude/skills/`, its own `.cursor/rules/` |
| Codex | `AGENTS.md`, `.agents/skills/` |
| pi | `AGENTS.md` (walks up to the workspace one), `.agents/skills/` |
| anything else | `AGENTS.md`; point it at `.agents/skills/` by hand |

`.claude/rules/` is Claude Code only. Rules that must reach another tool also
need a skill (every `workflow/rules/` file already is one) or a tool-native
file such as a Cursor `.mdc`.

Terminal parity for pi: `agentfiles bootstrap` links the plugin skills into
`~/.pi-<profile>/skills/`.

## In a repo that is not synced yet

[`bin/forestrie-agents-sync`](../bin/forestrie-agents-sync) symlinks every
skill and rule from this checkout into `.claude/skills/`, `.cursor/skills/`,
`.agents/skills/` and `.cursor/commands/`, and lists the links in
`.git/info/exclude` so they are never committed.

```bash
~/Dev/personal/forestrie/forestrie-agents/bin/forestrie-agents-sync          # from the repo
~/Dev/personal/forestrie/forestrie-agents/bin/forestrie-agents-sync --prune  # drop removed skills
```

Do not run it in a synced repo: it writes into the same directories as the
committed layer. Once a repo has a [sync manifest](../sync/), use
`agentfiles sync` there.

### Cursor rule shims

`forestrie-agents-sync --cursor-rules` writes `.cursor/rules/<name>.mdc` shims:
`paths:` becomes Cursor's `globs:`, and the body is a one-line pointer at the
`SKILL.md`. It never overwrites a `.mdc` it did not write, so the hand-written
copies tracked in canopy, univocity and mandate are skipped with a warning.
Retire one by deleting it and re-running.

## Without any of the above

Any agent that reads markdown can use this repo directly: read the working
repo's `AGENTS.md`, then the one [`arc-*` glossary](../arc-context/) and
[rules-of-the-road](../rules-of-the-road/) file that match the task, then only
the skill the user invoked.
