# Claude Code harness

## Repo CLAUDE.md

Add a thin pointer at repo root (Forestrie repos already use this pattern):

```markdown
# Claude Code

Read [AGENTS.md](./AGENTS.md) before making changes.
Common process: [forestrie-agents](https://github.com/forestrie/forestrie-agents).
```

## Skills

Install team skills by copying or symlinking from:

- `forest/agents/skills/` (repo overlay)
- `../forestrie-agents/workflow/skills/` (common overlays)
- `../forestrie-agents/vendored/matt-skills/skills/` (vendored)
- `../matt-skills/skills/` (full upstream sibling checkout)

Or reference paths directly in CLAUDE.md when using monorepo sibling checkouts.

## Platform docs

Point agents at [devdocs/AGENTS.md](https://github.com/forestrie/devdocs/blob/main/AGENTS.md)
for cross-repo ADRs, ARCs, and ops — not forestrie-agents arc-context alone.

## Hooks

### Require a worktree before plan execution

[hooks/require-worktree.sh](./hooks/require-worktree.sh) is a `PreToolUse` hook
on the `ExitPlanMode` tool — it fires at the moment a session moves from
planning to execution, and blocks if the session is still in a Forestrie
repo's home clone instead of a worktree. On block, it reports the naming
scheme from [branch-naming.md](../workflow/rules/branch-naming.md) and the
exact `git worktree add` command to run, then asks Claude to re-run the plan
from inside that worktree.

It only fires for repos whose `origin` remote is under `github.com/forestrie/`,
and is a no-op if the cwd is already inside `<repo>/../.worktrees/` (or any
other linked worktree).

Wire it in per-repo `.claude/settings.json` (or `forest/agents/` overlay):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "ExitPlanMode",
        "hooks": [
          {
            "type": "command",
            "command": "bash ../forestrie-agents/harness/hooks/require-worktree.sh"
          }
        ]
      }
    ]
  }
}
```

Adjust the relative path to `forestrie-agents` if the repo isn't a direct
sibling under `~/Dev/personal/forestrie/`.
