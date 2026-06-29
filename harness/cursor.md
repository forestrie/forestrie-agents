# Cursor harness

Canonical agent files live under `forest/agents/` in each repo (or at repo root
as `AGENTS.md`). Cursor-specific paths are **adapters**, not sources of truth.

## Recommended layout (per repo)

```text
forest/agents/        # canonical markdown (optional overlay)
AGENTS.md             # thin router at repo root (Forestrie default today)
.cursor/
  rules/              # symlinks or copies from forest/agents/rules/ or forestrie-agents/workflow/rules/
  skills/             # symlinks or copies
  commands/           # symlinks or copies from forestrie-agents/workflow/commands/
```

Many Forestrie repos already maintain `.cursor/rules/*.mdc` directly — that is
fine. Prefer **one canonical source** in [forestrie-agents/workflow/rules/](../workflow/rules/)
and sync to avoid drift.

## Sync commands from forestrie-agents

From a repo root:

```bash
FORESTRIE_AGENTS=~/Dev/personal/forestrie/forestrie-agents
mkdir -p .cursor/commands
for f in "$FORESTRIE_AGENTS"/workflow/commands/*.md; do
  base=$(basename "$f" .md)
  [ "$base" = README ] && continue
  ln -sf "$f" ".cursor/commands/$base.md"
done
```

For rules, Cursor expects `.mdc` with YAML frontmatter. Options:

1. Maintain `.mdc` in repo that `@include` or link to forestrie-agents markdown
2. Copy promoted rules once and track in forestrie-agents as canonical

## Bootstrap

Point always-applied workspace rules at:

1. Repo `AGENTS.md` (thin pointer to devdocs + local docs)
2. [linear-mcp-forestrie](../workflow/rules/linear-mcp-forestrie.md) when using Linear MCP
3. Repo-specific overlay rules only — prefer requestable rules for common content

## Workspace

Add [forestrie-agents](../README.md) to `forestrie.code-workspace` alongside
implementation repos. Optional: keep `curator/` for workspace-only Cursor config
or migrate commands into forestrie-agents (preferred long-term).

## Common repo reference

Clone [forestrie-agents](https://github.com/forestrie/forestrie-agents) as a
sibling under `~/Dev/personal/forestrie/` for link targets in overlays.
