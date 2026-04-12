# claude-webdev-plugin

A Claude Code plugin that configures a productive web development environment. It bundles settings, MCP servers, custom agents, skills, and a status line — all ready to use out of the box.

## What's Included

- **Settings** — Prettier auto-formatting on stop, always-thinking mode, telemetry disabled, security deny-list for destructive commands and sensitive paths
- **Custom Status Line** — Shows model name, context usage %, session duration, git branch, and line change stats
- agents, commands, skills, MCP servers — see sections below

## Agents

| Agent                | Model  | Description                                                                                          |
| -------------------- | ------ | ---------------------------------------------------------------------------------------------------- |
| **code-reviewer**    | Opus   | Code review — bugs, architecture, TypeScript, performance, security, readability                     |
| **a11y-reviewer**    | Sonnet | WCAG 2.1/2.2 accessibility review — semantics, ARIA, keyboard, focus, forms, media, dynamic content  |
| **content-reviewer** | Sonnet | Content review — language/grammar, tone, SEO, content quality. Auto-invoked after content generation |

## Skills

| Skill            | Description                                                                                    | Arguments         |
| ---------------- | ---------------------------------------------------------------------------------------------- | ----------------- |
| `/content-write` | Writes web content (copy, headlines, CTAs, meta tags) adapted to page type and project context | `<what to write>` |

## Commands

### Spec-Driven Development workflow

For non-trivial features where you want requirements → design → tasks traceability, use the SDD workflow. Each command is one stage, with an explicit review gate before the next.

| Command                                   | Purpose                                                                                                                |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `/spec-requirements <slug> <description>` | Initialize feature (branch + folder + `.spec-meta.json`) and generate `requirements.md` with EARS-format criteria.     |
| `/spec-design <slug>`                     | Generate `design.md` from requirements — architecture, Mermaid diagrams, design decisions, data models. Uses Context7. |
| `/spec-tasks <slug>`                      | Generate `tasks.md` from requirements + design. Each sub-task references requirement IDs; uncovered gaps are flagged.  |

Worked example:

```
/spec-requirements card-component Dashboard stats card with title, value, and trend
# review _specs/card-component/requirements.md, edit as needed
/spec-design card-component
# review design.md
/spec-tasks card-component
# review tasks.md, check the Coverage Summary, start implementing
```

### `/commit-message`

Analyzes staged git changes and proposes a conventional-commit message with an emoji prefix. Explains _why_ something changed, not just _what_, and asks for confirmation before committing.

```
/commit-message
```

Supported types: `✨ feat`, `🐛 fix`, `🔨 refactor`, `📝 docs`, `🎨 style`, `✅ test`, `⚡ perf`

## MCP Servers

| Server         | Type  | Description                                                             |
| -------------- | ----- | ----------------------------------------------------------------------- |
| **Context7**   | HTTP  | Up-to-date library documentation and code examples                      |
| **Playwright** | stdio | Browser automation, screenshots, and accessibility snapshots            |
| **shadcn**     | stdio | UI component registry with [tweakcn](https://tweakcn.com) theme support |

## Installation

From the marketplace:

```
/plugin marketplace add coded-bear/claude-webdev-plugin
```

Then install the plugin:

```
/plugin install claude-webdev-plugin
```

## Author

Łukasz Warchoł

## License

MIT License - see [LICENSE](LICENSE) for details.
