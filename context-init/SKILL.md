---
name: context-init
description: Explore an unfamiliar codebase in read-only mode and produce a concise onboarding report. Use when the user asks to understand a new repo, onboard onto a project, survey what a codebase does, or starts work in an unfamiliar directory. Covers purpose, tech stack, architecture, current git state, active work, and infrastructure. Does not modify anything.
allowed-tools: Read, Glob, Grep, WebFetch, Bash(git:*), Bash(ls:*), Bash(cat:*), Bash(head:*), Bash(tail:*), Bash(tree:*), Bash(wc:*), Bash(find:*), Bash(which:*), Bash(gh pr *:*), Bash(gh issue *:*), Bash(gh repo view:*)
---

# context-init

Read-only codebase exploration mode. Build a mental model of the project sufficient to contribute meaningfully — without modifying anything.

## Guardrails

- **Read-only.** No Edit, Write, NotebookEdit, or state-mutating commands (commits, pushes, installs, deletes, `git reset`, etc.).
- **Breadth before depth.** Get a shape-of-the-codebase overview first; drill into a specific area only if the user asks.
- **Parallel exploration** is encouraged for large repos — spawn subagents for independent axes (stack, git state, infra, tests).

## What to figure out

1. **What is this?** — Purpose, domain, intended users.
   - Read: `README*`, `CLAUDE.md`, `AGENTS.md`, `docs/`, and the root-level project manifest.
2. **Tech stack** — Languages, frameworks, dependencies, build/test/lint tooling.
   - Inspect whichever exist: `package.json`, `pyproject.toml` / `uv.lock`, `Cargo.toml`, `go.mod`, `Gemfile`, `pom.xml`, `build.gradle`, `Dockerfile`, `.tool-versions`, `mise.toml`.
3. **Architecture** — Directory structure, entry points, key abstractions, data flow, layering (MVC, hexagonal, monorepo, plugin-based, etc.).
4. **Current state** — `git status`, current branch, `git log --oneline -20`, open PRs/issues (`gh pr list`, `gh issue list` if `gh` is available and the repo is on GitHub).
5. **Active work** — `TODO` / `FIXME` / `XXX` / `HACK` markers (capped, don't flood), recent churn: `git log --oneline --since='2 weeks ago' --name-only`.
6. **Infrastructure** — Deployment configs: `Dockerfile`, `docker-compose*`, `.github/workflows/`, `terraform/`, `k8s/`, cloud manifests. Identify target environments if discoverable.
7. **Testing** — Test runner, where tests live, any integration-test subdirs. Don't run them.

Skip any section where no evidence exists — don't pad with speculation.

## Output

Produce this report. Keep each section to a few lines unless the user asked for depth.

```
## Project
[What it is, who it's for — 2 sentences max]

## Stack
[Languages, frameworks, key deps, build/test/lint tools]

## Architecture
[Directory layout, key components, data flow, notable patterns]

## Current State
[Branch, uncommitted changes, recent activity, open PRs/issues]

## Active Work
[What's in progress, what's stale, what needs attention]

## Infrastructure
[Deploy target, CI/CD, cloud services — if applicable]

## Key Files
[Entry points, configs, files worth reading first — absolute paths]
```

$ARGUMENTS
