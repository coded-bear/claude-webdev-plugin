---
description: Generate full requirements.md (EARS format) for an initialized SDD feature
argument-hint: <feature-name>
allowed-tools: Read, Write, Glob
---

You are generating the requirements document for a Spec-Driven Development (SDD) feature. Always adhere to any rules or requirements set out in any CLAUDE.md files when responding.

User input: $ARGUMENTS

## High level behavior

Take the slug from `$ARGUMENTS`, validate that the feature has been initialized, then generate a full `requirements.md` for it. Each requirement uses **strict EARS syntax** for acceptance criteria so that downstream tasks can reference stable IDs.

Do NOT auto-trigger `/spec-design`. The user runs the next command when they are satisfied with the requirements.

## Step 1. Resolve the slug

The user may pass an exact slug, a Title Case name, or nothing at all. Resolve as follows:

- If `$ARGUMENTS` is empty, infer the slug from the current git branch (`claude/feature/<slug>`). If that fails, ask the user which feature.
- Otherwise normalize the input to a kebab-case slug and `Glob` for `_specs/<slug>/.spec-meta.json`. If exactly one feature folder matches partially, use it. If multiple match, list them and ask the user to pick.

## Step 2. Validate prerequisites

Read `_specs/<slug>/.spec-meta.json`. If it does not exist, abort with:

```
No SDD feature found at _specs/<slug>/. Run `/spec-init <slug> <description>` first.
```

If `stages.requirements` is already `drafted` or beyond, ask the user to confirm overwrite before continuing. If they confirm, regenerate from scratch — do NOT try to merge with the existing content.

## Step 3. Read context

Read all of:

- `_specs/<slug>/.spec-meta.json` (for the original `description` — used to generate the Introduction)
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

- `WHEN <trigger> THEN the system SHALL <observable behavior>.`
- `WHEN <trigger> AND <additional condition> THEN the system SHALL <observable behavior>.`
- `IF <precondition is not met> THEN the system SHALL <error or fallback behavior>.`
- `WHILE <ongoing state> the system SHALL <continuous behavior>.`
- `WHERE <contextual constraint> the system SHALL <conditional behavior>.`

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

## Step 5. Write the file

Write `_specs/<slug>/requirements.md` with the generated content and frontmatter:

- `status: drafted`
- `created: <today YYYY-MM-DD>`
- `last-updated: <today YYYY-MM-DD>`

## Step 6. Update metadata

Update `_specs/<slug>/.spec-meta.json`:

- `stages.requirements = "drafted"`
- `last_updated = <today YYYY-MM-DD>`

## Step 7. Final output

Print:

```
Generated: _specs/<slug>/requirements.md
Please review and edit as needed. When ready, run `/spec-design <slug>`.
```

Do not repeat the requirements content in chat.
