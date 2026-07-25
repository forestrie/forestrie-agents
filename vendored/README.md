# vendored

Third-party agent content, pinned by git SHA. **Do not edit files in place.**

| Source | Path | Record |
|--------|------|--------|
| matt-skills | [matt-skills/](./matt-skills/) | [VENDOR.md](./matt-skills/VENDOR.md) |

To extend a vendored skill, add an overlay of the **same name** under
[workflow/skills/](../workflow/skills/) or repo `forest/agents/skills/` —
[`bin/forestrie-agents-sync`](../bin/forestrie-agents-sync) applies sources in
that order, so the overlay shadows the vendored skill rather than colliding
with it.

**Alternative:** use the full sibling checkout at
`~/Dev/personal/forestrie/matt-skills/` and treat this vendored subtree as the
pinned subset for offline / link-stable references.
