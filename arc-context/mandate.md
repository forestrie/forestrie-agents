# arc-context: mandate (BYOK operator)

Minimal glossary for **mandate** — BYOK Univocity instance management (operator
UI, delegation agent, signer, register).

**Load when:** operator UI, session exchange, delegation signing, browser e2e,
Privy auth in deploy-web.

**Do not bulk-read** — use [mandate/AGENTS.md](https://github.com/forestrie/mandate/blob/main/AGENTS.md).

---

## Core terms

| Term | Meaning |
|------|---------|
| **mandate** | Operator-hosted Univocity instance management product |
| **BYOK** | User owns root authority key `K(L)`; operator hosts sealing infra |
| **delegation agent** | Routes `delegation.required` to user signer in mode B |
| **@mandate/ui** | SvelteKit operator UI |
| **register** | Onboarding / instance registration flows |

## Authoritative docs

| Topic | Path |
|-------|------|
| Agent router | [AGENTS.md](https://github.com/forestrie/mandate/blob/main/AGENTS.md) |
| UI browser e2e plan | [docs/plans/plan-0047-ui-browser-e2e.md](https://github.com/forestrie/mandate/blob/main/docs/plans/plan-0047-ui-browser-e2e.md) |
| Delegation (platform) | [devdocs glossary — BYOK](https://github.com/forestrie/devdocs/blob/main/glossary.md) |
| Canopy delegation coordinator | [canopy.md](./canopy.md) |

## Sibling repos

| Repo | Role |
|------|------|
| canopy | `@canopy/delegation-coordinator` Worker |
| univocity | On-chain checkpoint rules |
| arbor/custodian | KMS signing for operator-hosted keys |
