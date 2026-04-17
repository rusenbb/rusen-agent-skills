---
name: paper-triage
description: Rapidly triage a research paper and produce a SKIM/READ/DEEP/SKIP verdict. Use when the user wants a quick read-or-skip decision on an arxiv, Zotero, DOI, or PDF paper, or is prioritizing from a reading queue. Produces a distilled central claim, method category, required background, and a decision with rationale. Does not write to the vault unless the user asks.
---

# paper-triage

Fast triage that gives the user a verdict they can trust in under a minute.

## Invariant: always ask, never default

**Any parameter below that the user did not specify MUST be asked before doing work.** Bundle related questions in one turn (use `AskUserQuestion` if available). Never silently choose a default.

## Required parameters — ASK if missing

1. **Paper** — arxiv ID / URL, DOI, PDF path, or Zotero citation key. Accept any; normalize internally.
2. **Depth** — `quick` (3–4 lines), `standard` (full template), or `deep` (+ vault / Zotero cross-ref).

## To confirm — ASK, do not assume

- Cross-reference the user's vault at `/home/rusen/Documents/rusen-brain/3-Notes/`? If yes, load `/vaultdb` first.
- Cross-reference the user's Zotero library? If yes, use `mcp__zotero__zotero_get_item_metadata` and friends.
- Save output as a note? If yes, hand off to `/paper-notes` — this skill does **not** write.

## Data sources

- **arxiv** — WebFetch `https://arxiv.org/abs/<id>` for abstract + metadata, or `Read` the local PDF.
- **Zotero** — `mcp__zotero__zotero_get_item_metadata`, `mcp__zotero__zotero_get_item_fulltext`, `mcp__zotero__zotero_get_annotations`.
- **Semantic Scholar** (optional) — citation count and quick context via WebFetch on `api.semanticscholar.org`.

## Output — standard depth

```
## Paper
<Title> — <first author et al.>, <year>, <venue or "arxiv">

## Central claim
<One sentence: what the paper argues, not just what it does.>

## Method category
<e.g., "mechanistic interp, activation patching" or "RL fine-tuning, DPO variant">

## Required background
<3–5 concepts in `[[wiki-link]]` notation for integration with the vault.>

## Why this might matter
<1–2 sentences grounded in the user's vault / Zotero context, IF cross-ref was confirmed.>

## Verdict
**[SKIM | READ | DEEP | SKIP]** — <one-line rationale tied to the paper's content, not vague signals>
```

## Guardrails

- Never fabricate citation counts, author affiliations, or venues — omit the field if unresolved.
- If verdict is `DEEP`, recommend `/paper-notes` as the follow-up.
- Do not rate a paper `DEEP` from the abstract alone; base the decision on at least intro + first methods section.

$ARGUMENTS
