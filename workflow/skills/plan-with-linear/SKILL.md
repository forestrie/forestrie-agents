---
name: plan-with-linear
description: Plan a Forestrie change against a Linear FOR issue and grill the plan against existing ADRs, ARCs, and domain language.
when_to_use: The user wants to plan a feature or fix, mentions a FOR issue, or says "plan this with Linear".
argument-hint: "[FOR-123 | description of the work]"
---

# plan-with-linear

Plan a change with Linear issue tracking and a grilling session against existing
docs and domain language.


Arguments: `$ARGUMENTS`

## 1. Resolve or create Linear issue

Team: **FOR** (Forestrie). Workspace: **forestrie**.

Before the first Linear MCP call, verify identity per linear-mcp-forestrie rules
(`get_user` with `"me"` → `robinbryce@gmail.com`, team **FOR**).

- Search Linear for an existing issue matching the work
- If none exists, create one on team **Forestrie (`FOR`)** with:
  - Title: concise summary
  - Description: problem in one short paragraph
  - Acceptance criteria: testable outcomes (behaviour, tests, observable fixes)

Record the issue id (e.g. `FOR-1234`).

## 2. Load minimal context

| Source | When |
|--------|------|
| [forestrie-agents/AGENTS.md](../../../AGENTS.md) | Bootstrap |
| One [arc-context](../../../arc-context/) file | Domain terms |
| Repo `AGENTS.md` or `forest/agents/AGENTS.md` | Repo-specific routes |
| [devdocs/glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md) | Shared vocabulary |
| Relevant plan or ARC | If user named a path |

Do **not** bulk-load devdocs arc/adr trees or full repo doc trees.

## 3. Run grill-with-docs

Follow [grill-with-docs](../../../vendored/matt-skills/skills/engineering/grill-with-docs/SKILL.md):

- Interview relentlessly; one question at a time with recommended answers
- Challenge terms against [devdocs/glossary.md](https://github.com/forestrie/devdocs/blob/main/glossary.md) and arc-context
- Update repo `CONTEXT.md` or glossary docs lazily when terms crystallise
- Offer ADRs only when hard to reverse, surprising, and trade-off driven — use
  [adr-format](../../rules/adr-format/SKILL.md) for the doc itself, **not** the
  vendored `ADR-FORMAT.md` the skill links to

For Forestrie repos, prefer updating:

- `docs/plans/plan-NNNN-*.md` in the implementing repo for the implementation plan
- **devdocs** for cross-repo ADR/ARC (see [devdocs AGENTS.md](https://github.com/forestrie/devdocs/blob/main/AGENTS.md) ownership table)
- Existing ARC/ADR indexes rather than new monolithic context files

## 4. Output

Once the user approves the plan, run
[persist-plan](../persist-plan/SKILL.md) to write it out per
[plan-docs](../../rules/plan-docs/SKILL.md) (scope, numbering, header, location —
repo `docs/plans/` or devdocs/plans for multi-repo work). Then produce:

1. **Linear issue** updated with link to the persisted plan and acceptance criteria
2. **Behaviours to test** list (not implementation steps) for TDD handoff

## 5. Handoff to implementation

When the user approves the plan:

- Branch name: `robin/for-<issue-no>-<short-desc>` — see [branch-naming](../../rules/branch-naming/SKILL.md)
- Create worktree per repo `AGENTS.md` (`../.worktrees/<repo>-for-<issue>-<slug>`)
- Invoke [tdd](../../../vendored/matt-skills/skills/engineering/tdd/SKILL.md) for vertical slices
- Run [pre-commit-checks](../pre-commit-checks/SKILL.md) before commit

Do not implement until the user confirms the plan.
