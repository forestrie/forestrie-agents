# workflow/rules

Team-standard rules. Each is a `<name>/SKILL.md` directory, exactly like a
[skill](../skills/) — because on every current harness a rule *is* a skill.
What distinguishes them is frontmatter, not location:

| Frontmatter | Effect |
|-------------|--------|
| `user-invocable: false` | Background knowledge; hidden from the `/` menu |
| `paths: [...]` | Loaded **only** when the session touches a matching file |
| `description` / `when_to_use` | How the agent decides to apply an unscoped rule |

They ship as background skills in the `forestrie-core` plugin. A repo's
[sync manifest](../../sync/README.md) also copies the ones it needs into
`.claude/rules/<name>.md`, where Claude Code reads the same `paths:` field.

## Path-scoped — load only when you touch the code they govern

| Rule | `paths:` |
|------|----------|
| [typescript-comments](./typescript-comments/SKILL.md) | `**/*.ts`, `**/*.tsx`, `**/*.mts`, `**/*.cts` |
| [types-single-responsibility](./types-single-responsibility/SKILL.md) | `**/*.ts`, `**/*.tsx`, `**/*.mts`, `**/*.cts` |
| [source-order-call-graph](./source-order-call-graph/SKILL.md) | `**/*.ts`, `**/*.tsx`, `**/*.js`, `**/*.jsx`, … |
| [go-comments](./go-comments/SKILL.md) | `**/*.go` |
| [solidity-comments](./solidity-comments/SKILL.md) | `**/*.sol` |
| [go-task-over-shell](./go-task-over-shell/SKILL.md) | `**/Taskfile.yml`, `**/taskfiles/**`, `**/*.sh` |
| [plan-docs](./plan-docs/SKILL.md) | `**/plans/**`, `**/adr/**`, `**/arc/**` |
| [adr-format](./adr-format/SKILL.md) | `**/adr/**`, `**/docs/adr/**` |

## Situational — loaded on description match

| Rule | Applies when |
|------|--------------|
| [branch-naming](./branch-naming/SKILL.md) | Creating a branch or worktree — Linear **FOR** |
| [commit-conventions](./commit-conventions/SKILL.md) | Writing a commit message |
| [breaking-changes](./breaking-changes/SKILL.md) | Weighing a compatibility shim against a hard cutover |
| [linear-mcp-forestrie](./linear-mcp-forestrie/SKILL.md) | About to make a Linear MCP call (fallback — prefer the direct API) |

## Why `paths:` replaced `alwaysApply`

The old model was Cursor's: a rule was either always injected or requestable by
name. `paths:` is strictly better — a rule costs **zero context** until the
session touches a file it governs, then loads automatically without anyone
having to remember it. `go-comments` is absent while you work in canopy and
present the moment you open a `.go` file in arbor.

## Cursor

`bin/forestrie-agents-sync --cursor-rules` generates `.cursor/rules/<name>.mdc`
shims: `paths:` becomes Cursor's native `globs:`, and the body is a one-line
pointer at the same `SKILL.md` — no duplicated content to drift.

It is opt-in and **never overwrites a `.mdc` it did not generate**. That
matters here: canopy, univocity, mandate, and curator each track hand-written
`.cursor/rules/*.mdc` duplicating this directory. Those files are skipped with
a warning, so adopting this is safe before those copies are retired. Generated
files are excluded individually via `.git/info/exclude`, so a repo that tracks
`.cursor/rules/` stays clean.

Repo-specific rules (e2e Doppler, citty CLI, terraform layout, yaml manifests)
stay in each repo's own `forest/agents/rules/` or `.cursor/rules/` — link from
the repo `AGENTS.md`, do not duplicate here unless promoting team-wide.
