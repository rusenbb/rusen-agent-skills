# rusen-research

Personal [Claude Code plugin](https://docs.claude.com/en/docs/claude-code/plugins) bundling a research workflow for the [rusen-brain](https://github.com/rusenbb/rusen-brain) Obsidian vault.

The plugin is named `rusen-research`. The repo also acts as a single-plugin marketplace, so installation is a two-line `claude plugin marketplace add` + `claude plugin install`.

## Skills

### Research workflow (AI / ML reading)

| Skill | Description |
|---|---|
| [`lit-research`](skills/lit-research/) | Orienting survey of a new research area — discover the landscape, cluster by method / finding / theory / problem framing, produce an executive overview. First-touch skill when entering a new topic. |
| [`paper-triage`](skills/paper-triage/) | Fast SKIM/READ/DEEP/SKIP verdict for a paper from arxiv, Zotero, DOI, or a PDF path. |
| [`paper-notes`](skills/paper-notes/) | Turn a paper (or a Zotero collection/tag) into Article Notes in the rusen-brain vault. For ML/AI papers, also produces an **ML Context** enrichment block (benchmarks vs SOTA, code, compute, follow-ups, criticisms). Pass `mode=enrich-only` to produce just the enrichment block without writing a note. |
| [`lit-review`](skills/lit-review/) | Synthesize a literature review from a set of papers into a vault note: thematic clusters, comparison, synthesis, gaps. |
| [`citation-trace`](skills/citation-trace/) | Explore the citation graph around a seed paper — forward, backward, or both — with Zotero and vault cross-reference. |
| [`idea-deep-dive`](skills/idea-deep-dive/) | Explore the literature around a research question or hypothesis; cluster findings as supporting / contradicting / adjacent / tangential. |

### Vault & tooling primitives

| Skill | Description |
|---|---|
| [`obsidian-cli`](skills/obsidian-cli/) | Interact with an open Obsidian vault via the `obsidian` CLI — read, create, search, manage notes, or develop plugins. |
| [`vaultdb`](skills/vaultdb/) | Query, mutate, and traverse Obsidian vaults using `vaultdb` — a Rust CLI that treats markdown folders as a database with a citation graph. |

### General

| Skill | Description |
|---|---|
| [`context-init`](skills/context-init/) | Explore an unfamiliar codebase in read-only mode and produce a concise onboarding report. |

## Shared design principles

Skills in the **research workflow** group follow strict conventions:

1. **Always ask, never default.** If the user hasn't specified a parameter, the skill asks before proceeding — it doesn't silently pick a default. This is an explicit top-of-skill invariant.
2. **Canonical identifier is the Zotero citation key.** Accept arxiv IDs, DOIs, and PDF paths; normalize internally.
3. **Vault writes go through `/vaultdb` and `/obsidian-cli`.** The research skills orchestrate; they don't reinvent vault machinery.
4. **Body style matches the vault:** encyclopedic prose with dense `[[wiki-links]]`, not bullet dumps. Vault frontmatter respects the 3-tag schema (`type/X` + `topic/Y` + `source/Z`).
5. **Cross-skill hand-offs are explicit.** `paper-triage` → `paper-notes`; `idea-deep-dive` → `citation-trace` → `lit-review`. Skills name each other in their output "recommended next moves."

## Layout

```
rusen-agent-skills/
├── .claude-plugin/
│   ├── plugin.json          # plugin manifest
│   └── marketplace.json     # one-plugin marketplace pointing at "./"
├── skills/
│   ├── citation-trace/SKILL.md
│   ├── context-init/SKILL.md
│   ├── idea-deep-dive/SKILL.md
│   ├── lit-research/SKILL.md
│   ├── lit-review/SKILL.md
│   ├── obsidian-cli/SKILL.md
│   ├── paper-notes/SKILL.md
│   ├── paper-triage/SKILL.md
│   └── vaultdb/SKILL.md
├── README.md
└── LICENSE
```

## Installing

```bash
# 1. Add this repo as a marketplace (one time)
claude plugin marketplace add https://github.com/rusenbb/rusen-agent-skills

# 2. Install the plugin
claude plugin install rusen-research@rusen-research

# 3. Restart Claude Code
```

Skills will appear under the `rusen-research:` namespace (e.g. `rusen-research:paper-triage`).

To install from a local clone instead:

```bash
git clone https://github.com/rusenbb/rusen-agent-skills ~/code/rusen-agent-skills
claude plugin marketplace add ~/code/rusen-agent-skills
claude plugin install rusen-research@rusen-research
```

Changes to skill files take effect in the current Claude Code session without restart.

## Adding a skill

1. Create a new directory under `skills/` named after the skill (kebab-case).
2. Add a `SKILL.md` with at least `name` and `description` in the frontmatter.
3. Keep the description specific — it's what Claude reads to decide when to invoke the skill.

## Changelog

- **0.1.0** — Repackaged as a Claude Code plugin (was: 11 loose skills installed via symlink). Skills now live under `skills/`. Two retired: `arxiv-presentation` (unused), `ml-paper-context` (folded into `paper-notes` as the ML Context block + `enrich-only` mode).
