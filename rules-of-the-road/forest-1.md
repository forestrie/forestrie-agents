# Rules of the road — forest-1 (GKE platform)

Terraform + Flux bootstrap for the ledger GKE cluster; DNS, ingress, storage
provisioning. Load with [platform.md](./platform.md). `⤷` = specialises a
platform rule.

Glossary/links: [arc-context/infra.md](../arc-context/infra.md).

---

### F1 — Public genesis/grants on a managed custom domain
Genesis and grant data are served from a **public** R2 bucket on a managed
custom domain (not `r2.dev`) with explicit Cache Rules. **Why:** this public,
operator-independent surface is precisely what makes permissionless publishers
and offline monitors possible.
⤷ specialises P14. [ADR-0047](https://github.com/forestrie/devdocs/blob/main/adr/adr-0047-publisher-resolves-contract-from-public-r2-genesis.md).

### F2 — Cache-Control is keyed on completeness at the storage layer
Log objects are published with explicit `Cache-Control`: complete massifs
`immutable`, head massifs and checkpoints `no-store`, negatives never cached.
Immutability is locally decidable from the object path. **Why:** a blanket CDN
default would cache mutable objects and 404s — see P15.
⤷ specialises P15. [ADR-0057](https://github.com/forestrie/devdocs/blob/main/adr/adr-0057-published-artifact-cache-policy.md).

### F3 — No static CI keys — Workload Identity only
GitHub Actions ↔ GKE authenticates via Workload Identity; runtime secrets are
Doppler-backed ExternalSecrets. No long-lived service-account keys in CI or the
cluster. **Why:** a static key is a standing compromise; short-lived federated
identity is not.
[ADR-0049](https://github.com/forestrie/devdocs/blob/main/adr/adr-0049-doppler-github-oidc-worker-deploy.md) · [arc-context/infra.md](../arc-context/infra.md).

### F4 — Ingress is isolated from workloads
Ingress runs on a dedicated pool with per-project isolation; services run on the
spot workload pool. **Why:** ingress availability and blast-radius must not share
fate with cost-optimised, preemptible workload compute.
[forest-1 ARC-0001](https://github.com/forestrie/forest-1/blob/main/docs/arc-0001-per-project-ingress-isolation.md).
