# forestrie-agents

Shared agent guidance for **Forestrie** org development: team skills, team
rules, domain glossaries and the fundamental invariants ("rules of the road"),
for Claude Code, Cursor, Codex, pi and other coding agents.

**Not for Just Games / SentientDogs work.** That lives in
[just-agents](https://github.com/SentientDogs/just-agents).

## How it reaches you

| Where you work | What delivers it | Read |
|----------------|------------------|------|
| Claude Code, terminal | the `forestrie-core` and `mattpocock-skills` plugins from this marketplace | [harness/claude-code.md](./harness/claude-code.md) |
| Claude Code, cloud | the layer committed into each repo by `agentfiles sync` | [sync/README.md](./sync/README.md) |
| Cursor, Codex, pi, others | the same committed layer (`AGENTS.md`, `.agents/skills/`) | [harness/other-tools.md](./harness/other-tools.md) |

Quick install for Claude Code:

```bash
claude plugin marketplace add forestrie/forestrie-agents     # or a local checkout path
claude plugin install forestrie-core@forestrie-agents
claude plugin install mattpocock-skills@forestrie-agents
```

## Contributing

[AGENTS.md](./AGENTS.md) has the org map, the repo layout and the contributor
guide: how to add a skill, rule or glossary, how to check it, and how to
re-sync the org repos afterwards.

## Precedence

1. **Repo** — the repo's own `AGENTS.md`, `.claude/rules/` and skills (wins on conflict)
2. **Team** — this repo's `workflow/`, `arc-context/` and `rules-of-the-road/`
3. **Vendored** — upstream skills; patch through `vendored/*/patches/`, never in place
4. **Incubator** — opt-in only; never loaded by default

The design behind this layout is
[agentfiles plan 2610-01](https://github.com/robinbryce/agentfiles/tree/8b60ee4a/docs/plans/plan-2610-01-agent-config-reorg).
