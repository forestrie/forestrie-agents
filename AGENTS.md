# forestrie-agents — agent bootstrap

**For agents:** establish task scope, then load **selectively**. Do not bulk-read
this repository.

**For humans:** see [README.md](./README.md).

---

## Loading order

1. **This file** — routing only (~2 min read)
2. **One** [arc-context](./arc-context/) file — only if domain terms apply
3. **Rules of the road** — for review/planning: [platform.md](./rules-of-the-road/platform.md) + the one repo file (see table below)
4. **Repo overlay** — `forest/agents/AGENTS.md` or root `AGENTS.md` in the working repo
5. **Workflow** — only the invoked [command](./workflow/commands/) or [skill](./workflow/skills/)

**Precedence on conflict:** repo overlay → common `workflow/` → vendored → incubator (opt-in).

---

## When to load arc-context

| Task touches | Read |
|--------------|------|
| SCRAPI API, Workers, x402, delegation DOs | [arc-context/canopy.md](./arc-context/canopy.md) |
| ranger, sealer, custodian, grant store, GKE services | [arc-context/arbor.md](./arc-context/arbor.md) |
| Solidity, checkpoints, grants, on-chain Univocity | [arc-context/univocity.md](./arc-context/univocity.md) |
| Terraform, GKE, Flux bootstrap, cluster ops | [arc-context/infra.md](./arc-context/infra.md) |
| GitOps manifests, Kustomize, ExternalSecrets | [arc-context/infra.md](./arc-context/infra.md) (deploy slice) |
| BYOK operator UI, delegation agent, mandate signer | [arc-context/mandate.md](./arc-context/mandate.md) |
| Cart, contract-artefacts, deploy CLIs (Bun/citty) | [arc-context/tools.md](./arc-context/tools.md) |
| Product, business, compliance, positioning | [arc-context/company.md](./arc-context/company.md) |

If none apply, skip arc-context entirely.

---

## Rules of the road (review + planning guardrails)

Distilled **fundamental** invariants — the guardrail set for code review and
planning. Glossaries say what terms *mean*; these say what a change must not
*break*. Load [rules-of-the-road/platform.md](./rules-of-the-road/platform.md)
(general, always) **plus** the one repo file matching the code you touch:

| Task touches | Also load |
|--------------|-----------|
| ranger, sealer, custodian, sharder | [rules-of-the-road/arbor.md](./rules-of-the-road/arbor.md) |
| SCRAPI, ingress DO, x402, delegation coordinator | [rules-of-the-road/canopy.md](./rules-of-the-road/canopy.md) |
| Solidity, checkpoints, grants, on-chain | [rules-of-the-road/univocity.md](./rules-of-the-road/univocity.md) |
| BYOK operator UI, delegation agent, signer | [rules-of-the-road/mandate.md](./rules-of-the-road/mandate.md) |
| Bun/citty CLIs, contract deploy, deploy-web | [rules-of-the-road/univocity-tools.md](./rules-of-the-road/univocity-tools.md) |
| Terraform, GKE, DNS, storage, ingress | [rules-of-the-road/forest-1.md](./rules-of-the-road/forest-1.md) |
| GitOps manifests, release qualify/promote | [rules-of-the-road/arbor-flux.md](./rules-of-the-road/arbor-flux.md) |

Index and conventions: [rules-of-the-road/README.md](./rules-of-the-road/README.md).
Cite rules by id (`P4`, `univocity/U3`) in findings and plans.

---

## Workflow index

### Commands (explicit invocation)

| Command | When |
|---------|------|
| [setup-clone](./workflow/commands/setup-clone.md) | New machine or fresh clone |
| [pre-commit-checks](./workflow/commands/pre-commit-checks.md) | Before commit |
| [review-changes](./workflow/commands/review-changes.md) | PR/stack review |
| [plan-with-linear](./workflow/commands/plan-with-linear.md) | Planning with Linear issue |
| [triage](./workflow/commands/triage.md) | Issue triage |
| [fork-mandate](./workflow/commands/fork-mandate.md) | Fork a mandate instance against lane-b |
| [save-status](./workflow/commands/save-status.md) | Checkpoint work in flight for a fresh session |

