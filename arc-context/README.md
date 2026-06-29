# arc-context

Minimal domain glossaries for the Forestrie transparency log platform.
**Glossary + links only** — not specs, not implementation detail.

Load **one** file matching your task. See [AGENTS.md](../AGENTS.md).

| File | Bounded context |
|------|-----------------|
| [canopy.md](./canopy.md) | SCRAPI Workers API, ingress, x402 |
| [arbor.md](./arbor.md) | Go services on GKE (ranger, sealer, custodian) |
| [univocity.md](./univocity.md) | On-chain checkpoint verification |
| [infra.md](./infra.md) | forest-1 (cluster) + arbor-flux (GitOps) |
| [mandate.md](./mandate.md) | BYOK operator UI and delegation |
| [tools.md](./tools.md) | univocity-tools CLIs |
| [company.md](./company.md) | Product and business vocabulary |

**Platform depth:** [devdocs](https://github.com/forestrie/devdocs) — ADRs, ARCs,
[glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md),
[architecture.md](https://github.com/forestrie/devdocs/blob/main/architecture.md).

**Product context:** [product](https://github.com/forestrie/product) — briefs, decks, plans.
