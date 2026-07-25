# Claude Code harness

## Repo CLAUDE.md

Add a thin pointer at repo root (Forestrie repos already use this pattern):

```markdown
# Claude Code

Read [AGENTS.md](./AGENTS.md) before making changes.
Common process: [forestrie-agents](https://github.com/forestrie/forestrie-agents).
```

## Skills (this is where slash commands come from)

Claude Code has merged custom commands into skills: a directory
`<skills-dir>/<name>/SKILL.md` becomes the slash command `/<name>`, and Claude
may also apply it automatically when its `description` matches the task.

| Level | Path | Applies to |
|-------|------|-----------|
| Personal | `~/.claude/skills/<name>/SKILL.md` | every project |
| Project | `<repo>/.claude/skills/<name>/SKILL.md` | that repo (walks up to the repo root) |

Entries may be **symlinks** to directories elsewhere on disk — Claude Code
follows them and reads `SKILL.md` from the target. That is how this repo
installs.

### Install

```bash
~/Dev/personal/forestrie/forestrie-agents/bin/forestrie-agents-sync
```

Run it in each Forestrie repo you work in. It links, lowest precedence first:

1. `vendored/matt-skills/skills/engineering/` — `/tdd`, `/diagnose`, `/grill-with-docs`
2. `workflow/skills/` — the team skills
3. `<repo>/forest/agents/skills/` — that repo's own overlay, if any

so a team skill shadows a vendored one of the same name, and a repo overlay
shadows both.

### Why per-repo, not machine-wide

**Personal skills override project skills.** A machine-wide `/save-status`
would shadow this repo's Forestrie-specific one, silently, in every Forestrie
repo. Install per-repo and let the checkout decide which one you get.

### Optional: install as a plugin instead

[.claude-plugin/marketplace.json](../.claude-plugin/marketplace.json) exposes
this repo as a Claude Code plugin, if you prefer `/plugin` management to
symlinks:

```bash
claude plugin marketplace add forestrie/forestrie-agents
claude plugin install forestrie-agents@forestrie-agents
```

Plugin skills are namespaced (`/forestrie-agents:review-changes`), so they
cannot collide with personal or project skills — which also means they do not
participate in the shadowing described above. This path is Claude Code only;
`forestrie-agents-sync` is what serves Cursor and pi as well.

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
