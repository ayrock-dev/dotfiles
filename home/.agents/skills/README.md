# Shared agent skills

Vendored skills in the cross-harness location `~/.agents/skills/`, discovered by
pi (`~/.pi/agent/skills/` + `~/.agents/skills/`).

## Source

[`mattpocock/skills`](https://github.com/mattpocock/skills) @ `ed37663`
(vendored, not a submodule). To update: re-copy the skill directories from a
fresh clone and review the diff.

## Vendored set

`code-review`, `codebase-design`, `diagnosing-bugs`, `domain-modeling`,
`grill-with-docs`, `grill-me`, `grilling`, `handoff`, `implement`,
`improve-codebase-architecture`, `prototype`, `research`, `tdd`, `teach`,
`writing-great-skills`.

`code-review` is adapted to drop the omitted mattpocock tracker setup; it fetches
issue specs opportunistically via `gh` when a reference is present.

Deliberately omitted: issue-tracker skills (`to-spec`, `to-tickets`,
`to-issues`, `to-prd`, `triage`, `wayfinder`, `setup-matt-pocock-skills`).

This file is a root `.md`, which pi ignores when discovering skills.
