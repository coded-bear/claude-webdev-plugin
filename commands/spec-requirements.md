---
description: Initialize an SDD feature and generate requirements.md (EARS format)
argument-hint: <feature-name> [description]
allowed-tools: Read, Write, Glob, Bash(git switch:*), Bash(git status:*), Bash(git branch:*)
---

You are generating the requirements document for a Spec-Driven Development (SDD) feature. Always adhere to any rules or requirements set out in any CLAUDE.md files when responding.

User input: $ARGUMENTS

## High level behavior

If the feature folder does not exist yet, initialize it (branch + folder + metadata). Then generate a full `requirements.md`. On re-runs (metadata already exists), skip initialization and regenerate requirements only.

Do NOT auto-trigger `/spec-design` or `/spec-tasks`. The user runs the next command when they are satisfied with the requirements.

## Step 1. Parse arguments & determine mode

From `$ARGUMENTS`, split on the first whitespace:

- The first token is the raw feature name.
- The remainder is the `description` (free text, may be many words).

Derive:

1. `feature_slug` — lowercase kebab-case (`a-z 0-9 -`), max 40 chars
2. `feature_title` — Title Case of slug (`card-component` → `Card Component`)

Then `Glob` for `_specs/<feature_slug>/.spec-meta.json`:

- **Not found (INIT mode):** `description` is required. If no description was provided, ask the user. Proceed to Step 2.
- **Found (RE-RUN mode):** `description` is ignored (already in `.spec-meta.json`). Skip to Step 3.

If `$ARGUMENTS` is entirely empty, infer the slug from the current git branch (`claude/feature/<slug>`). If that fails, ask the user which feature.

## Step 2. Initialize feature (INIT mode only)

1. **Working tree check** — `git status --porcelain`. If any output, abort: tell user to commit or stash. DO NOT GO ANY FURTHER.
2. **Collision check** — Glob `_specs/<feature_slug>/` + `git branch --list claude/feature/<feature_slug>`. If taken, auto-increment slug (`-02`, `-03`, …).
3. **Create branch** — `git switch -c claude/feature/<feature_slug>`.
4. **Create folder and metadata** — Create `_specs/<feature_slug>/` and write `.spec-meta.json`:

```json
{
  "slug": "<feature_slug>",
  "title": "<feature_title>",
  "description": "<raw description from user>",
  "branch": "claude/feature/<feature_slug>",
  "created": "<YYYY-MM-DD>",
  "last_updated": "<YYYY-MM-DD>",
  "stages": {
    "requirements": "pending",
    "design": "pending",
    "tasks": "pending"
  }
}
```

This file is owned by the `/spec-*` commands. The user should not hand-edit it.

## Step 3. Validate and read context

Read `_specs/<feature_slug>/.spec-meta.json`. In RE-RUN mode, if it does not exist, abort with:

```
No SDD feature found at _specs/<slug>/. Run `/spec-requirements <slug> <description>` to initialize.
```

If `stages.requirements` is already `drafted` or beyond, ask the user to confirm overwrite before continuing. If they confirm, regenerate from scratch — do NOT try to merge with the existing content.

Then read:

- `.spec-meta.json` `description` field (used to generate the Introduction)
- The project's `CLAUDE.md` if present (for codebase-specific conventions)

## Step 4. Generate the requirements document

Produce a complete `requirements.md` with the following sections in this exact order: **Introduction**, **Requirements**, **Open Questions**, **Non-Functional Requirements**, **Out of Scope**. Apply these rules:

### Introduction

- Generate 2–3 grounded paragraphs covering problem, audience, and high-level scope, based on the `description` from `.spec-meta.json`.

### Requirements (the body of the doc)

- Write **4–7 requirements**, each covering a distinct user-visible capability inferred from the Introduction and the original description.
- Each requirement has:
  - A short title in the H3 heading
  - An **Objective** in user-story form: `As a <role>, I want <capability>, so that <benefit>.`
  - **At least 4 Acceptance Criteria** numbered as `<requirement_number>.<criterion_number>` (e.g. `1.1`, `1.2`, `2.1`, …). These IDs must be stable — `tasks.md` will reference them.

**EARS syntax is mandatory** for every acceptance criterion. Allowed forms:

| Keyword | Pattern                                                              |
| ------- | -------------------------------------------------------------------- |
| WHEN    | `WHEN <trigger> [AND <condition>] THEN the system SHALL <behavior>.` |
| IF      | `IF <precondition not met> THEN the system SHALL <fallback>.`        |
| WHILE   | `WHILE <state> the system SHALL <continuous behavior>.`              |
| WHERE   | `WHERE <constraint> the system SHALL <conditional behavior>.`        |

Every criterion must be **observable and testable**. Avoid implementation details (no specific component names, no DB column names — that belongs in design).

### Non-Functional Requirements

This section must be **filled in**, not left as placeholder. Infer sensible defaults from the project's tech stack and the feature's nature. At minimum cover Performance, Accessibility, and Security. Mark `NFR-<topic>` IDs (e.g. `NFR-perf`, `NFR-a11y`) so tasks can reference them.

### Out of Scope

This section must contain **at least one explicit exclusion**. If the description does not obviously suggest one, derive at least one by stating what an adjacent feature might cover but this one will not.

### Open Questions

Whenever you are not certain about an assumption — interpretation of a vague description, choice between auth options, scope of an edge case, ambiguous user role, etc. — **do not guess**. Add an entry to the `## Open Questions` section as:

```
- **Q<n>** _(open)_ — <the question, phrased so a human can answer it>
```

Number sequentially starting from `Q1`. The `## Open Questions` section must always be present in the generated file. If you are confident there are genuinely no open questions, write a single bullet `- (none)` instead.

This section is the **only** acceptable place to record uncertainty. Do not bake guesses into "the system SHALL …" lines and do not silently widen scope to cover an unstated case — surface it as a Q instead. `/spec-design` will refuse to run while any `(open)` entries remain.

## Step 5. Write file and update metadata

Write `_specs/<slug>/requirements.md` with frontmatter: `status: drafted`, `created: <today YYYY-MM-DD>`, `last-updated: <today YYYY-MM-DD>`.

Update `_specs/<slug>/.spec-meta.json`: set `stages.requirements = "drafted"` and `last_updated = <today YYYY-MM-DD>`.

## Step 6. Final output

Print (include the `Branch:` line only in INIT mode):

```
Branch: claude/feature/<slug>
Generated: _specs/<slug>/requirements.md
Please review and edit as needed. When ready, run `/spec-design <slug>`.
```

Do not repeat the requirements content in chat.
