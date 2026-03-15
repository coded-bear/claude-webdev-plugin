# claude-webdev-plugin

A Claude Code plugin that configures a productive web development environment. It bundles settings, MCP servers, custom agents, skills, and a status line — all ready to use out of the box.

## What's Included

- **Settings** — Prettier auto-formatting on stop, always-thinking mode, telemetry disabled, security deny-list for destructive commands and sensitive paths
- **4 Agents** — Code review, performance analysis, accessibility audit, content audit
- **1 Skill** — Web content writing (`/content-write`)
- **3 MCP Servers** — Context7 (library docs), Playwright (browser automation), shadcn (UI components with tweakcn theme)
- **Custom Status Line** — Shows model name, context usage %, session duration, git branch, and line change stats

## Agents

| Agent                    | Model  | Description                                                                                                              |
| ------------------------ | ------ | ------------------------------------------------------------------------------------------------------------------------ |
| **code-reviewer**        | Opus   | Thorough code review covering bugs, architecture, TypeScript, performance, security, readability, and testing            |
| **performance-reviewer** | Opus   | React/Next.js performance analysis — re-renders, bundle size, data fetching, server components, images, state management |
| **a11y-auditor**         | Opus   | WCAG accessibility audit — semantics, ARIA, keyboard navigation, contrast, forms, media, dynamic content                 |
| **content-auditor**      | Sonnet | Content quality audit — language/grammar, tone consistency, SEO, heading structure, accessibility                        |

## Skills

### `/content-write`

Generates website copy (headlines, CTAs, meta tags) tailored to a specific page type, industry, and language.

```
/content-write landing-page coffee-shop en
/content-write e-commerce tech-startup pl
```

Arguments: `[page-type] [industry/client] [language]`

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

## Customization

- **Add an agent** — Create a new `.md` file in `agents/` with YAML frontmatter (`name`, `description`, `model`, `color`, `tools`)
- **Add a skill** — Create a new directory in `skills/<skill-name>/` with a `SKILL.md` file (frontmatter: `name`, `description`, `argument-hint`)

See [CLAUDE.md](CLAUDE.md) for full details on the plugin structure.

## Author

Łukasz Warchoł

## License

MIT License - see [LICENSE](LICENSE) for details.
