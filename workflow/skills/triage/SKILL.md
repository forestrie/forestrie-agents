---
name: triage
description: "Triage a Linear issue or GitHub item for team FOR: classify, route to design or implementation, and update Linear."
when_to_use: The user says "triage this", pastes a FOR issue id, or asks what should happen with an incoming issue.
argument-hint: "[FOR-123 | issue URL]"
---

# triage

Triage a Linear issue or GitHub item for team **FOR** (Forestrie).


Arguments: `$ARGUMENTS`

## 1. Load context

- Issue title, description, labels, priority
- Linked PRs or parent initiative
- The relevant `arc-*` glossary skill if domain-specific
- [devdocs/glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md) if terminology is ambiguous

## 2. Classify

| Outcome | Action |
|---------|--------|
| Ready to implement | Assign, estimate, link to project |
| Needs design | Run [plan-with-linear](../plan-with-linear/SKILL.md) |
| Duplicate | Link duplicate, close or merge |
| External blocker | Note dependency, set blocked state |
| Cross-repo | Identify primary repo; note sibling repos in comment |

## 3. Update Linear

Team key: **FOR**. Workspace: **forestrie**.

Before MCP calls, verify identity per linear-mcp-forestrie rules.

Use Linear MCP (Cursor OAuth) or API with `LINEAR_API_KEY` from
`~/Dev/personal/forestrie/.envrc` when present.

Add a triage comment: scope summary, suggested next step, links to docs.

## 4. Do not

- Guess issue IDs outside Forestrie workspace
- Paste secrets into issue comments
- Use Just Games **ENG** team conventions
