---
name: paper-notes
description: Write structured research notes into the rusen-brain Obsidian vault from a single paper or batch (Zotero collection/tag). Use when the user wants a paper they've read turned into a persistent vault note, or to sync Zotero items into Obsidian. Output follows vault conventions — prose body with dense [[wiki-links]], 3-tag frontmatter, Article Notes template as the base — into /home/rusen/Documents/rusen-brain/3-Notes/. For ML/AI papers, additionally produces an ML Context block (benchmarks vs SOTA, code, compute, follow-ups, criticisms). Pass mode=enrich-only to produce just the ML Context block without writing a full note.
---

# paper-notes

Produce Article Notes for papers, matching rusen-brain vault conventions.

## Invariant: always ask, never default

Any parameter below the user did not specify MUST be asked before doing work. Bundle related questions in one turn. Never silently choose a default.

## Modes

- **default** — write a full Article Note in `3-Notes/`, with an ML Context section appended for ML/AI papers.
- **enrich-only** — produce just the ML Context block as inline output, without writing a vault note. Useful when the user already has a note and wants the enrichment data, or only wants the ML context. ASK which mode if it's an ML paper and ambiguous.

## Required parameters — ASK if missing

1. **Source** — one of:
   - Single paper: arxiv ID, DOI, PDF path, or Zotero citation key.
   - Batch: `zotero-collection=<name>`, `zotero-tag=<tag>`, or an explicit list of identifiers.
2. **Filename** — derived from paper title (sanitized) OR user-specified. If it collides with an existing note, ASK whether to overwrite, suffix, or rename.
3. **`topic/` tag** — the vault's 3-tag frontmatter requires `type/leaf` + `topic/<X>` + `source/article`. ASK for `<X>` (`topic/ai` is common for ML papers but don't assume).

## To confirm — ASK, do not assume

- **Is this an ML paper?** If yes, include the **ML Context** section (see "ML Context block" below) and ASK which enrichments to pull.
- **Include Zotero annotations?** Check `mcp__zotero__zotero_get_annotations`; if any exist, ASK whether to include them as block quotes.
- **Extra free-form tags** (e.g., `reading-priority/high`, `venue/neurips2024`) — ASK.
- **`related-to:` seeds** — scan the vault via `/vaultdb` for topical neighbors and ASK which to link.
- **Reading status** — `read`, `reading`, `skimmed`, `to-read`? ASK.

## Vault conventions (strict)

- **Location:** `/home/rusen/Documents/rusen-brain/3-Notes/<filename>.md`
- **Base template:** extend `2-Templates/Article Notes.md` (just the 3-tag stub).
- **Body style:** encyclopedic prose with dense `[[wiki-links]]`, NOT bullet dumps. Unresolved wiki-links are intentional.
- **All vault writes** go through `/vaultdb` (for queries, graph checks) and `/obsidian-cli` (for creating the note). Load those skills first.

## Frontmatter

```yaml
---
aliases:
  - <optional alias, e.g. the short name researchers use for the paper>
tags:
  - type/leaf
  - topic/<confirmed>
  - source/article
arxiv_id: <if applicable>
doi: <if applicable>
citation_key: <Zotero key if applicable>
authors:
  - <first author>
  - <second author>
year: <year>
venue: <venue or "arxiv">
reading_status: <confirmed>
related-to:
  - "[[<confirmed neighbor>]]"
---
```

Omit any field that has no value. Do not fabricate.

## Body structure (standard)

```markdown
# <Title>

<Opening paragraph: what the paper is, where it sits in the literature, why it matters. Prose. Wiki-links to prior notes where relevant.>

## Problem

<The question attacked. Prose, not bullets.>

## Approach

<The method. Link to known techniques via [[wiki-links]].>

## Key Results

<Headline findings. Numbers where they exist. A few sentences, not a bullet dump.>

## Assumptions and Limitations

<Honest account of what the paper assumes and what it doesn't address.>

## Connections

<How does this relate to [[other notes in the vault]]? Wiki-link liberally.>

## Open Questions

<Questions raised by reading this, for future exploration.>
```

For ML/AI papers, append a final `## ML Context` section using the spec in "ML Context block" below.

## Batch mode

If the source is a Zotero collection or tag:
1. Enumerate items (`mcp__zotero__zotero_get_collection_items` or `zotero_search_by_tag`).
2. For EACH item, show (title, authors, year) and ASK whether to process — unless the user pre-confirmed "process all".
3. Process confirmed items sequentially, one note per item.

## Guardrails

- Never fabricate author lists, venues, or years. If unresolved, leave the field empty.
- Never overwrite an existing note without explicit confirmation.
- Never create notes outside `3-Notes/`.

## ML Context block

For ML/AI papers (or whenever invoked in `enrich-only` mode), produce an enrichment block with the sub-sections below. ASK the user which to include before pulling data:

- Benchmarks claimed + current SOTA context
- Code availability (GitHub, Papers with Code)
- Compute scale (GPUs × count, training time, estimated cost)
- Model / weights / API release status
- Known follow-ups and ablations (forward citations from Semantic Scholar)
- Reproducibility signals (independent replications, known failures)
- Critical reception (strongly-cited critiques or responses)

Also ASK:
- **Time budget** — fast (skip slow checks like Semantic Scholar follow-ups) or thorough?
- **Cloud pricing assumption** — when estimating compute cost, which cloud's rates (AWS, Lambda Labs, market-rate) — or skip the cost estimate.

### Data sources

- **Paper text / abstract** — for benchmarks explicitly claimed.
- **Papers with Code** — WebFetch `https://paperswithcode.com/paper/<slug>` for current SOTA on named benchmarks.
- **GitHub** — `gh repo view <owner>/<repo>` or WebFetch `https://github.com/<owner>/<repo>` for stars, last commit, README.
- **Semantic Scholar** — forward citations: `https://api.semanticscholar.org/graph/v1/paper/<ID>/citations?fields=title,authors,year,citationCount`.
- **HuggingFace** — WebFetch `https://huggingface.co/<org>/<model>` for weights release.

### Output structure

```markdown
## ML Context

### Benchmarks claimed
- <benchmark>: <paper's reported number> (<metric>) — current SOTA: <number> by <paper>, <year, source>
...

### Code availability
- Official repo: <url> — <stars> stars, last commit <date>
- Community / re-implementations: <list if notable>
- Papers with Code entry: <url or "none">

### Compute scale
- Hardware: <GPU type × count>
- Training time: <hours/days>
- Estimated cost: <$> on <confirmed cloud assumption>  (or: "not computed")

### Release status
- Weights: <released / gated / closed> — <url if public>
- API: <url or "none">
- License: <license>

### Follow-ups (top <N>)
- <Title> — <Authors>, <Year>. <One-line relation to the original.>

### Reproducibility signals
- <Independent replications, known failures, community notes.>

### Critical reception
- <Strongly-cited critiques or responses, if any.>
```

Omit any sub-section the user did not confirm.

### ML Context guardrails

- Never fabricate compute figures. If the paper doesn't state them, write "not reported."
- Never infer SOTA from model intuition — always check Papers with Code or the paper's own comparison tables. If neither exists, write "not verified."
- If GitHub / HuggingFace / Semantic Scholar rate-limits or returns no result, write "not checked" rather than guessing.
- In `default` mode, append the block to the note via `/vaultdb` and `/obsidian-cli` as the final section. In `enrich-only` mode, output the block inline and do not touch the vault.

$ARGUMENTS
