# Claude Code

## Terminal sessions: profile and plugins

Forestrie work runs in the **forestrie profile** (`CLAUDE_CONFIG_DIR=~/.claude-forestrie`),
which direnv selects under `~/Dev/personal/forestrie/`.
[agentfiles](https://github.com/robinbryce/agentfiles) `bootstrap` creates it
and installs two plugins from this marketplace:

| Plugin | Gives you |
|--------|-----------|
| `forestrie-core` | every skill in `workflow/skills/` (`/forestrie-core:review-changes`, …), every rule in `workflow/rules/` and every `arc-*` glossary as background skills, and the `require-worktree` hook |
| `mattpocock-skills` | `/mattpocock-skills:tdd`, `…:diagnose`, `…:grill-with-docs` |

Without agentfiles:

```bash
claude plugin marketplace add forestrie/forestrie-agents   # or a local checkout path
claude plugin install forestrie-core@forestrie-agents
claude plugin install mattpocock-skills@forestrie-agents
```

A marketplace added from a local checkout loads in place: edits are live after
`/reload-plugins`. A synced repo's `.claude/settings.json` also names the
marketplace and both plugins, so Claude Code offers them to anyone who trusts
the repo.

The workspace [AGENTS.md](../workspace/AGENTS.md) is linked to
`~/Dev/personal/forestrie/AGENTS.md`, so every session below it knows the clone
layout.

## Cloud sessions: the committed layer

Cloud sessions **never load plugins**, including from `.claude/skills/`. A
synced repo commits what they need instead (see [sync/](../sync/README.md)):

| Committed path | Loads |
|----------------|-------|
| `CLAUDE.md` → `@AGENTS.md` | the repo's facts: build, test, layout |
| `.claude/rules/*.md` | at session start, or when a matching file is touched (`paths:`) |
| `.claude/skills/<name>` → `../../.agents/skills/<name>` | as project skills: `/review-changes`, … |

In a terminal session the synced skills appear twice, as `/review-changes` and
`/forestrie-core:review-changes`. That is harmless: both are the same text.

## The require-worktree hook

[hooks/require-worktree.sh](./hooks/require-worktree.sh) runs on
`PreToolUse` for `ExitPlanMode`, the moment a session moves from planning to
execution. It blocks if the session is still in a Forestrie repo's home clone
rather than a worktree, prints the branch naming scheme from
[branch-naming](../workflow/rules/branch-naming/SKILL.md) and the exact
`git worktree add` command, and asks Claude to re-run the plan from there.

It fires only for repos whose `origin` is under `github.com/forestrie/`, and
does nothing inside `<repo>/../.worktrees/` or any other linked worktree. It
ships with `forestrie-core` ([hooks.json](./hooks/hooks.json)), so terminal
sessions get it with no per-repo wiring. Cloud sessions do not run it: each
already works in its own checkout.
