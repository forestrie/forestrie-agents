# forestrie-agents — agent bootstrap

**For agents:** establish task scope, then load **selectively**. Do not bulk-read
this repository.

**For humans:** see [README.md](./README.md).

---

## Loading order

1. **This file** — routing only (~2 min read)
2. **One** [arc-context](./arc-context/) file — only if domain terms apply
3. **Repo overlay** — `forest/agents/AGENTS.md` or root `AGENTS.md` in the working repo
4. **Workflow** — only the invoked [skill](./workflow/skills/)

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

## Workflow index

### Skills (`/name`, or auto-applied when the description matches)

Commands and skills are one mechanism now — a `<name>/SKILL.md` directory per
skill. Install them into every harness with
[`bin/forestrie-agents-sync`](./bin/forestrie-agents-sync).

| Skill | When |
|-------|------|
| [/setup-clone](./workflow/skills/setup-clone/SKILL.md) | New machine or fresh clone |
| [/pre-commit-checks](./workflow/skills/pre-commit-checks/SKILL.md) | Before commit |
| [/review-changes](./workflow/skills/review-changes/SKILL.md) | PR/stack review |
| [/plan-with-linear](./workflow/skills/plan-with-linear/SKILL.md) | Planning with a Linear issue |
| [/persist-plan](./workflow/skills/persist-plan/SKILL.md) | Persisting an approved plan as a canonical `docs/plans/` doc |
| [/triage](./workflow/skills/triage/SKILL.md) | Issue triage |
| [/fork-mandate](./workflow/skills/fork-mandate/SKILL.md) | Fork a mandate instance against lane-b |
| [/save-status](./workflow/skills/save-status/SKILL.md) | Checkpoint work in flight for a fresh session |
| [/tdd](./vendored/matt-skills/skills/engineering/tdd/SKILL.md) | Feature work, bugs, test quality |
| [/diagnose](./vendored/matt-skills/skills/engineering/diagnose/SKILL.md) | Hard bugs, regressions |
| [/grill-with-docs](./vendored/matt-skills/skills/engineering/grill-with-docs/SKILL.md) | Stress-test plans against docs |

### Rules (auto-applied by `paths:` glob, or by description)

Rules are skills with `user-invocable: false` — hidden from the `/` menu, and
loaded only when the session touches a file their `paths:` glob matches
(`**/*.go` for [go-comments](./workflow/rules/go-comments/SKILL.md), `**/*.sol`
for [solidity-comments](./workflow/rules/solidity-comments/SKILL.md), and so
on). They install alongside the skills. See
[workflow/rules/README.md](./workflow/rules/README.md).

---

## Context efficiency rules

1. **Link, don't restate** — point to authoritative docs; do not copy ARC/ADR bodies
2. **Skills on demand** — read a skill only when its description matches the task
3. **Commands on invoke** — user runs `/review-changes`; the body loads only then
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
