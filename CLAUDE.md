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
  settings.local.json  — User-local overrides (gitignored — not committed)
.mcp.json              — MCP server definitions
agents/                — Custom agent definitions (Markdown with YAML frontmatter)
skills/                — Custom skill definitions (Markdown with YAML frontmatter)
commands/              — Custom slash command definitions (Markdown with YAML frontmatter)
hooks/                 — Hook scripts (currently empty)
statusline.sh          — Two-line status bar: model/context%/session time + git branch/line stats
```

## MCP Servers (`.mcp.json`)

- **Context7** — HTTP server for up-to-date library docs and code examples
- **Playwright** — stdio server for browser automation and screenshots
- **shadcn** — UI component registry, configured with tweakcn.com theme registry (`REGISTRY_URL`)

## Settings (`.claude/settings.json`)

- **Hooks**: Prettier runs automatically on Stop (`npx prettier --write .`)
- **Always-thinking** is enabled
- **`frontend-design` plugin** from `claude-plugins-official` is enabled
- **`enableAllProjectMcpServers`** is `true` — all project-level MCP servers are auto-enabled
- **Environment**: Telemetry, error reporting, bug command, and feedback surveys are disabled
- **Permissions deny-list**: Blocks destructive commands (`rm -rf`, `sudo`, `dd`, `git push --force`, `git reset --hard`) and reads of sensitive paths (`~/.ssh`, `~/.aws`, `~/.gnupg`, credentials files, keychains)

`.claude/settings.local.json` is gitignored and holds user-specific permission overrides (e.g., allowing `WebSearch`, extra bash commands). Do not commit it.

## Agents (`agents/`)

Each agent is a Markdown file with YAML frontmatter (`name`, `description`, `model`, `color`, `tools`):

- **code-reviewer** (opus) — Code review: bugs, architecture, TypeScript, performance, security, readability
- **a11y-reviewer** (sonnet) — WCAG 2.1/2.2 accessibility review: semantics, ARIA, keyboard, focus, forms, media, dynamic content
- **content-reviewer** (sonnet) — Content review: language/grammar, tone, SEO, content quality. Auto-invoked after the `content-write` skill generates content

## Skills (`skills/`)

Each skill lives in a directory with a `SKILL.md` file (YAML frontmatter with `name`, `description`, `argument-hint`):

- **content-write** — Writes web content (copy, headlines, CTAs, meta tags) adapted to page type and project context. Invoked with `/content-write <what to write>`. Triggers `content-reviewer` agent automatically after generation.

## Commands (`commands/`)

Each command is a Markdown file with YAML frontmatter (`description`, `argument-hint`, `allowed-tools`):

- `/spec-requirements <feature-name> [description]` — SDD stage 1. See [SDD Workflow](#sdd-workflow) below.
- `/spec-design <feature-name>` — SDD stage 2.
- `/spec-tasks <feature-name>` — SDD stage 3.
- `/commit-message` — Analyzes staged git changes and proposes a conventional-commit message with an emoji prefix (`✨ feat`, `🐛 fix`, `🔨 refactor`, `📝 docs`, `🎨 style`, `✅ test`, `⚡ perf`). Explains _why_ rather than just _what_, and asks for confirmation before committing.

## SDD Workflow

Spec-Driven Development (SDD) is the workflow for planning features with traceability between requirements, design, and implementation tasks.

The workflow is sequential, with explicit review gates between stages:

1. `/spec-requirements <slug> <description>` — Creates branch `claude/feature/<slug>` and folder `_specs/<slug>/`. Generates `requirements.md` (EARS format with stable numbered IDs, user stories, acceptance criteria). On re-runs, regenerates requirements only. **Review and edit** before continuing.
2. `/spec-design <slug>` — Generates `design.md` (architecture, Mermaid diagrams, design decisions, components, data models). Consults Context7 MCP for library docs. Blocks if requirements are not drafted or have unresolved open questions.
3. `/spec-tasks <slug>` — Generates `tasks.md` with phased implementation plan. Each sub-task carries `_Requirements: X.Y_` traceability. Closing Coverage Summary flags any `⚠️ UNCOVERED` requirements. Blocks if requirements or design are missing.
4. Implement, ticking off checkboxes in `tasks.md` as you go.

SDD artifact structure:

```
_specs/<slug>/
  .spec-meta.json      — Stage status, branch, timestamps, description (command-owned, do not hand-edit)
  requirements.md      — EARS-format requirements with numbered IDs
  design.md            — Technical design with Mermaid diagrams
  tasks.md             — Implementation tasks with requirement traceability
```

Design rules:

- **No auto-advance** — each command stops and tells the user to review before manually running the next step.
- **Idempotent re-runs** — generation commands ask for confirmation before overwriting, then regenerate from scratch (no merging).
- Only `/spec-requirements` (on first run) touches git. The other commands assume the user is already on the feature branch.

## How to Add New Agents, Skills, or Commands

- **Agent**: Create a new `.md` file in `agents/` with frontmatter fields: `name`, `description`, `model` (opus/sonnet/haiku), `color`, optionally `tools`
- **Skill**: Create a new directory in `skills/<skill-name>/` with a `SKILL.md` file. Frontmatter fields: `name`, `description`, `argument-hint`. Use `$0`, `$1`, `$2` for positional args and `$ARGUMENTS` for the full string
- **Command**: Create a new `.md` file in `commands/` with frontmatter fields: `description`, `argument-hint`, `allowed-tools`. Use `$ARGUMENTS` for the full argument string. Invoke it with `/<command-name>`
