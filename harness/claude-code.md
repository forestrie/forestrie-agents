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
