---
name: arc-infra
description: Infra domain glossary (forest-1 + arbor-flux). Use when a task touches Terraform, GKE, Flux bootstrap, cluster ops, or GitOps manifests (Kustomize, ExternalSecrets).
when_to_use: "Terraform, GKE, Flux bootstrap, DNS, Traefik, Kustomize, ExternalSecrets, service rollouts, Workload Identity."
user-invocable: false
---

# arc-context: infra (forest-1 + arbor-flux)

Minimal glossary for **forest-1** (GKE platform) and **arbor-flux** (GitOps
manifests).

**Load when:** Terraform, GKE, Flux bootstrap, DNS, Traefik, Kustomize,
ExternalSecrets, service rollouts, Workload Identity.

---

## forest-1 (platform provisioning)

| Term | Meaning |
|------|---------|
| **forest-1** | Terraform + Flux bootstrap for the ledger GKE cluster |
| **ledger cluster** | Primary GKE cluster under `clusters/ledger/` |
| **Spot workload pool** | Cost model — compute pool for services |
| **Dedicated ingress pool** | Ingress isolation per ARC-0001 |
| **Workload Identity** | GitHub Actions and GKE SA binding — no static CI keys |

**Agent router:** [forest-1/AGENTS.md](https://github.com/forestrie/forest-1/blob/main/AGENTS.md)

**Docs:** [docs/agents/](https://github.com/forestrie/forest-1/tree/main/docs/agents),
[devdocs/ops/](https://github.com/forestrie/devdocs/tree/main/ops)

## arbor-flux (application GitOps)

| Term | Meaning |
|------|---------|
| **arbor-flux** | Kustomize/Flux manifests for Arbor services on GKE |
| **GitRepository** | Flux source for application manifests |
| **ExternalSecret** | Doppler-backed secret refs — see service-secrets catalog |
| **ConfigMap checksum** | Annotation triggers rollouts on config change |

**Agent router:** [arbor-flux/AGENTS.md](https://github.com/forestrie/arbor-flux/blob/main/AGENTS.md)

**Secrets catalog:** [docs/service-secrets.md](https://github.com/forestrie/arbor-flux/blob/main/docs/service-secrets.md)

## Flow

```text
forest-1 (Terraform + Flux bootstrap)
    └── GKE cluster
            └── arbor-flux (Kustomizations)
                    └── arbor service Deployments / Services
```

Canopy runs on Cloudflare — not deployed via arbor-flux.

## Authoritative platform docs

| Topic | Path |
|-------|------|
| Per-project ingress | [forest-1 ARC-0001](https://github.com/forestrie/forest-1/blob/main/docs/arc-0001-per-project-ingress-isolation.md) |
| Delegation-signer infra | devdocs ARC stubs linked from forest-1 `docs/arc-*.md` |
| Ops runbooks | [devdocs/ops/README.md](https://github.com/forestrie/devdocs/blob/main/ops/README.md) |

## Gotchas

- Application code changes land in **arbor**; deploy changes land in **arbor-flux**
- Validate locally: `kustomize build` on target paths under `clusters/`
- Terraform: split by domain (`gke.tf`, `iam.tf`) — not monolithic `main.tf`
