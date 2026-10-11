# Forestrie workspace

Clones of Forestrie org repos live here as siblings. Treat several clones of
one repo as one repo. The clone whose directory name equals the repo name is
**primary**: edit there, or in a worktree under `.worktrees/`. `dotgithub/` is
`forestrie/.github`.

Org conventions come from the forestrie-agents plugins installed in this
profile, and from each repo's `AGENTS.md`, `.claude/rules/` and
`.agents/skills/`. Platform "why": `devdocs/`. Protocol and glossary:
`protocol/`.

## Platform

| Directory | Repo | What |
|-----------|------|------|
| canopy | forestrie/canopy | SCRAPI transparency log API: Cloudflare Workers, R2, Queues |
| arbor, arbor-ssh-test | forestrie/arbor | Go services on GKE: ranger, sealer, custodian, sharder. `arbor` is primary |
| univocity | forestrie/univocity | Solidity contracts: on-chain checkpoints and grants |
| univocity-tools | forestrie/univocity-tools | Bun/citty CLIs: contract build, release, deploy |
| mandate | forestrie/mandate | BYOK operator UI, delegation agent, signer |
| forestrie-cli | forestrie/forestrie-cli | Single-binary participant CLI |
| thinker | forestrie/thinker | Cloudflare Think demo: a verifiable record of an agent conversation |

## Infrastructure and release

| Directory | Repo | What |
|-----------|------|------|
| forest-1 | forestrie/forest-1 | GKE platform: Terraform and Flux bootstrap |
| arbor-flux | forestrie/arbor-flux | GitOps manifests for arbor (Kustomize, Flux) |
| release-orchestrator | forestrie/release-orchestrator | Template hydration and lane promotion gates |
| system-testing | forestrie/system-testing | Cross-repo Lane A/B system tests |
| forestrie-cd-gitapp | forestrie/forestrie-cd-gitapp | GitHub App for cross-repo CI/CD tokens |
| taskfiles | forestrie/taskfiles | Shared go-task maintainer and CI taskfiles |

## Docs, protocol and product

| Directory | Repo | What |
|-----------|------|------|
| devdocs | forestrie/devdocs | ADRs, ARCs, architecture, ops runbooks |
| protocol | forestrie/protocol | Protocol spec, glossary, platform rules of the road, conformance vectors |
| product | forestrie/product | Briefs, decks, product plans |
| forestrie-agents | forestrie/forestrie-agents | Agent skills, rules and sync manifests (this file's source) |
| dotgithub | forestrie/.github | Org profile |
| ietf-126-demo | forestrie/ietf-126-demo | IETF 126 demo scripts |
| draft-bryce-cose-receipts-mmr-profile | robinbryce/draft-bryce-cose-receipts-mmr-profile | IETF draft: MMR profile for COSE receipts |

## Libraries

| Directory | Repo | What |
|-----------|------|------|
| go-merklelog | forestrie/go-merklelog | Go MMR log and proofs |
| go-sigv4 | forestrie/go-sigv4 | Minimal SigV4 for R2/S3, used by arbor |
| go-datatrails-common | robinbryce/go-datatrails-common | Shared Go utilities, used by arbor |
| merkle-mountain-range-proofs | robinbryce/merkle-mountain-range-proofs | MMR proofs reference |

## Read-only and not git

- **Upstream, read-only unless asked:** `aws-sdk-go-v2` (aws/aws-sdk-go-v2),
  `matt-skills` (mattpocock/skills, the vendoring source for forestrie-agents).
- **Not git clones:** `curator` (Cursor multi-root harness folder),
  `docs-canopy`, `forestrie-ops`, `helm-charts`, `gitapp`, `media`, `offcuts`,
  `univocity-security-review-2026-09-19`. Use them only when the prompt points
  at them.
- **Not Forestrie:** `git-bootstrap` (robinbryce/git-bootstrap), `just-agents`
  (SentientDogs/just-agents). Ignore unless asked.

## Working here

- Never check out a feature branch in a primary clone. Use
  `git worktree add ../.worktrees/<repo>-<slug> -b <branch> origin/main` from the
  repo, as each repo's `AGENTS.md` describes.
- No root `go.work`. Service-level `go.work` files under `arbor/services/*`
  reference sibling libraries.
- `forestrie.code-workspace` and `canopy.code-workspace` are the VS Code and
  Cursor multi-root workspaces.
