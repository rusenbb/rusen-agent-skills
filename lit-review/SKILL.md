---
name: lit-review
description: Synthesize a literature review from a set of papers into a note in the rusen-brain vault, matching the existing style (problem framing → thematic clusters with paper counts → synthesis → gaps). Use when the user wants a Zotero collection, tag, or explicit paper list turned into a coherent review. Writes to /home/rusen/Documents/rusen-brain/3-Notes/.
---

# lit-review

Multi-paper synthesis that matches the pattern in `LLM Safety Literature Review (Applied NLP).md`.

## Invariant: always ask, never default

Any parameter below the user did not specify MUST be asked before doing work. Bundle related questions. Never silently choose a default.

## Required parameters — ASK if missing

1. **Paper set source** — Zotero collection name, Zotero tag, or an explicit list of identifiers.
2. **Focus question / framing** — the question the review answers. "Broad survey" is acceptable only if the user explicitly picks it.
3. **Note filename** — in `3-Notes/`.
4. **`topic/` tag** — ASK which topic (vault requires `type/leaf` + `topic/X` + `source/article`).

## To confirm — ASK, do not assume

- **Clustering strategy** — by method / by problem framing / by year / by venue. Show candidate clusters first and ASK.
- **Comparison table** — include one? If yes, ASK which dimensions (method, dataset, results, assumptions, ...).
- **Depth per paper** — one-line / one-paragraph / full mini-section. ASK.
- **Gap analysis section** — include? ASK.
- **Vault cross-reference** — wiki-link to existing vault notes on methods and concepts? Load `/vaultdb` and confirm.

## Workflow

1. **Confirm all parameters** above.
2. **Gather papers.** Via Zotero MCP (`mcp__zotero__zotero_get_collection_items`, `zotero_search_by_tag`) or the explicit list. For each: title, authors, year, venue, abstract, citation count when available, annotations if present.
3. **Propose clusters** based on the set — show them to the user and let them adjust before you commit.
4. **Draft per confirmed cluster.** Each section opens with a framing sentence, then prose synthesis. Paper count in the heading (e.g., `### 1. Guardrail Frameworks (17 papers)`).
5. **Draft synthesis paragraph.** Cross-cluster convergences, tensions, open problems.
6. **Write to vault** via `/vaultdb` or `/obsidian-cli`. Location: `3-Notes/<confirmed filename>.md`.

## Output structure

```markdown
---
aliases:
tags:
  - type/leaf
  - topic/<confirmed>
  - source/article
related-to:
---

# <Title>

<Opening paragraph: what the review covers, why, the framing question.>

---

## Problem Framing

<Why is this review needed? What question motivates it?>

---

## Scope

<Inclusion criteria, time window, paper count, exclusions.>

---

### 1. <Cluster name> (<N> papers)

<Prose synthesis. Named papers with (First Author et al., Year, Venue) inline.>

### 2. <Cluster name> (<N> papers)

...

---

## Comparison

<If confirmed: comparison table with agreed dimensions.>

---

## Synthesis

<Cross-cluster narrative: convergences, tensions, trends.>

---

## Gaps and Open Problems

<If confirmed: what the literature has not addressed.>

---

## Recommended Further Reading

<Candidate next papers surfaced during synthesis.>
```

## Style (match the vault)

- **Prose paragraphs**, not bullet dumps.
- Inline citation style: `(Author et al., Year, Venue)`.
- Wiki-link liberally to existing concept notes (check via `/vaultdb` semantic search).
- Paper counts belong in cluster headings, not in bullets.

## Guardrails

- Never fabricate citation counts, venues, or paper claims. Missing fields stay missing.
- Never overwrite an existing review note without explicit confirmation.

$ARGUMENTS
