# Rules of the road — arbor-flux (GitOps + release)

Kustomize/Flux manifests for Arbor services, and the release qualification/
promotion train. Load with [platform.md](https://github.com/forestrie/forestrie-agents/blob/main/rules-of-the-road/platform.md). `⤷` = specialises a
platform rule.

Glossary/links: [`arc-infra` skill](https://github.com/forestrie/forestrie-agents/blob/main/arc-context/arc-infra/SKILL.md).

---

### FX1 — Git is the only source of cluster state
All application state is declared in Git and reconciled by Flux from a
`GitRepository`; no imperative `kubectl` changes to running services. **Why:**
drift between the cluster and Git is invisible and unrecoverable — reconciliation
is the audit trail.
[`arc-infra` skill](https://github.com/forestrie/forestrie-agents/blob/main/arc-context/arc-infra/SKILL.md).

### FX2 — Secrets are ExternalSecret refs, never inline
Secrets are `ExternalSecret` references to Doppler; manifests carry no secret
values. A ConfigMap checksum annotation triggers rollouts on config change.
**Why:** a secret in a manifest is a secret in Git history forever; the checksum
is what makes config changes actually roll.
[docs/service-secrets.md](https://github.com/forestrie/arbor-flux/blob/main/docs/service-secrets.md).

### FX3 — Qualification IS release creation
One hourly loop reads the published GitHub Release frontier, captures, proves on
lane-A T3, and only then publishes `qualified/<runId>` as a Release carrying the
manifest + report — never a commit to `main`. No dispatch, no `services.*.channel`,
and **no carry-forward**. **Why:** carry-forward silently regressed arbor by a
month across two green releases; "existence is sufficient" removes that class of
bug.
[ADR-0061](https://github.com/forestrie/devdocs/blob/main/adr/adr-0061-qualification-is-release-creation.md).

### FX4 — Promotion is a gated merge, not a rebuild
lane-A → lane-B promotion promotes the *same* qualified artifact; the gate MUST
assert offline receipt verification and fail on any missing **declared** spec
(no silent spec skips). **Why:** build-once/test-many only holds if promotion
never rebuilds and never quietly drops a spec.
⤷ specialises P2. [ARC-0025](https://github.com/forestrie/devdocs/blob/main/archive/2606/arc/arc-0025-tiered-qa-and-promotion-gates.md).
