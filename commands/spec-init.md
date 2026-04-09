---
description: Initialize an SDD feature folder (requirements, design, tasks) and branch
argument-hint: <feature-name> <short description>
allowed-tools: Read, Write, Glob, Bash(git switch:\*), Bash(git status:\*), Bash(git branch:\*)
---

You are initializing a new Spec-Driven Development (SDD) feature. Always adhere to any rules or requirements set out in any CLAUDE.md files when responding.

User input: $ARGUMENTS

## High level behavior

Turn the user input above into:

- A kebab-case `feature_slug` and a Title Case `feature_title`
- A new git branch `claude/feature/<feature_slug>`
- A new folder `_specs/<feature_slug>/` containing four files: `requirements.md`, `design.md`, `tasks.md`, `.spec-meta.json`
- A short summary printed to the user telling them which command to run next

`/spec-init` only **scaffolds**. It does NOT generate full requirements — that is the job of `/spec-requirements`. The intent is for the user to review and edit the pre-filled Introduction in `requirements.md` before generation runs.

## Step 1. Check the working tree

Run `git status --porcelain`. If there is any output (uncommitted, unstaged, or untracked files), abort the entire process and tell the user to commit or stash changes before proceeding. DO NOT GO ANY FURTHER.

## Step 2. Parse the arguments

From `$ARGUMENTS`, split on the first whitespace:

- The first token is the raw feature name.
- The remainder is the `description` (free text, may be many words).

Then derive:

1. `feature_slug`
   - Lowercase, kebab-case, only `a-z`, `0-9` and `-`
   - Replace spaces and punctuation with `-`
   - Collapse multiple `-` into one, trim `-` from start and end
   - Maximum length 40 characters
2. `feature_title`
   - Title Case version of the slug (e.g. `card-component` → `Card Component`)
3. `branch_name`
   - Format: `claude/feature/<feature_slug>`

If you cannot infer a sensible `feature_slug` and `description` from the input, ask the user to clarify instead of guessing.

## Step 3. Collision check

Use `Glob` to check whether `_specs/<feature_slug>/` already exists.

- If it does **and** the user clearly typed an existing slug intentionally, ask whether they meant to continue an existing spec or start a new one. Do NOT silently overwrite.
- If it appears to be a coincidental collision, auto-increment the slug by appending `-02`, `-03`, etc. until free. Apply the same auto-increment to the branch name.
- Also check `git branch --list claude/feature/<feature_slug>` to make sure the branch is free, and increment if not.

## Step 4. Switch to a new git branch

Run `git switch -c <branch_name>`.

## Step 5. Create the feature folder and metadata file

Create the folder `_specs/<feature_slug>/` and write the metadata file. Do NOT create stub files for `requirements.md`, `design.md`, or `tasks.md` — those are created by their respective `/spec-*` commands.

### `_specs/<feature_slug>/.spec-meta.json`

Write a JSON file with this exact shape (replace placeholders):

```json
{
  "slug": "<feature_slug>",
  "title": "<feature_title>",
  "description": "<raw description from user>",
  "branch": "<branch_name>",
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

## Step 6. Final output

After all four files are written, print exactly:

```
Branch: <branch_name>
Folder: _specs/<feature_slug>/
Next step: /spec-requirements <feature_slug>
```

Do not repeat the file contents in chat. The goal is to scaffold and report.
