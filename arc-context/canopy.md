# arc-context: canopy (SCRAPI edge)

Minimal glossary for **canopy** — Cloudflare Workers SCRAPI API, ingress DOs,
x402 settlement, delegation coordinator.

**Load when:** Workers, SCRAPI routes, SequencingQueue DO, R2, Queues, x402,
delegation APIs, Playwright e2e.

**Do not bulk-read** — use [canopy/AGENTS.md](https://github.com/forestrie/canopy/blob/main/AGENTS.md) and [docs/agents/](https://github.com/forestrie/canopy/tree/main/docs/agents).

---

## Core terms

| Term | Meaning |
|------|---------|
| **SCRAPI** | SCITT-compatible HTTP API for transparency logs |
| **canopy-api** | Main Worker (`@canopy/api`, port 8789 locally) |
| **forestrie-ingress** | Worker hosting SequencingQueue Durable Objects (8791) |
| **SequencingQueue DO** | Per-log sequencing; assigns seq numbers; ranger pulls |
| **x402 settlement** | Payment-gated register-statement flow (`@canopy/x402-settlement`) |
| **delegation-coordinator** | Phase 3 delegation APIs, sharded DO (8793) |
| **contentHash** | SHA-256 of statement payload; async status via 303 |
| **CBOR responses** | Default wire format except `/api/health` and scitt-configuration |

## Authoritative docs

| Topic | Path |
|-------|------|
| Agent router | [AGENTS.md](https://github.com/forestrie/canopy/blob/main/AGENTS.md) |
| E2E / Doppler | [docs/agents/e2e.md](https://github.com/forestrie/canopy/blob/main/docs/agents/e2e.md) |
| Grant verification map | [docs/arc/canopy-grant-verification-implementation.md](https://github.com/forestrie/canopy/blob/main/docs/arc/canopy-grant-verification-implementation.md) |
| x402 architecture | [devdocs ARC-0015](https://github.com/forestrie/devdocs/blob/main/arc/arc-0015-x402-settlement-architecture.md) |
| System testing | [devdocs ARC-0024](https://github.com/forestrie/devdocs/blob/main/arc/arc-0024-system-testing-architecture.md) |

## Platform cross-links

| Domain | Where |
|--------|-------|
| Sequencing / signing (GKE) | [arbor.md](./arbor.md) |
| On-chain checkpoints | [univocity.md](./univocity.md) |
| Grant verification model | [devdocs ARC-0019](https://github.com/forestrie/devdocs/blob/main/arc/arc-0019-grant-verification-model.md) |
| MMR / COSE receipts | [draft-bryce-cose-receipts-mmr-profile](https://github.com/robinbryce/draft-bryce-cose-receipts-mmr-profile) |

## Gotchas

- Start **both** `@canopy/api` and `@canopy/forestrie-ingress` for DO routes locally
- Local secrets: `packages/apps/canopy-api/.dev.vars` — not repo-root `.env`
- E2E: Doppler project **canopy** outside npm scripts (see e2e-local-doppler rule)
