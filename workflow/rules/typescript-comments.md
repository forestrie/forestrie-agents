# TypeScript comments

**Scope:** TypeScript source in Forestrie repos (canopy Workers, mandate UI,
univocity-tools CLIs).

Forestrie runs a **multi-repo platform**. The "why" of local code often depends
on sibling services, Go microservices, or on-chain contracts. Comments must make
that context reachable without duplicating platform docs.

## Principles

1. **Signpost, don't silo.** At file and function level, state how the local
   code fits the wider picture: assumptions about other components, contracts
   honoured, and where to read more.
2. **Brief with a pointer.** One or two sentences plus a reference is enough in
   most cases.
3. **Explain purpose, not syntax.** Comments describe the **problem** or **role**
   so readers can cross-check the implementation.
4. **Non-obvious details only at line level.** Line comments are for surprising
   constraints, not narrating control flow.
5. **Full coverage of public surfaces.** Every exported **function**, **method**,
   and **type** should have a comment describing its role. Use `@param` /
   `@returns` where they add contract information.

## Cross-repo signposts

Prefer stable **GitHub blob links** to forestrie repos:

| Target | Link form |
|--------|-----------|
| Same repo doc | `https://github.com/forestrie/<repo>/blob/main/docs/…` |
| Platform ARC/ADR | [devdocs/arc/](https://github.com/forestrie/devdocs/tree/main/arc), [devdocs/adr/](https://github.com/forestrie/devdocs/tree/main/adr) |
| Glossary | [devdocs/glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md) |
| Canopy | [canopy/docs/](https://github.com/forestrie/canopy/tree/main/docs) |
| Arbor / Go deps | [arbor/services/_deps](https://github.com/forestrie/arbor/tree/main/services/_deps) |
| MMR COSE profile | [draft-bryce-cose-receipts-mmr-profile](https://github.com/robinbryce/draft-bryce-cose-receipts-mmr-profile) |
| Common arc-context | [forestrie-agents/arc-context/](../../arc-context/) |

Within a comment, name the **remote component**, the **contract** (SCRAPI route,
queue message, grant shape, on-chain call), and what this code **assumes** vs
**guarantees**.

## When editing

- Cross-repo behaviour change → add or update signpost comments in the same change.
- Do not copy ARC/ADR prose into source — link and state the local obligation.
