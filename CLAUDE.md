# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Claude Code plugin (`claude-webdev-plugin`) that configures a productive web development environment. It is a configuration-only plugin — no build, test, or lint commands. Changes are made by editing JSON and Markdown configuration files directly.

## Plugin Structure

```
.claude-plugin/
  plugin.json          — Plugin metadata (name, version, author)
  marketplace.json     — Marketplace listing for plugin discovery
.claude/
  settings.json        — Claude Code settings (permissions, hooks, env vars, enabled plugins)
.mcp.json              — MCP server definitions
agents/                — Custom agent definitions (Markdown with YAML frontmatter)
skills/                — Custom skill definitions (Markdown with YAML frontmatter)
statusline.sh          — Custom status line script (model, context %, session time, git branch, line stats)
```

## MCP Servers (`.mcp.json`)

- **Context7** — HTTP server for up-to-date library docs and code examples
- **Playwright** — stdio server for browser automation and screenshots
- **shadcn** — UI component registry, configured with tweakcn.com theme registry (`REGISTRY_URL`)

## Settings (`.claude/settings.json`)

- **Hooks**: Prettier runs automatically on Stop (`npx prettier --write .`)
- **Always-thinking** is enabled
- **`frontend-design` plugin** from `claude-plugins-official` is enabled
- **`enableAllProjectMcpServers`** is `false` — MCP servers must be explicitly enabled per-project
- **Environment**: Telemetry, error reporting, bug command, and feedback surveys are disabled
- **Permissions deny-list**: Blocks destructive commands (`rm -rf`, `sudo`, `dd`, `git push --force`, `git reset --hard`) and reads of sensitive paths (`~/.ssh`, `~/.aws`, `~/.gnupg`, credentials files, keychains)

## Agents (`agents/`)

Each agent is a Markdown file with YAML frontmatter (`name`, `description`, `model`, `color`, `tools`):

- **code-reviewer** (opus) — Thorough code review: bugs, architecture, TypeScript, performance, security, readability, testing
- **performance-reviewer** (opus) — React/Next.js performance analysis: re-renders, bundle size, data fetching, server components, images, state management
- **a11y-auditor** (opus) — WCAG accessibility audit: semantics, ARIA, keyboard, contrast, forms, media, dynamic content
- **content-auditor** (sonnet) — Content quality audit: language/grammar, tone, SEO, heading structure, accessibility

## Skills (`skills/`)

Each skill lives in a directory with a `SKILL.md` file (YAML frontmatter with `name`, `description`, `argument-hint`):

- **content-write** — Generates web copy (headlines, CTAs, meta tags) for a given page type, industry, and language. Invoked with `/content-write [page-type] [industry] [language]`

## How to Add New Agents or Skills

- **Agent**: Create a new `.md` file in `agents/` with frontmatter fields: `name`, `description`, `model` (opus/sonnet/haiku), `color`, optionally `tools`
- **Skill**: Create a new directory in `skills/<skill-name>/` with a `SKILL.md` file. Frontmatter fields: `name`, `description`, `argument-hint`. Use `$0`, `$1`, `$2` for positional args and `$ARGUMENTS` for the full string
