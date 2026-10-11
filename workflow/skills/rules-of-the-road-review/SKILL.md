---
name: rules-of-the-road-review
description: Check a diff or a plan against Forestrie's fundamental invariants (rules-of-the-road) and cite violated rule ids. Use as the design-invariant pass of a code review, or standalone to ask "does this break something load-bearing?".
when_to_use: Reviewing a PR, a stack, a diff or a plan in a forestrie repo; the user mentions rules of the road or invariants.
argument-hint: "[diff ref | plan path]"
---

# rules-of-the-road-review

Check a diff (or a plan) against Forestrie's **fundamental invariants** — the
distilled guardrail set in
[rules-of-the-road/](../../../rules-of-the-road/README.md). Use this as the
design-invariant pass of a code review, or standalone when you only want the
"does this break something load-bearing?" check.

This is the fast, high-signal pass. It does **not** replace
[review-changes](../review-changes/SKILL.md) (stack detection, security,
tests, Linear follow-ups) — it is its design-invariant core, made reusable.

## 1. Load the guardrails (auto)

Always load [platform.md](../../../rules-of-the-road/platform.md). Then load the
**one** repo file matching the changed paths — never more than one unless the
change is genuinely cross-repo:

| Changed paths | Repo file |
|---------------|-----------|
| ranger / sealer / custodian / sharder (Go) | [arbor.md](../../../rules-of-the-road/arbor.md) |
| SCRAPI / ingress DO / x402 / delegation coordinator (Workers) | [canopy.md](../../../rules-of-the-road/canopy.md) |
| Solidity / on-chain | [univocity.md](../../../rules-of-the-road/univocity.md) |
| BYOK operator UI / delegation agent / signer | [mandate.md](../../../rules-of-the-road/mandate.md) |
| Bun/citty CLIs / contract deploy / deploy-web | [univocity-tools.md](../../../rules-of-the-road/univocity-tools.md) |
| Terraform / GKE / DNS / storage | [forest-1.md](../../../rules-of-the-road/forest-1.md) |
| GitOps manifests / release qualify/promote | [arbor-flux.md](../../../rules-of-the-road/arbor-flux.md) |

Determine changed paths from `git diff --name-only $BASE...HEAD` (base per
[review-changes §2](../review-changes/SKILL.md)).

## 2. Check the diff against each loaded rule

For every rule in the loaded files, state one of:

- **UPHOLDS** — the change is consistent with the rule (only note if relevant).
- **VIOLATES** — cite the rule id, the offending `file:line`, and the concrete
  failure mode. This is a **High**-severity finding by default: rules of the
  road are load-bearing.
- **AT RISK** — the change moves toward violating it, or relies on an
  assumption the rule forbids (e.g. designing against succinct absence proofs,
  P13).
- **N/A** — rule does not touch this diff.

A rule tagged `⤷ specialises P#` is the concrete check for that platform rule
in this component — a violation there is also a platform violation; cite both
(e.g. `canopy/C1` + `P2`).

## 3. Guard against the not-yet-live section

Rules in `platform.md` under **"Not-yet-live"** are design direction, not
shipped behaviour. Do **not** raise a finding that a diff fails to implement
them; do flag a diff that makes them *harder* to reach later.

## 4. Report

- Findings first, most severe first, each: `rule-id — file:line — what breaks`.
- Then a one-line **verdict**: any VIOLATES → request changes; only AT RISK →
  comment; all clear → note which rules were checked so the pass is auditable.
- Cite rules by id in Linear follow-ups so remediation is traceable to the
  invariant.

Do not restate rule bodies in the report — cite the id; the reviewer can open
the file.
