---
name: fork-mandate
description: "Operator runbook the agent drives: fork a personal mandate instance and configure it against the Forestrie lane-b deployment."
when_to_use: The user wants their own mandate instance, says "fork mandate", or is following mandate/FORKING.md.
---

# fork-mandate

Walk a person through forking their own **mandate** instance and configuring it
against the Forestrie **lane-b** deployment, automating as much of
[mandate/FORKING.md](https://github.com/forestrie/mandate/blob/main/FORKING.md)
as possible and prompting only when a human decision, dashboard action, or
secret is genuinely required.

This is an **operator runbook the agent drives**. The agent runs the commands;
the user supplies accounts, approves dashboard steps, and confirms destructive
or cost-incurring actions.

---

## 0. Operating rules (read first)

1. **Automate by default, prompt on need.** Only stop for: provider choice,
   third-party dashboard actions (Cloudflare/Privy/GitHub can't be scripted
   here), approvals owned by another party (onboard-token approval), values only
   the user has (emails, account ids), and any irreversible or paid action.
2. **One question at a time**, with a recommended default, using the structured
   question prompt. Never dump a wall of questions.
3. **Never print, echo, or commit secrets.** Read/write them only through
   Doppler (`mandate-forestrie` project) or `wrangler secret put`. Redact tokens
   in any output you show the user. See the
   [Linear API-key](../../rules/) and repo secret rules.
4. **Work in the mandate repo.** `cd $(git rev-parse --show-toplevel)` must be
   the `forestrie/mandate` clone (or the user's fork of it). Use a worktree per
   the repo `AGENTS.md` only if you are changing code; a plain fork clone is fine
   for provisioning.
5. **Verify each stage before advancing** (health endpoints, JSON responses,
   receipt redirects). A wrong URL or missing secret should fail loudly at the
   nearest check, not three steps later.
6. **Idempotence.** Re-running a stage should detect existing state (deployed
   Workers, minted token, provisioned forest) and skip rather than duplicate.

Canonical references (link, don't restate):
[FORKING.md](https://github.com/forestrie/mandate/blob/main/FORKING.md) ·
[mandate README](https://github.com/forestrie/mandate/blob/main/README.md) ·
[service-secrets.md](https://github.com/forestrie/mandate/blob/main/docs/service-secrets.md) ·
[ADR-0005 BYOK modes](https://github.com/forestrie/mandate/blob/main/docs/adr/adr-0005-byok-delegation-modes.md) ·
[scitt-hackathon demo](https://github.com/forestrie/canopy/blob/main/docs/demo/scitt-hackathon.md).

---

## 1. Choose a hosting provider (prompt)

Mandate has two deployable planes with different portability:

| Plane | What it is | Portable? |
| ----- | ---------- | --------- |
| `@mandate/agent`, `@mandate/signer` | Cloudflare **Workers** (KV, `wrangler`, `repo-init`) | **No** — Cloudflare only |
| `@mandate/ui` + same-origin BFF | SvelteKit (`adapter-cloudflare`) on Cloudflare **Pages** | Yes (adapter swap) |

So the **sealing plane is always Cloudflare**; only the operator console can
live elsewhere. Ask the user:

> **Where do you want to host the mandate operator console (UI)?**
> - **Cloudflare Pages (Recommended)** — one provider, matches the default
>   config, fully automated here.
> - **Vercel** — UI + BFF on Vercel; agent + signer still deploy to Cloudflare
>   Workers. Requires a SvelteKit adapter swap (Appendix B).
> - **Other / self-host** — UI + BFF elsewhere; same Cloudflare-Workers caveat.

Record the choice. Default and primary path is **Cloudflare** (Section 4 +
Appendix A). Non-Cloudflare choices only change the UI/BFF sub-step and use
Appendix B; everything else is identical.

---

## 2. Prerequisites gate

Verify each; prompt only for what is missing. Do **not** proceed until all
required items are present.

| Prerequisite | Check | If missing |
| ------------ | ----- | ---------- |
| Tools: `git`, `gh`, `node`, `pnpm`, `task` (go-task), `doppler`, `wrangler`, `jq`, `curl` | `command -v <tool>` | Prompt to install (see [setup-clone](../setup-clone/SKILL.md)) |
| Fork + clone of `forestrie/mandate` | `git remote -v` in cwd | `gh repo fork forestrie/mandate --clone` |
| GitHub Packages auth for `@forestrie/delegation-cose` | root `.npmrc` + `NODE_AUTH_TOKEN` (`read:packages`) | `gh auth refresh -s read:packages -h github.com`; see mandate README "Workers deploy" |
| `pnpm install` succeeds | build deps present | run it |
| Cloudflare account + `CLOUDFLARE_API_TOKEN` + `CLOUDFLARE_ACCOUNT_ID` | present in Doppler `mandate-forestrie/dev` | Prompt: create scoped token (Workers, Pages, KV) in Cloudflare dashboard, store in Doppler |
| Privy app (embedded EVM wallets) | `MANDATE_PRIVY_APP_ID` etc. in Doppler | Prompt: create in Privy dashboard (Section 4.1) |
| Doppler project `mandate-forestrie` (configs `dev`, `e2e`) | `doppler projects` | Prompt to create / request access |
| Contact email + instance label | user-supplied | Prompt |
| Funded Base Sepolia deploy key + RPC URL, for the anchor deploy (5.2) | present in Doppler `mandate-forestrie/dev` | Prompt: the deploy costs gas, so confirm first |

Secrets live in Doppler `mandate-forestrie` (`dev` = operational `MANDATE_*`,
`e2e` = `E2E_*` fixtures). Full catalog:
[service-secrets.md](https://github.com/forestrie/mandate/blob/main/docs/service-secrets.md).
Do **not** create a repo-root `.env` with secrets.

---

## 3. Resolve the lane-b target (automated)

Lane-b endpoints and on-chain anchor are defined by the **authoritative lane-b
manifest** — treat it as source of truth, do not hardcode:
[`forestrie/system-testing` `manifests/lane-b.jsonc`](https://github.com/forestrie/system-testing/blob/main/manifests/lane-b.jsonc).

Read from it:

- `catalog.dnsSub` / `catalog.dnsApex` → hostname suffix (currently
  `forest-2` / `forestrie.dev`).
- Chain: **Base Sepolia, chainId `84532`** (Forestrie live lane).

The manifest's `univocity.*.imutableAddress` entries are lane-b's own anchors.
Do **not** reuse them. Canopy binds one forest to each Univocity instance, and
both the onboard attestation and genesis must come from the contract's
bootstrap signer, which Forestrie holds. The fork deploys its own anchor
(5.2).

Derive lane-b endpoints from `dnsSub`/`dnsApex` and lane letter `b`
(FORKING.md uses `api-a.<dnsSub>.<dnsApex>` for lane a), then **confirm each by
probing** before continuing — this catches a wrong prefix immediately:

```bash
CANOPY_BASE_URL="https://api-b.forest-2.forestrie.dev"   # verify against manifest/canopy DNS docs
curl -fsS "$CANOPY_BASE_URL/api/health" | jq .
curl -fsS "$CANOPY_BASE_URL/.well-known/scitt-configuration" | jq .
```

Both must return JSON. Resolve the coordinator base URL the same way (confirm
`delegation-coordinator.b.…` vs `coordinator.…` against the manifest / canopy
DNS docs — do not assume). If a probe fails, stop and ask the canopy operator
for the exact lane-b hostnames rather than guessing.

Choose the bootstrap algorithm (prompt, default **KS256** — the secp256k1 /
`ecrecover` path that matches Privy embedded wallets). `mandate-register` signs
only KS256 onboard attestations, so an ES256 fork gets its onboard token by
break-glass from the canopy operator (5.3).

---

## 4. Deploy the sealing plane (Cloudflare) + operator console

Ordering matters: Workers must exist before provisioning (Section 5 needs the
agent webhook URL), and the signer must hold the bootstrap wallet before the
onboard request (5.3 signs through it). This maps to **FORKING.md §3**, which
FORKING.md's order of operations runs first.

### 4.1 Privy setup (prompt — dashboard, cannot be scripted here)

Guide the user through the Privy dashboard, then have them store outputs in
Doppler `mandate-forestrie/dev` (never in chat):

1. Create/confirm a Privy app with **embedded EVM wallets** enabled →
   `MANDATE_PRIVY_APP_ID`, `MANDATE_PRIVY_APP_SECRET`, `MANDATE_PRIVY_API_BASE`,
   and public `PUBLIC_MANDATE_PRIVY_APP_ID` / `PUBLIC_MANDATE_PRIVY_CLIENT_ID`.
2. Create a **key quorum + P-256 additional-signer key** →
   `MANDATE_PRIVY_SIGNER_ID`, `MANDATE_PRIVY_AUTHORIZATION_KEY`.
3. Create the **ownerless, app-controlled operator wallet** — this is the
   payment-authoritative root (ADR-0005 §7). Record its address as
   `OPERATOR_WALLET_ADDR` and its wallet id. It is the bootstrap signer for
   the anchor (5.2), the onboard attestation (5.3) and genesis (5.4).

### 4.2 Provision Cloudflare infra + deploy Workers (automated)

```bash
# KV namespaces + gitignored wrangler.env.prod.json overlays
task repo-init:doppler

# Deploy agent + signer Workers (merged configs under .wrangler/deploy/)
# then bind secrets per service-secrets.md via `wrangler secret put`
```

Bind `MANDATE_SIGNER_TOKEN`, `COORDINATOR_APP_TOKEN`, `COORDINATOR_UPSTREAM_URL`
(lane-b coordinator), `KEY_DIRECTORY`, `OPERATOR_ROOT_KEYS`, and the Privy
secrets. Record the deployed **agent webhook URL** (`MANDATE_AGENT_WEBHOOK_URL`)
and **signer URL** (`MANDATE_SIGNER_URL`).

### 4.3 Deploy the operator console (branch on Section 1 choice)

- **Cloudflare (default):** deploy `@mandate/ui` to Pages with public Privy
  vars + BFF `COORDINATOR_APP_TOKEN` / `COORDINATOR_UPSTREAM_URL`. See
  Appendix A.
- **Vercel / other:** Appendix B (adapter swap; Workers stay on Cloudflare).

Verify the UI loads and its `/api/coordinator/*` BFF reaches the lane-b
coordinator.

---

## 5. Onboard token → payment-authoritative log (automated + one approval)

### 5.1 Choose the forest id and authorise it on the signer (automated)

The signer signs only for log ids its `KEY_DIRECTORY` entry lists, and genesis
derives the log id from the forest id `R`. Choose `R` now, so the attestation
(5.3) and genesis (5.4) agree:

```bash
FOREST_R=$(uuidgen | tr '[:upper:]' '[:lower:]')
LOG_ID_HEX32=$(printf %s "$FOREST_R" | tr -d -)
```

Store `FOREST_R` in Doppler `mandate-forestrie/dev` as `MANDATE_FOREST_R`,
which `mandate-register provision` reads. Add the operator entry to
`KEY_DIRECTORY` and re-bind it on the signer Worker (`wrangler secret put`):

```json
{
  "operator-root": {
    "walletId": "<operator wallet id>",
    "rootSignerAddress": "<OPERATOR_WALLET_ADDR>",
    "logIds": ["<LOG_ID_HEX32>"]
  }
}
```

### 5.2 Deploy the Univocity anchor (FORKING.md §1)

Deploy an `ImutableUnivocity` on Base Sepolia with the operator wallet as its
bootstrap signer: path **B′** in the browser
([univocity-deploy](https://univocity-deploy.pages.dev)) or path **B** with the
deployer CLI. Use the release tags FORKING.md §1 names. Confirm before
sending: the deploy costs gas.

```bash
./deployer-<os>-<arch> deploy imutable \
  --from-release <univocity release tag> \
  --bootstrap-alg ks256 \
  --bootstrap-ks256-signer "$OPERATOR_WALLET_ADDR" \
  --deploy-key "$DEPLOY_KEY" \
  --rpc-url "$RPC_URL"
```

Record the deployed address as `UNIVOCITY_ADDR`.

### 5.3 Self-service onboard token (FORKING.md §2)

The request carries a bootstrap-key attestation, which the CLI signs with the
operator wallet through the signer; canopy refuses a request without one.
`MANDATE_SIGNER_TOKEN` comes from Doppler.

```bash
task onboard:request -- \
  --canopy-url "$CANOPY_BASE_URL" \
  --label "<instance-label>" \
  --chain-id 84532 \
  --univocity-addr "$UNIVOCITY_ADDR" \
  --contact-email "<operator-email>" \
  --mandate-origin "<deployed-ui-url>" \
  --root-address "$OPERATOR_WALLET_ADDR" \
  --log-id "$LOG_ID_HEX32" \
  --key-ref operator-root \
  --signer-url "$MANDATE_SIGNER_URL"
```

Each attestation buys one request. On 409 `attestation already used`, run the
command again: it signs a fresh one. Capture `requestId` + `redeemCode`. Poll status until approved (prompt: **the
canopy operator must approve lane-b requests** — dev auto-approves, lane-b does
not); if the user holds `CANOPY_OPS_ADMIN_TOKEN` they may break-glass mint
instead (FORKING.md §2 "Break-glass"). Then:

```bash
task onboard:status -- --canopy-url "$CANOPY_BASE_URL" --request-id "$REQUEST_ID"
task onboard:redeem -- --canopy-url "$CANOPY_BASE_URL" \
  --request-id "$REQUEST_ID" --redeem-code "$REDEEM_CODE"
```

Store the returned bearer as `CANOPY_PAYMENTS_ONBOARD_TOKEN` in Doppler
`mandate-forestrie/dev` — **do not print it**.

### 5.4 Provision the PA log (FORKING.md §4)

```bash
task provision -- \
  --onboard-token "$CANOPY_PAYMENTS_ONBOARD_TOKEN" \
  --canopy-url "$CANOPY_BASE_URL" \
  --coordinator-url "$COORDINATOR_URL" \
  --webhook-url "$MANDATE_AGENT_WEBHOOK_URL" \
  --univocity-addr "$UNIVOCITY_ADDR" \
  --chain-id 84532 \
  --forest-r "$FOREST_R"
```

Keep from the output: `forestR` (bootstrap UUID `R`), `logIdHex32`,
`descriptors` (`KEY_DIRECTORY` + `OPERATOR_ROOT_KEYS`), and confirm
`genesis.coordinator` shows `publicRoot: ok`, `webhook: ok`. Merge descriptors
into the agent/signer Worker secrets.

> **Bootstrap key:** the PA genesis `bootstrapKey` must be the anchor's
> bootstrap signer, the **ownerless app-controlled operator wallet** from 4.1;
> canopy answers 422 `genesis bootstrapKey/alg does not match` otherwise. The
> default `task provision` Mode C path is the dev/CI shortcut (user-owned
> wallet, ADR-0005 §7) and works only for an anchor deployed with that wallet.

Then register the root-creation grant and poll to a receipt (FORKING.md §4 warm
-log flow) so the PA log can accept statements.

---

## 6. First user log (FORKING.md §5)

Prompt for the mode (default **Mode C**):

- **Mode C — hosted sealing (default fork path):** user-owned Privy wallet,
  mandate as additional signer.
  ```bash
  task privy:onboard:mode-c -- \
    --log-id "<user-log-hex32>" \
    --wallet-id "<privy-wallet-id>" \
    --signer-url "$MANDATE_SIGNER_URL"
  ```
  Merge the new `KEY_DIRECTORY` entry, then register the user's statement grant
  on canopy.
- **Mode B — purist BYOK (reference fork path):** user holds `K(L)` in their own
  signer; mandate never stores the root key. Deploy the reference signer
  (`task deploy:reference-user-signer`), then `task provision:mode-b -- …`
  (`--root-address`, `--user-signer-url`, `--key-ref`). Full detail:
  [FORKING.md §5b](https://github.com/forestrie/mandate/blob/main/FORKING.md#5b--mode-b-user-log-purist-byok).

---

## 7. Prove the setup (FORKING.md §6)

Register a signed statement and follow the 303 chain to a receipt:

```bash
curl -fsS "$CANOPY_BASE_URL/api/health" | jq .
# POST /register/$forestR/entries  (Authorization: Forestrie-Grant …, COSE Sign1)
# poll status URL until Location ends in /receipt, then GET the receipt
```

Participant flow mirrors the
[SCITT hackathon demo Part 1](https://github.com/forestrie/canopy/blob/main/docs/demo/scitt-hackathon.md#part-1--participant-flow).
Report the receipt URL. Offline receipt verification is a documented gap
(`verify-receipt` helper not yet shipped) — note it, don't block on it.

---

## 8. Final verification checklist

1. `GET $CANOPY_BASE_URL/api/health` and `/.well-known/scitt-configuration` → JSON.
2. Agent + signer Workers deployed; webhook + signer URLs recorded in Doppler.
3. Operator console loads; BFF reaches lane-b coordinator.
4. Anchor deployed with the operator wallet as bootstrap signer; onboard token
   minted and stored (never printed).
5. PA log provisioned: `forestR`, `logId`, `publicRoot: ok`, `webhook: ok`.
6. At least one user log onboarded (Mode C or B).
7. A statement registered end-to-end returned a receipt URL.
8. Summarize: provider choice, lane-b endpoints used, `UNIVOCITY_ADDR`,
   `forestR`/`logId`,
   deployed URLs, and any manual step still owed by the user.

---

## Appendix A — Cloudflare specialization (canonical)

- `task repo-init:doppler` provisions KV + `wrangler.env.prod.json` overlays.
- Agent + signer deploy via merged wrangler configs; secrets via
  `wrangler secret put` (or CI with `ENABLE_WORKERS_DEPLOY=true`).
- UI deploys to Cloudflare **Pages** (`@sveltejs/adapter-cloudflare`), build
  output `packages/apps/ui/.svelte-kit/cloudflare`; BFF runs as Pages Functions
  holding `COORDINATOR_APP_TOKEN`.
- Hostnames per mandate README ("Deployment"): dev `mandate-dev.forestrie.dev`,
  prod `mandate.forestrie.dev`.

## Appendix B — Vercel / other UI hosting (optional)

Only the **UI + BFF** move; `@mandate/agent` and `@mandate/signer` remain
Cloudflare Workers.

1. Swap `@sveltejs/adapter-cloudflare` → `@sveltejs/adapter-vercel` (or the
   target adapter) in `packages/apps/ui`.
2. Reimplement the same-origin BFF (`/api/coordinator/*`) as the provider's
   edge/serverless functions, preserving the `app_token_bff` auth seam
   ([ADR-0001](https://github.com/forestrie/mandate/blob/main/docs/adr-0001-auth-strategy-seams.md))
   and holding `COORDINATOR_APP_TOKEN` server-side only.
3. Set public Privy vars + `COORDINATOR_UPSTREAM_URL` (lane-b) in the provider's
   env; keep server secrets out of the client bundle
   (`pnpm audit:client-secrets`).
4. Point DNS/CORS at the new origin; re-verify the UI → BFF → coordinator path.

Flag this as extra maintenance surface (adapter + BFF divergence from upstream).

## Appendix C — Troubleshooting (FORKING.md)

| Symptom | Check |
| ------- | ----- |
| Genesis 401 | Onboard token wrong / revoked |
| Genesis 422 `bootstrapKey/alg does not match` | Genesis wallet is not the anchor's bootstrap signer |
| Onboard request 400 on the attestation | Anchor's bootstrap signer, `--root-address`, signer `KEY_DIRECTORY` log id |
| Onboard request 409 `attestation already used` | Re-run the request: it signs a fresh attestation |
| Approval or mint 409 `already reserved or registered` | The anchor already has a forest; deploy a new one |
| Genesis 503 coordinator | Webhook URL unreachable from canopy |
| Statement 403 `signer_mismatch` | Statement signer ≠ grant binding |
| Receipt poll never completes | Ask canopy operator: Ranger + Sealer health |
| Agent never seals | Webhook URL, Worker secrets, log-enabled flag |
| `pnpm install` 403 | GitHub Packages `read:packages` token (`gh auth refresh`) |
