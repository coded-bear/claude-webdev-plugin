---
description: Generate design.md for an SDD feature after requirements are drafted
argument-hint: <feature-name>
allowed-tools: Read, Write, Glob, mcp__context7__resolve-library-id, mcp__context7__query-docs
---

You are generating the technical design document for a Spec-Driven Development (SDD) feature. Always adhere to any rules or requirements set out in any CLAUDE.md files when responding.

User input: $ARGUMENTS

## High level behavior

Take the slug from `$ARGUMENTS`, validate that requirements have been drafted, then generate a full `design.md` for the feature.

Do NOT auto-trigger `/spec-tasks`. The user runs the next command when they are satisfied with the design.

## Step 1. Resolve the slug

The user may pass an exact slug, a Title Case name, or nothing at all. Resolve as follows:

- If `$ARGUMENTS` is empty, infer the slug from the current git branch (`claude/feature/<slug>`). If that fails, ask the user which feature.
- Otherwise normalize the input to a kebab-case slug and `Glob` for `_specs/<slug>/.spec-meta.json`. If exactly one feature folder matches partially, use it. If multiple match, list them and ask the user to pick.

## Step 2. Validate prerequisites

Read `_specs/<slug>/.spec-meta.json`. If it does not exist, abort with:

```
No SDD feature found at _specs/<slug>/. Run `/spec-requirements <slug> <description>` first.
```

Check `stages.requirements`:

- If it is `"pending"`, abort with:
  ```
  Requirements are not drafted yet. Run `/spec-requirements <slug>` first.
  ```
- If it is `"drafted"` or beyond, proceed.

If `stages.design` is already `"drafted"` or beyond, ask the user to confirm overwrite before continuing. Regenerate from scratch on confirmation.

## Step 3. Read context

Read all of:

- `_specs/<slug>/.spec-meta.json`
- `_specs/<slug>/requirements.md` (the full drafted requirements — needed for traceability)
- The project's `CLAUDE.md` if present
- The project's `package.json` if present (for tech stack grounding)

## Step 3.5. Validate open questions

After reading `requirements.md` in Step 3, parse its `## Open Questions` section. Find every entry matching the pattern:

```
- **Q<digits>** _(open)_ — <text>
```

If at least one such entry exists, abort with:

```
Cannot proceed: requirements.md has unresolved open questions:
  Q<n> — <text after the em-dash>
  ...

Resolve them in requirements.md (mark each as `(resolved: <decision>)` or
`(wont-fix)`) before running /spec-design.
```

There is no override flag. If the user wants to proceed without answering a question, they must explicitly mark it `(wont-fix)` so the gap is recorded as a deliberate choice.

Entries with status `(resolved: ...)` or `(wont-fix)` do not block. A section containing only `- (none)` does not block.

## Step 4. Consult Context7 when needed

For any library or framework that will be **load-bearing** in the design (mentioned in requirements, present in `package.json`, or chosen as part of the tech stack), use the Context7 MCP **before** writing the corresponding sections of the design:

1. Call `mcp__context7__resolve-library-id` with the library name.
2. Call `mcp__context7__query-docs` for the specific topic you need (API surface, configuration, version-specific behavior).

**Rule:** Do not invent framework APIs from memory when Context7 is available. Training data may be stale. This applies even to well-known libraries like React, Next.js, Prisma, etc.

Be selective — only consult Context7 for libraries that meaningfully shape the design. Do not query for incidental dependencies.

## Step 5. Generate the design document

Produce a complete `design.md` with the following sections in this exact order: **Overview**, **Architecture**, **Design Decisions**, **Components & Interfaces**, **Data Models**, **Open Questions**. Apply these rules:

### Overview

- Include two subsections: **Goals** (bullet list of what this feature must achieve), **Non-Goals** (what it deliberately avoids).

### Architecture

- Include **at least one Mermaid diagram** showing the major components and how they interact. Choose the form that best explains the feature:
  - `graph TD` for component relationships and data flow
  - `sequenceDiagram` for interaction-heavy features
- A second diagram of the other type is welcome but not required.

### Design Decisions

- Document at least 2 real decisions with Context / Alternatives / Choice / Rationale / Trade-offs. Pick decisions that actually matter for this feature.
- Include technology choices (e.g. which state management library, which validation approach) and security-sensitive patterns (auth, data exposure, input validation) as decisions when they are non-obvious. Do not create separate Technology Stack or Security sections.

### Components & Interfaces

- For each major component, write a TypeScript `interface` block with concrete prop or parameter shapes. Do NOT use `any`. Reference types from the project's existing code where possible.

### Data Models

- Include both **logical** and **physical** representations when the feature involves persistence.
- Skip this section entirely if there is no persistence layer; do not leave it as placeholder.

### Open Questions

Whenever you are not certain about a design-time choice — which library to use, which schema shape to commit to, how to model a state transition, etc. — **do not guess**. Add an entry to the `## Open Questions` section as:

```
- **Q<n>** _(open)_ — <the question, phrased so a human can answer it>
```

Number sequentially starting from `Q1` (the design's `Q*` namespace is independent from `requirements.md`'s). The `## Open Questions` section must always be present in the generated file. If you are confident there are genuinely no open questions, write a single bullet `- (none)` instead.

Open questions are the **only** acceptable place to record uncertainty. Do not commit to an arbitrary library/pattern just to make the section look complete — surface the choice as a Q. `/spec-tasks` will refuse to run while any `(open)` entries remain.

## Step 6. Write the file

Write `_specs/<slug>/design.md` with the generated content and frontmatter:

- `status: drafted`
- `created: <today YYYY-MM-DD>`
- `last-updated: <today YYYY-MM-DD>`

## Step 7. Update metadata

Update `_specs/<slug>/.spec-meta.json`:

- `stages.design = "drafted"`
- `last_updated = <today YYYY-MM-DD>`

## Step 8. Final output

Print:

```
Generated: _specs/<slug>/design.md
Please review. When ready, run `/spec-tasks <slug>`.
```

Do not repeat the design content in chat.
