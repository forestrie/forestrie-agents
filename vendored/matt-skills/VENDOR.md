# matt-skills vendored snapshot

| Field | Value |
|-------|-------|
| Upstream | https://github.com/mattpocock/skills |
| Local source | matt-skills checkout |
| Pinned SHA | `b8be62ffacb0118fa3eaa29a0923c87c8c11985c` |
| Skills | tdd, diagnose, grill-with-docs |
| License | See upstream repository |

Do not edit files under `skills/` in place. Add Forestrie overlays under
`workflow/skills/` or repo `forest/agents/skills/`.

## Local deltas

Where an overlay would mean duplicating an entire skill to change one line, the
change is instead carried as a **tracked patch** in [patches/](./patches/). The
patched file is committed in its patched state — the patch exists so the delta
is visible, reviewable, and reproducible across a re-vendor, not to be applied
at build time.

| Patch | Skill | What it changes | Why |
|-------|-------|-----------------|-----|
| [0001-tdd-standing-default.patch](./patches/0001-tdd-standing-default.patch) | `tdd` | `description` only | Makes `/tdd` a **standing default** rather than an opt-in |

### 0001 — tdd as the standing default

Upstream's description triggers the skill on an explicit ask ("mentions
red-green-refactor", "asks for test-first development"). That makes TDD
something you have to remember to invoke, which is the opposite of a discipline.

The delta rewrites the description so the skill auto-applies to implementation
and test work generally — writing or changing production code or tests, fixing
bugs, reviewing test quality, refactoring with coverage.

**Only the `description` field changes.** The body and all five supporting
files (`deep-modules.md`, `interface-design.md`, `mocking.md`,
`refactoring.md`, `tests.md`) are byte-identical to upstream, which is exactly
why this is a patch and not an overlay.

Note the blast radius: `description` is what the agent reads to decide whether
to load a skill, so this widens when `/tdd` fires in **every** repo that
installs these skills.

## Re-vendoring

When bumping the pinned SHA:

1. Replace `skills/` wholesale from the new upstream checkout.
2. Re-apply each patch in `patches/` in filename order, from the repo root:

   ```bash
   git apply vendored/matt-skills/patches/*.patch
   ```

3. If a patch no longer applies, upstream has changed the same lines. Resolve
   deliberately — re-cut the patch against the new text, or drop it if upstream
   has adopted the same intent — and update this file. Do **not** skip it
   silently; a dropped delta is a silent behaviour change.
4. Update the pinned SHA above.

To check a patch is still an accurate description of the working tree:

```bash
git apply -R --check vendored/matt-skills/patches/0001-tdd-standing-default.patch
```

Success means the committed file still matches the patched state.
