# Requirements — <feature-name>

status: draft
created: <YYYY-MM-DD>
last-updated: <YYYY-MM-DD>

## Introduction

<1–3 paragraphs. What problem does this feature solve? Who is it for? What is the scope, and what is explicitly out of scope at a high level? Keep this grounded in user value, not implementation details.>

## Requirements

### Requirement 1 — <short title>

**Objective:** As a <role>, I want <capability>, so that <benefit>.

**Acceptance Criteria**

1.1 WHEN <trigger condition> THEN the system SHALL <observable behavior>.
1.2 WHEN <trigger condition> AND <additional condition> THEN the system SHALL <observable behavior>.
1.3 IF <precondition is not met> THEN the system SHALL <error or fallback behavior>.
1.4 WHILE <ongoing state> the system SHALL <continuous behavior>.
1.5 WHERE <contextual constraint> the system SHALL <conditional behavior>.

### Requirement 2 — <short title>

**Objective:** As a <role>, I want <capability>, so that <benefit>.

**Acceptance Criteria**

2.1 WHEN <condition> THEN the system SHALL <behavior>.
2.2 ...

<Add Requirement 3, 4, 5, … as needed. Typical features have 4–7 requirements covering distinct user-visible capabilities.>

## Open Questions

> Questions that do not yet have an answer. In headless mode, ambiguities land
> here instead of blocking on `AskUserQuestion`. `/spec-design` refuses to run
> if any entry below still has status `(open)`.

- **Q1** _(open)_ — <question that needs an answer, e.g. "Should auth use OAuth or magic link?">
- **Q2** _(resolved: yes, OAuth Google)_ — <previously open question kept as a decision record>
- **Q3** _(wont-fix)_ — <question deliberately left unanswered, out of scope>

<If there are no open questions, replace the bullets above with a single `- (none)` so the absence is explicit.>

## Non-Functional Requirements

- **Performance:** <budgets, e.g. p95 latency, time-to-interactive, bundle size>
- **Accessibility:** <WCAG level, keyboard support, screen reader support>
- **Security & privacy:** <auth, PII handling, rate limiting, input validation>
- **Browser / device support:** <matrix of supported targets>
- **Internationalization:** <language support, RTL, date / number / currency formatting>

## Out of Scope

- <explicitly listed things this feature will NOT do — at least one entry is required>
