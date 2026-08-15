# Rules of the road

Application-aware **guardrails** for reviewing and planning Forestrie work.
Not a glossary (see [arc-context](../arc-context/)), not a spec (see
[devdocs](https://github.com/forestrie/devdocs)) — a distilled set of the
*fundamental* invariants a change must not break.

Each rule is: a one-line imperative, a one-sentence **why**, and a link to the
authoritative ADR/ARC for the reasoning. This is deliberately **short**. It is
the distillation of a large ADR/ARC corpus down to only the load-bearing
choices; it is not an index of every ruling.

## How to use

- **Reviewing / planning a change:** load [`platform.md`](./platform.md)
  (always) **plus** the one repo file matching the code you are touching.
  Never load more than one repo file unless the change is genuinely cross-repo.
- **Review skills** reference these files as the guardrail context for
  "does this change violate a fundamental?" checks.
- A rule is a *check target*, not prose to restate — cite it by id (e.g.
  `P4`, `univocity/U3`) in review findings and plans.

## Files

| File | Scope |
|------|-------|
| [platform.md](./platform.md) | **General** — cross-repo invariants (load always) |
| [arbor.md](./arbor.md) | Go services: ranger, sealer, custodian, sharder |
| [canopy.md](./canopy.md) | Cloudflare Workers: SCRAPI, ingress DO, x402, delegation |
| [univocity.md](./univocity.md) | Solidity on-chain contracts |
| [mandate.md](./mandate.md) | BYOK operator UI, delegation agent, signer |
| [univocity-tools.md](./univocity-tools.md) | Bun/TS CLIs (Cart, deploy) |
| [forest-1.md](./forest-1.md) | GKE Terraform + cluster provisioning |
| [arbor-flux.md](./arbor-flux.md) | GitOps manifests + release qualification |

## Rules for the rules

1. **Repo files never duplicate `platform.md`.** They only add repo-specific
   invariants, or *specialise* a platform rule into a concrete check for that
   component (marked `⤷ specialises P#`).
2. **Fundamental only.** If violating it would not break the trust, economic, or
   decentralisation model — or a headline product claim — it does not belong
   here. Tactical choices live in ADRs, not here.
3. **Link, don't restate.** The `why` is one sentence; the ADR/ARC carries the
   argument.
4. **Reject superseded.** Rules track the *current* accepted decision; when an
   ADR is superseded, the rule moves with it.

Reasoning links point at [devdocs](https://github.com/forestrie/devdocs)
ADRs/ARCs and the [forestrie-cli trust model](https://github.com/forestrie/forestrie-cli/blob/main/TRUST-MODEL.md).
