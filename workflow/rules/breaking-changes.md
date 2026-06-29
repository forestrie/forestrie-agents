# Breaking changes and compatibility

Unless the user **explicitly** asks for backward compatibility, migration shims,
feature flags, dual code paths, or legacy env/alias support:

- **Prefer a hard cutover**: remove old names, old config keys, and deprecated
  branches rather than keeping fallbacks "for one release."
- **Planning**: If a hard cutover implies **data reset**, **schema mutation**,
  **secret renames**, or **operational steps** in existing systems (CI, Doppler,
  deployed envs, SequencingQueue state), **call that out during planning** so
  owners can schedule the work.
- **Default assumption** when tradeoffs are unclear: **reset and recreate**
  (e.g. redeploy, re-seed, rotate secrets) rather than invest in incremental
  migration machinery—unless the user or plan states otherwise.

Do not add legacy aliases, deprecated env var bridges, or "temporary" dual-read
logic without direct user instruction.
