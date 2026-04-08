# claude-webdev-plugin

A Claude Code plugin that configures a productive web development environment. It bundles settings, MCP servers, custom agents, skills, and a status line — all ready to use out of the box.

## What's Included

- **Settings** — Prettier auto-formatting on stop, always-thinking mode, telemetry disabled, security deny-list for destructive commands and sensitive paths
- **4 Agents** — Code review, performance analysis, accessibility audit, content audit
- **1 Skill** — Web content writing (`/content-write`)
- **6 Commands** — Quick single-file spec scaffolder (`/spec-quick`), full Spec-Driven Development workflow (`/spec-init`, `/spec-requirements`, `/spec-design`, `/spec-tasks`), and conventional-commit message generator (`/commit-message`)
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

## Commands

### `/spec-quick`

Scaffolds a new feature by creating a git branch (`claude/feature/<slug>`) and a single detailed spec file under `_specs/<slug>.md` from a short idea. Aborts if there are uncommitted changes in the working tree. Use this for small features where the full SDD workflow would be overkill.

```
/spec-quick Card component for dashboard stats
/spec-quick New heist form
```

Arguments: `<short feature description>`

### Spec-Driven Development workflow

For non-trivial features where you want requirements → design → tasks traceability, use the SDD workflow. Each command is one stage, with an explicit review gate before the next.

| Command                           | Purpose                                                                                                                                 |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `/spec-init <slug> <description>` | Scaffold `_specs/<slug>/` (requirements, design, tasks, .spec-meta.json) and create the feature branch. Aborts on a dirty working tree. |
| `/spec-requirements <slug>`       | Generate `requirements.md` with strict EARS-format acceptance criteria (`WHEN/IF/WHILE/WHERE … THEN the system SHALL …`)                |
| `/spec-design <slug>`             | Generate `design.md` from requirements — architecture, Mermaid diagrams, design decisions, data models, error handling. Uses Context7.  |
| `/spec-tasks <slug>`              | Generate `tasks.md` from requirements + design. Each sub-task references requirement IDs; uncovered requirements are flagged.           |

Worked example:

```
/spec-init card-component Dashboard stats card with title, value, and trend
/spec-requirements card-component
# review _specs/card-component/requirements.md, edit as needed
/spec-design card-component
# review design.md
/spec-tasks card-component
# review tasks.md, check the Coverage Summary, start implementing
```

**When to use which:** rule of thumb — if the feature will take more than a day or touches more than three files, use `/spec-init`. Otherwise `/spec-quick` is faster and lighter.

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

## Customization

- **Add an agent** — Create a new `.md` file in `agents/` with YAML frontmatter (`name`, `description`, `model`, `color`, `tools`)
- **Add a skill** — Create a new directory in `skills/<skill-name>/` with a `SKILL.md` file (frontmatter: `name`, `description`, `argument-hint`)
- **Add a command** — Create a new `.md` file in `commands/` with YAML frontmatter (`description`, `argument-hint`, `allowed-tools`) and use `$ARGUMENTS` in the body

See [CLAUDE.md](CLAUDE.md) for full details on the plugin structure.

## Author

Łukasz Warchoł

## License

MIT License - see [LICENSE](LICENSE) for details.
