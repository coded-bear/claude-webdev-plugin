---
description: Generate tasks.md with requirement traceability for an SDD feature
argument-hint: <feature-name>
allowed-tools: Read, Write, Glob
---

You are generating the implementation plan for a Spec-Driven Development (SDD) feature. Always adhere to any rules or requirements set out in any CLAUDE.md files when responding.

User input: $ARGUMENTS

## High level behavior

Take the slug from `$ARGUMENTS`, validate that both requirements and design have been drafted, then generate a full `tasks.md` with checkbox phases. Every sub-task must reference one or more requirement IDs, and the closing Coverage Summary must explicitly flag any requirement that has zero covering tasks.

## Step 1. Resolve the slug

The user may pass an exact slug, a Title Case name, or nothing at all. Resolve as follows:

- If `$ARGUMENTS` is empty, infer the slug from the current git branch (`claude/feature/<slug>`). If that fails, ask the user which feature.
- Otherwise normalize the input to a kebab-case slug and `Glob` for `_specs/<slug>/.spec-meta.json`. If exactly one feature folder matches partially, use it. If multiple match, list them and ask the user to pick.

## Step 2. Validate prerequisites

Read `_specs/<slug>/.spec-meta.json`. If it does not exist, abort with:

```
No SDD feature found at _specs/<slug>/. Run `/spec-init <slug> <description>` first.
```

Both `stages.requirements` AND `stages.design` must be `"drafted"` or beyond. If either is missing, abort with a specific message naming the missing step:

```
Requirements are not drafted yet. Run `/spec-requirements <slug>` first.
```

or

```
Design is not drafted yet. Run `/spec-design <slug>` first.
```

If `stages.tasks` is already `"drafted"` or beyond, ask the user to confirm overwrite. Regenerate from scratch on confirmation.

## Step 3. Read context

Read all of:

- `_specs/<slug>/.spec-meta.json`
- `_specs/<slug>/requirements.md` (full content — needed for ID extraction and coverage)
- `_specs/<slug>/design.md` (full content — phase structure follows the design's component breakdown)
- The project's `CLAUDE.md` if present

## Step 3.5. Validate open questions

After reading `design.md` in Step 3, parse its `## Open Questions` section. Find every entry matching the pattern:

```
- **Q<digits>** _(open)_ — <text>
```

If at least one such entry exists, abort with:

```
Cannot proceed: design.md has unresolved open questions:
  Q<n> — <text after the em-dash>
  ...

Resolve them in design.md (mark each as `(resolved: <decision>)` or
`(wont-fix)`) before running /spec-tasks.
```

There is no override flag. If the user wants to proceed without answering a question, they must explicitly mark it `(wont-fix)` so the gap is recorded as a deliberate choice.

Entries with status `(resolved: ...)` or `(wont-fix)` do not block. A section containing only `- (none)` does not block.

## Step 4. Extract requirement IDs

Parse `requirements.md` and collect every requirement ID:

- Numbered acceptance criteria: `1.1`, `1.2`, `2.1`, `2.2`, …
- Non-functional IDs: `NFR-perf`, `NFR-a11y`, `NFR-security`, …

You will need this complete list later for the Coverage Summary.

## Step 5. Generate the tasks document

Produce a complete `tasks.md` with the following sections in this exact order: **Implementation Plan** (with phases), **Requirements Coverage Summary**, **Out of Scope (deferred)**. Apply these rules:

### Phase structure

- Organize phases around the design's component breakdown. Good defaults if the design does not strongly suggest otherwise: `data → API → UI → integration → tests → polish`. Aim for 5–8 phases.
- Each phase has a clear name describing what the phase delivers.

### Sub-task discipline

- Each sub-task must be **small, concrete, and independently verifiable** — a reviewer should be able to check it off in one sitting (a few hours max).
- Use nested numbering: `1.1`, `1.2`, `1.3`, then `2.1`, `2.2`, etc. (phase number . sub-task number).
- Each sub-task is a checkbox: `- [ ]` (always unchecked at generation time).
- Each sub-task ends with an inline requirement reference: `_Requirements: 1.1, 2.3_`. **Tasks without a requirement reference are forbidden** unless explicitly noted as "infra" or "tooling" with a brief justification on the same line — and even then, prefer to find a requirement to cite.

### Verification, audit, and review tasks

For verification, audit, and review sub-tasks, **explicitly invoke the relevant repo agent** rather than describing the activity generically. Map as follows:

- **Accessibility / WCAG audit** → `a11y-auditor` agent → references `NFR-a11y`
- **Performance / re-render / bundle / Web Vitals checks** → `performance-reviewer` agent → references `NFR-perf`
- **Full-diff code review (bugs, types, architecture, security, readability)** → `code-reviewer` agent → references `NFR-security` or any quality NFR
- **Copy, headings, SEO, content quality** → `content-auditor` agent → references the relevant content/SEO NFR if one exists

Phrase these tasks as `<short description> — invoke the \`<agent-name>\` agent on <scope>`, e.g. `Accessibility audit — invoke the \`a11y-auditor\` agent on the booking flow UI`.

A "Review" or "Polish & launch" phase should **always** include a `code-reviewer` pass over the full diff before merge. Include `a11y-auditor` whenever the feature touches UI, `performance-reviewer` whenever it is performance-sensitive (large lists, frequent re-renders, server components, image-heavy, data fetching on hot paths), and `content-auditor` whenever user-facing copy or heading structure changes. Skip an agent task if its concern genuinely does not apply to the feature — do not pad.

For E2E and visual verification tasks where running the app and clicking through is required, prefer the **Playwright MCP** (browser tooling) over describing manual steps.

### Requirements Coverage Summary

- The closing table must list **every requirement ID** you extracted in Step 4, paired with the sub-tasks that cover it.
- **Fail-loud rule:** Any requirement with zero covering tasks must appear in the table with `⚠️ UNCOVERED` in the "Covered by tasks" column. Do not silently omit uncovered requirements — the entire point of this section is to surface gaps.

### Out of Scope (deferred)

- If the design explicitly defers anything, list it here. Otherwise leave a single bullet `- (none)`.

## Step 6. Write the file

Write `_specs/<slug>/tasks.md` with the generated content and frontmatter:

- `status: drafted`
- `created: <today YYYY-MM-DD>`
- `last-updated: <today YYYY-MM-DD>`

## Step 7. Update metadata

Update `_specs/<slug>/.spec-meta.json`:

- `stages.tasks = "drafted"`
- `last_updated = <today YYYY-MM-DD>`

## Step 8. Final output

Print:

```
Generated: _specs/<slug>/tasks.md
Review the Requirements Coverage Summary at the bottom for any ⚠️ UNCOVERED rows.
Implementation is ready to begin.
```

If you generated any `⚠️ UNCOVERED` rows, mention the count explicitly so the user notices:

```
⚠️ N requirement(s) are not covered by any task. Review tasks.md and either add tasks or revise requirements.
```

Do not repeat the tasks content in chat.