### Skills (on demand — read SKILL.md only when task matches)

| Skill | When |
|-------|------|
| [tdd](./vendored/matt-skills/skills/engineering/tdd/SKILL.md) | Feature work, bugs, test quality |
| [diagnose](./vendored/matt-skills/skills/engineering/diagnose/SKILL.md) | Hard bugs, regressions |
| [grill-with-docs](./vendored/matt-skills/skills/engineering/grill-with-docs/SKILL.md) | Stress-test plans against docs |
| [persist-plan](./workflow/skills/persist-plan.md) | Persisting an approved plan as a canonical `docs/plans/` doc |

### Rules (requestable — not auto-loaded unless repo configures alwaysApply)

See [workflow/rules/README.md](./workflow/rules/README.md).

---

## Context efficiency rules

1. **Link, don't restate** — point to authoritative docs; do not copy ARC/ADR bodies
2. **Skills on demand** — read a skill only when its description matches the task
3. **Commands on invoke** — user runs `/review-changes` or pastes the command
4. **Incubator is opt-in** — never load `incubator/` unless the user names a path
5. **devdocs for depth** — use [devdocs](https://github.com/forestrie/devdocs) for platform *why* and cross-repo ADRs/ARCs; use repo `docs/` for implementation detail

---

## Forestrie repo routers

After arc-context (if any), use the working repo's doc router:

| Repo | Router |
|------|--------|
| devdocs | [AGENTS.md](https://github.com/forestrie/devdocs/blob/main/AGENTS.md) |
| canopy | [AGENTS.md](https://github.com/forestrie/canopy/blob/main/AGENTS.md) |
| arbor | [AGENTS.md](https://github.com/forestrie/arbor/blob/main/AGENTS.md) |
| forest-1 | [AGENTS.md](https://github.com/forestrie/forest-1/blob/main/AGENTS.md) |
| arbor-flux | [AGENTS.md](https://github.com/forestrie/arbor-flux/blob/main/AGENTS.md) |
| univocity | [AGENTS.md](https://github.com/forestrie/univocity/blob/main/AGENTS.md) |
| univocity-tools | [AGENTS.md](https://github.com/forestrie/univocity-tools/blob/main/AGENTS.md) |
| mandate | [AGENTS.md](https://github.com/forestrie/mandate/blob/main/AGENTS.md) |

**Workspace routing:** `forestrie-agent-context.md` at the forestrie parent checkout
(`~/Dev/personal/forestrie/`) lists clone layout and primary paths when present.

---

## Key external references

| Topic | Where |
|-------|-------|
| MMR / COSE receipts profile | [draft-bryce-cose-receipts-mmr-profile](https://github.com/robinbryce/draft-bryce-cose-receipts-mmr-profile) — local sibling often at `~/Dev/personal/forestrie/draft-bryce-cose-receipts-mmr-profile/` |
| Go MMR libraries (arbor deps) | [arbor/services/_deps](https://github.com/forestrie/arbor/tree/main/services/_deps) — `go-merklelog`, `go-univocity`, `go-sigv4`, etc. |
| Platform glossary | [devdocs/glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md) |
| End-to-end architecture | [devdocs/architecture.md](https://github.com/forestrie/devdocs/blob/main/architecture.md) |

---

## Linear

Team key: **FOR**. Workspace: **forestrie**. Login: `robinbryce@gmail.com` for MCP.

Before the first Linear MCP call in a Forestrie repo, verify identity per
[linear-mcp-forestrie](https://github.com/forestrie/canopy/blob/main/.cursor/rules/linear-mcp-forestrie.mdc).

Direct API: load `LINEAR_API_KEY` from `~/Dev/personal/forestrie/.envrc` when
present. Linear MCP uses Cursor OAuth separately.
