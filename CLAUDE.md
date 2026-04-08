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
commands/              — Custom slash command definitions (Markdown with YAML frontmatter)
_specs/
  templates/           — Templates used by the SDD workflow (requirements, design, tasks)
  <feature-slug>/      — One folder per SDD feature (created by /spec-init)
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

## Commands (`commands/`)

Each command is a Markdown file with YAML frontmatter (`description`, `argument-hint`, `allowed-tools`):

- **spec-quick** — Turns a short feature idea into a kebab-case title, a new git branch (`claude/feature/<slug>`), and a detailed single-file spec in `_specs/<slug>.md` based on `_specs/template.md`. Aborts if the working tree is dirty. Invoked with `/spec-quick <short feature description>`
- **spec-init** — First step of the SDD workflow. Creates `_specs/<slug>/` with stub `requirements.md`, `design.md`, `tasks.md`, and `.spec-meta.json`, plus a new git branch. Aborts if the working tree is dirty. Invoked with `/spec-init <feature-name> <description>`
- **spec-requirements** — Generates a full `requirements.md` for an initialized SDD feature using strict EARS-format acceptance criteria with stable numbered IDs. Invoked with `/spec-requirements <feature-name>`
- **spec-design** — Generates a full `design.md` (architecture, Mermaid diagrams, design decisions, data models, error handling, testing, security) once requirements are drafted. Consults the Context7 MCP for load-bearing libraries. Invoked with `/spec-design <feature-name>`
- **spec-tasks** — Generates a full `tasks.md` once both requirements and design are drafted. Each sub-task carries an inline `_Requirements: X.Y_` reference and the closing Coverage Summary flags any uncovered requirements as `⚠️ UNCOVERED`. Invoked with `/spec-tasks <feature-name>`
- **commit-message** — Analyzes staged git changes and proposes a conventional-commit message with an emoji prefix (`✨ feat`, `🐛 fix`, `🔨 refactor`, `📝 docs`, `🎨 style`, `✅ test`, `⚡ perf`). Explains _why_ rather than just _what_, and asks for confirmation before committing. Invoked with `/commit-message`

## SDD Workflow

Spec-Driven Development is the structured counterpart to `/spec-quick`. Use it for non-trivial features where you want traceability between requirements, design, and implementation tasks.

The workflow is sequential, with explicit review gates between stages:

1. `/spec-init <slug> <description>` — scaffold the feature folder and branch
2. `/spec-requirements <slug>` — generate EARS-format requirements; **review and edit** the file before continuing
3. `/spec-design <slug>` — generate the design from the requirements; review
4. `/spec-tasks <slug>` — generate the implementation plan with traceability back to requirements; review the Coverage Summary
5. Implement, ticking off checkboxes in `tasks.md` as you go.

Design rules baked into the commands:

- **Fail-closed validation** — `/spec-design` refuses to run if requirements are not drafted; `/spec-tasks` refuses to run if either prior stage is missing.
- **No auto-advance** — each command stops and tells the user to review before manually running the next step.
- **Idempotent re-runs** — the generation commands ask for confirmation before overwriting an already-drafted file, then regenerate from scratch (no merging).
- **`_specs/<slug>/.spec-meta.json`** is owned by the commands and tracks stage status, branch, timestamps, and the original description. Do not hand-edit it.
- Only `/spec-init` touches git. The other commands assume the user is already on the feature branch and may be iterating on docs alongside implementation.

When to use `/spec-quick` vs `/spec-init`: rule of thumb — if the feature will take more than a day or touches more than three files, use `/spec-init`. Otherwise `/spec-quick` is faster and lighter.

## How to Add New Agents, Skills, or Commands

- **Agent**: Create a new `.md` file in `agents/` with frontmatter fields: `name`, `description`, `model` (opus/sonnet/haiku), `color`, optionally `tools`
- **Skill**: Create a new directory in `skills/<skill-name>/` with a `SKILL.md` file. Frontmatter fields: `name`, `description`, `argument-hint`. Use `$0`, `$1`, `$2` for positional args and `$ARGUMENTS` for the full string
- **Command**: Create a new `.md` file in `commands/` with frontmatter fields: `description`, `argument-hint`, `allowed-tools`. Use `$ARGUMENTS` for the full argument string. Invoke it with `/<command-name>`
