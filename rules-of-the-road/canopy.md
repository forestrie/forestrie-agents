# Rules of the road — canopy (SCRAPI edge)

Cloudflare Workers: SCRAPI API, forestrie-ingress (SequencingQueue DO), x402
settlement, delegation coordinator. Load with [platform.md](./platform.md).
`⤷` = specialises a platform rule.

Glossary/links: [arc-context/canopy.md](../arc-context/canopy.md).

---

### C1 — Offline verify calls nothing
Verify (layers A–C) uses only the supplied trust anchors / genesis COSE root —
never the network, coordinator, RPC, or a live tile read inside the verify path.
**Why:** offline verify is the headline claim; a hidden fetch makes it false.
⤷ specialises P2. [ADR-0045](https://github.com/forestrie/devdocs/blob/main/adr/adr-0045-receipt-verify-offline-contract.md).

### C2 — Enforce global logId→R uniqueness at grant POST
Grant POST checks an atomic `logId → R` index and returns 409 on conflict.
**Why:** cross-forest logId reuse would make authority resolution ambiguous and
enable grant replay.
⤷ specialises P14. [ADR-0036](https://github.com/forestrie/devdocs/blob/main/adr/adr-0036-global-logid-r-uniqueness.md).

### C3 — register-statement: grant kind + signer binding, envelope against owner authority
Require `isStatementRegistrationGrant(grant)` (bitmap `GF_DATA_LOG | GF_EXTEND`)
and COSE `kid == statementSignerBindingBytes(grant)`; verify the statement
envelope against the **`ownerLogId` authority key or its delegate**, never
against `grantData`. **Why:** issuance authority (parent) and endorsed signer
(`grantData`) are structurally distinct — collapsing them is a forgery vector.
⤷ specialises P10. [ARC-0019 §6](https://github.com/forestrie/devdocs/blob/main/arc/arc-0019-grant-verification-model.md).

### C4 — Reject obsolete grant wire fields
Reject wire-v0 grant maps carrying keys 7/8 (legacy signer/kind); `grantData` is
the sole statement-signer binding. **Why:** accepting removed fields
re-introduces the ambiguity ARC-0019 eliminated.
⤷ specialises P16. [ARC-0019 §6.0](https://github.com/forestrie/devdocs/blob/main/arc/arc-0019-grant-verification-model.md) · [ADR-0048](https://github.com/forestrie/devdocs/blob/main/adr/adr-0048-encoding-owns-grant-wire-layer.md).

### C5 — Only the instance root is liable; meter per checkpoint
Fee liability is 1:1 with the univocity instance root (`chainBinding`); meter
per checkpoint against `CheckpointPublished` events, never per sub-log, and apply
the kill switch **forward-only**. **Why:** recoupment across the hierarchy is the
owner's problem — the operator must not learn or bill sub-delegate economics.
⤷ specialises P14. [ADR-0059](https://github.com/forestrie/devdocs/blob/main/adr/adr-0059-instance-root-fee-accounts.md) · [ARC-0026](https://github.com/forestrie/devdocs/blob/main/arc/arc-0026-onboard-grant-apis-and-fee-tracing.md).

### C6 — Admission policy is deployment config and self-describes
Admission (`vetted | paid | either`) is operator configuration; the redeem/
onboard response states which policy applied and records `admittedBy`. No
silently divergent behaviour between deployments. **Why:** the same API surface
must be auditable regardless of how a lane is configured.
[ARC-0026 §admission](https://github.com/forestrie/devdocs/blob/main/arc/arc-0026-onboard-grant-apis-and-fee-tracing.md).

### C7 — Child-log registration needs the parent grant, not an operator token
Registering a child public root requires the parent's create grant (parent
`K(L)`) — never an operator-issued onboard token. **Why:** hierarchy
independence — the operator is a fungible pipe, it does not confer authority.
⤷ specialises P9. [ADR-0053](https://github.com/forestrie/devdocs/blob/main/adr/adr-0053-child-log-onboarding-parent-authorized.md).

### C8 — CBOR is the default wire format
Responses are CBOR except `/api/health` and scitt-configuration; statement
status is async via 303 keyed on `contentHash`. **Why:** SCRAPI/SCITT interop is
byte-exact — a JSON convenience path drifts from what the contract verifies.
⤷ specialises P16. [arc-context/canopy.md](../arc-context/canopy.md).
