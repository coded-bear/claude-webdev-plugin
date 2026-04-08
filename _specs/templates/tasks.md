# Tasks — <feature-name>

status: draft
created: <YYYY-MM-DD>
last-updated: <YYYY-MM-DD>
requirements: ./requirements.md
design: ./design.md

## Implementation Plan

This plan is structured as phases. Each sub-task links back to one or more requirement IDs from `requirements.md` for traceability. Tasks should be small enough that a reviewer can check them off in one sitting.

Verification, review, and audit sub-tasks should **explicitly invoke the relevant repo agent** rather than describing the activity in the abstract: `a11y-auditor` for accessibility, `performance-reviewer` for performance, `code-reviewer` for full-diff review, `content-auditor` for copy/headings.

### Phase 1 — <phase name, e.g. "Data model & persistence">

- [ ] 1.1 <concrete, small, independently verifiable task>
      _Requirements: 1.1, 1.2_
- [ ] 1.2 <task>
      _Requirements: 2.1_
- [ ] 1.3 <task>
      _Requirements: 2.2, 2.3_

### Phase 2 — <phase name, e.g. "API layer">

- [ ] 2.1 <task>
      _Requirements: 3.1, 3.2_
- [ ] 2.2 <task>
      _Requirements: 3.3_

### Phase 3 — <phase name, e.g. "UI components">

- [ ] 3.1 <task>
      _Requirements: 4.1_

### Phase 4 — <phase name, e.g. "Integration & wiring">

- [ ] 4.1 <task>
      _Requirements: 1.3, 4.2_

### Phase 5 — <phase name, e.g. "Tests">

- [ ] 5.1 Unit tests for <module>
      _Requirements: 1.1, 1.2_
- [ ] 5.2 Integration tests for <flow>
      _Requirements: 3.1_
- [ ] 5.3 E2E test: <user journey> (Playwright MCP)
      _Requirements: 4.1, 4.2_

### Phase 6 — <phase name, e.g. "Review & launch">

- [ ] 6.1 Accessibility audit — invoke the `a11y-auditor` agent on the touched UI surfaces
      _Requirements: NFR-a11y_
- [ ] 6.2 Performance verification — invoke the `performance-reviewer` agent on the touched React/Next.js code
      _Requirements: NFR-perf_
- [ ] 6.3 Full-diff code review — invoke the `code-reviewer` agent before merge
      _Requirements: NFR-security_
- [ ] 6.4 Content audit (only if user-facing copy or headings changed) — invoke the `content-auditor` agent
      _Requirements: <relevant content / SEO NFR>_

## Requirements Coverage Summary

| Requirement | Covered by tasks |
| ----------- | ---------------- |
| 1.1         | 1.1, 5.1         |
| 1.2         | 1.1, 5.1         |
| 1.3         | 4.1              |
| 2.1         | 1.2              |
| ...         | ...              |

<Any requirement with zero covering tasks must be flagged as `⚠️ UNCOVERED` in the table.>

## Out of Scope (deferred)

- <tasks explicitly deferred to a later feature>
