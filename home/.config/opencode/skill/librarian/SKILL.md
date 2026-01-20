---
name: librarian
description: Multi-repository codebase exploration. Research library internals, find code patterns, understand architecture, compare implementations across GitHub/npm/PyPI/crates. Use when needing deep understanding of how libraries work, finding implementations across open source, or exploring remote repository structure.
references:
  - references/linking.md
  - references/diagrams.md
---

# Librarian Skill

Deep codebase exploration across remote repositories.

## How to Use This Skill

### Reference Structure

| File | Purpose | When to Read |
|------|---------|--------------|
| `linking.md` | GitHub URL patterns | Formatting responses |
| `diagrams.md` | Mermaid patterns | Visualizing architecture |

## Tool Arsenal

| Tool | Best For | Limitations |
|------|----------|-------------|
| **grep_app** | Find patterns across ALL public GitHub | Literal search only |

## Critical: Source Naming Convention

| Type | Fetch Spec | Source Name |
|------|------------|-------------|
| npm | `"zod"` | `"zod"` |
| npm scoped | `"@tanstack/react-query"` | `"@tanstack/react-query"` |
| pypi | `"pypi:requests"` | `"requests"` |
| crates | `"crates:serde"` | `"serde"` |
| GitHub | `"vercel/ai"` | `"github.com/vercel/ai"` |
| GitLab | `"gitlab:org/repo"` | `"gitlab.com/org/repo"` |

## Output Guidelines

**Before responding:** Always read `linking.md` + `diagrams.md` for output formatting

1. **Comprehensive final message** - only last message returns to main agent
2. **Parallel tool calls** - maximize efficiency
3. **Link every file reference** - see `linking.md`
4. **Diagram complex relationships** - see `diagrams.md`

## References

- [GitHub Linking Patterns](references/linking.md)
- [Mermaid Diagram Patterns](references/diagrams.md)
