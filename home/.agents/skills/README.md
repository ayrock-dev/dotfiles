# Shared agent skills

Vendored skills in the cross-harness location `~/.agents/skills/`, discovered by
**both pi** (`~/.pi/agent/skills/` + `~/.agents/skills/`) and **opencode**
(`~/.agents/skills/<name>/SKILL.md`). One copy serves both — no duplication.

## Source

[`mattpocock/skills`](https://github.com/mattpocock/skills) @ `ed37663`
(vendored, not a submodule). To update: re-copy the skill directories from a
fresh clone and review the diff.

## Vendored set

`codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grill-with-docs`,
`grill-me`, `grilling`, `handoff`, `implement`,
`improve-codebase-architecture`, `prototype`, `research`, `tdd`, `teach`,
`writing-great-skills`.

Deliberately omitted: issue-tracker skills (`to-spec`, `to-tickets`,
`to-issues`, `to-prd`, `triage`, `wayfinder`, `setup-matt-pocock-skills`) and
`code-review` (opencode already ships a `code-review` command; the skill also
depends on the omitted tracker setup).

This file is a root `.md`, which both harnesses ignore when discovering skills.
