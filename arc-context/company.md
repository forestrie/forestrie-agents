# arc-context: company (product and business)

Minimal glossary for **Forestrie** as a product and business — not engineering
implementation.

**Load when:** positioning, compliance framing, customer-facing language,
roadmap discussions, decks and briefs.

**Do not bulk-read** — use [product/](https://github.com/forestrie/product) and
[devdocs/glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md).

---

## What Forestrie is

Forestrie provides **SCITT/SCRAPI-compliant transparency logs** with:

- Cryptographic proof of statement registration (MMR + COSE receipts)
- On-chain checkpoint verification via **Univocity** (split-view protection)
- Hierarchical **authority logs** and **grant**-based authorization
- Optional **x402** payment gating for register-statement
- **BYOK** operator hosting via mandate for user-owned root keys

See [devdocs/architecture.md](https://github.com/forestrie/devdocs/blob/main/architecture.md)
for the technical end-to-end picture.

## Core product terms

| Term | Meaning |
|------|---------|
| **Forest** | Namespace of logs sharing one bootstrap root authority log `R` |
| **Transparency log** | Append-only MMR of statements with verifiable receipts |
| **Authority log** | Log whose grants authorize child logs and checkpoints |
| **Checkpoint** | Published consistency state; requires grant + signed receipt |
| **Grant** | Delegated authority recorded in an owner log |
| **SCRAPI client** | HTTP client using SCITT registration and proof APIs |

Full domain language: [devdocs/glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md).

## Product materials

| Material | Path |
|----------|------|
| Briefs and positioning | [product/briefs/](https://github.com/forestrie/product/tree/main/briefs) |
| Decks | [product/decks/](https://github.com/forestrie/product/tree/main/decks) |
| Product plans | [product/plans/](https://github.com/forestrie/product/tree/main/plans) |
| Engineering notes | [product/engineering/](https://github.com/forestrie/product/tree/main/engineering) |

## Platform economics and incentives (design)

| Topic | Path |
|-------|------|
| x402 settlement | [devdocs ARC-0015](https://github.com/forestrie/devdocs/blob/main/arc/arc-0015-x402-settlement-architecture.md) |
| Checkpoint incentivisation | [devdocs ARC-0016](https://github.com/forestrie/devdocs/blob/main/arc/arc-0016-checkpoint-incentivisation-model.md) |
| Fee distribution / hierarchy | [devdocs ARC-0017](https://github.com/forestrie/devdocs/blob/main/arc/arc-0017-hierarchical-authority-logs-and-fee-distribution.md) |
| Reputation model | [devdocs ARC-0020](https://github.com/forestrie/devdocs/blob/main/arc/arc-0020-incentivisation-and-reputation-model.md) |

## Linear

Team key: **FOR** (Forestrie workspace). Issue ids: `FOR-<n>`.

Branch naming: `robin/for-<issue-no>-<short-desc>` — see
[workflow/rules/branch-naming](../workflow/rules/branch-naming/SKILL.md).

## What this file is not

- Not API specs → repo `docs/api/` or SCRAPI implementation in canopy
- Not ops runbooks → [devdocs/ops/](https://github.com/forestrie/devdocs/tree/main/ops)
- Not on-chain rules → [univocity.md](./univocity.md)
