# arc-context

Minimal domain glossaries for the Forestrie transparency log platform.
**Glossary + links only** — not specs, not implementation detail.

Each glossary is a background skill (`user-invocable: false`). Its
`description` names the work it covers, so an agent loads the one that matches
the task and no other. They ship in the `forestrie-core` plugin. A repo's
[sync manifest](../sync/README.md) also commits its own glossary into that repo.

| Skill | Bounded context |
|-------|-----------------|
| [arc-canopy](./arc-canopy/SKILL.md) | SCRAPI Workers API, ingress, x402 |
| [arc-arbor](./arc-arbor/SKILL.md) | Go services on GKE (ranger, sealer, custodian) |
| [arc-univocity](./arc-univocity/SKILL.md) | On-chain checkpoint verification |
| [arc-infra](./arc-infra/SKILL.md) | forest-1 (cluster) + arbor-flux (GitOps) |
| [arc-mandate](./arc-mandate/SKILL.md) | BYOK operator UI and delegation |
| [arc-tools](./arc-tools/SKILL.md) | univocity-tools CLIs |
| [arc-company](./arc-company/SKILL.md) | Product and business vocabulary |

**Platform depth:** [devdocs](https://github.com/forestrie/devdocs) — ADRs, ARCs,
[glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md),
[architecture.md](https://github.com/forestrie/devdocs/blob/main/architecture.md).

**Product context:** [product](https://github.com/forestrie/product) — briefs, decks, plans.
