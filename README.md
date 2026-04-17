# rusen-agent-skills

Personal collection of [Claude Code skills](https://docs.claude.com/en/docs/claude-code/skills).

## Skills

### Research workflow (AI / ML reading)

| Skill | Description |
|---|---|
| [`paper-triage`](paper-triage/) | Fast SKIM/READ/DEEP/SKIP verdict for a paper from arxiv, Zotero, DOI, or a PDF path. |
| [`paper-notes`](paper-notes/) | Turn a paper (or a Zotero collection/tag) into Article Notes in the rusen-brain vault, matching vault conventions. |
| [`lit-review`](lit-review/) | Synthesize a literature review from a set of papers into a vault note: thematic clusters, comparison, synthesis, gaps. |
| [`citation-trace`](citation-trace/) | Explore the citation graph around a seed paper — forward, backward, or both — with Zotero and vault cross-reference. |
| [`idea-deep-dive`](idea-deep-dive/) | Explore the literature around a research question or hypothesis; cluster findings as supporting / contradicting / adjacent / tangential. |
| [`ml-paper-context`](ml-paper-context/) | AI/ML-specific enrichment for a paper: benchmarks vs SOTA, code availability, compute scale, release status, follow-ups. |

### General

| Skill | Description |
|---|---|
| [`arxiv-presentation`](arxiv-presentation/) | Create YouTube-ready reveal.js slide decks from arxiv papers, with narrative structure and speaker notes written as narration scripts. |
| [`context-init`](context-init/) | Explore an unfamiliar codebase in read-only mode and produce a concise onboarding report. |
| [`obsidian-cli`](obsidian-cli/) | Interact with an open Obsidian vault via the `obsidian` CLI — read, create, search, manage notes, or develop plugins. |
| [`vaultdb`](vaultdb/) | Query, mutate, and traverse Obsidian vaults using `vaultdb` — a Rust CLI that treats markdown folders as a database with a citation graph. |

## Shared design principles

Skills in the **research workflow** group follow strict conventions:

1. **Always ask, never default.** If the user hasn't specified a parameter, the skill asks before proceeding — it doesn't silently pick a default. This is an explicit top-of-skill invariant.
2. **Canonical identifier is the Zotero citation key.** Accept arxiv IDs, DOIs, and PDF paths; normalize internally.
3. **Vault writes go through `/vaultdb` and `/obsidian-cli`.** The research skills orchestrate; they don't reinvent vault machinery.
4. **Body style matches the vault:** encyclopedic prose with dense `[[wiki-links]]`, not bullet dumps. Vault frontmatter respects the 3-tag schema (`type/X` + `topic/Y` + `source/Z`).
5. **Cross-skill hand-offs are explicit.** `paper-triage` → `paper-notes`; `idea-deep-dive` → `citation-trace` → `lit-review`. Skills name each other in their output "recommended next moves."

## Layout

Each top-level directory is a single skill:

```
./
├── <skill-name>/
│   ├── SKILL.md          # Required. YAML frontmatter + instructions.
│   └── ...               # Optional: examples, scripts, references
└── <another-skill>/
    └── SKILL.md
```

## Using these skills

Clone into your personal skills directory so Claude Code picks them up automatically:

```bash
# Option A — clone directly as your skills dir (simplest)
git clone https://github.com/rusenbb/rusen-agent-skills ~/.claude/skills

# Option B — clone elsewhere and symlink individual skills
git clone https://github.com/rusenbb/rusen-agent-skills ~/code/rusen-agent-skills
for s in arxiv-presentation citation-trace context-init idea-deep-dive \
         lit-review ml-paper-context obsidian-cli paper-notes \
         paper-triage vaultdb; do
  ln -s ~/code/rusen-agent-skills/$s ~/.claude/skills/$s
done
```

Changes to skill files take effect in the current Claude Code session without restart.

## Adding a skill

1. Create a new directory named after the skill (kebab-case).
2. Add a `SKILL.md` with at least `name` and `description` in the frontmatter.
3. Keep the description specific — it's what Claude reads to decide when to invoke the skill.
