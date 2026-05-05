---
name: idea-deep-dive
description: Explore the literature around a research question or half-formed hypothesis. Use when the user is in brainstorm mode — has an idea but no specific paper — and wants to see what the field says. Searches Zotero, arxiv, and Semantic Scholar; clusters findings as supporting, contradicting, adjacent methods, and tangential; identifies gaps. Does not write to the vault unless the user asks.
---

# idea-deep-dive

Literature exploration for fuzzy research questions.

## Invariant: always ask, never default

Any parameter below the user did not specify MUST be asked before doing work. Bundle related questions.

## Required parameters — ASK if missing

1. **Research question or hypothesis** — a clear statement. If the user's framing is vague, ASK for a sharper version before searching.
2. **Sources to search** — Zotero library, arxiv, Semantic Scholar, general web? Multi-select.
3. **Time window** — all time, last N years, or explicit range.
4. **Cap per source** — max results (e.g., 10 / 20 / 50).

## To confirm — ASK, do not assume

- **Devil's advocate mode** — actively hunt for contradicting evidence, or supportive-only, or balanced?
- **Include user's vault** — scan `3-Notes/` for existing notes touching the question? If yes, load `/vaultdb`.
- **Include non-paper sources** — blog posts, tech reports?
- **Save as a brainstorm note** — if yes, ASK the filename AND the folder (`1-TempNotes/` for scratch, `3-Notes/` for permanent). Never default the folder.
- **Follow-up hand-offs** — for top 1-3 promising seeds, run `/citation-trace` or `/paper-triage`?

## Workflow

1. **Confirm every parameter.**
2. **Sharpen the question** — show the user your interpretation in 1-2 sentences and ASK for confirmation before searching.
3. **Search each confirmed source** up to the confirmed cap.
   - Zotero: `mcp__zotero__zotero_semantic_search`, `zotero_advanced_search`.
   - arxiv: search via WebFetch on `http://export.arxiv.org/api/query?search_query=...`.
   - Semantic Scholar: `https://api.semanticscholar.org/graph/v1/paper/search?query=...&fields=title,authors,year,venue,abstract,citationCount`.
4. **Cluster findings** into: Supporting / Contradicting / Adjacent methods / Tangential but interesting.
5. **Note gaps** — angles no paper seems to cover.
6. **Report** (and optionally save if confirmed).

## Output format

```
## Question (as confirmed)
<Sharpened statement>

## Sources searched
<list, with confirmed caps>

## Supporting (<N>)
- <Title> — <Authors>, <Year>, <Venue>. <One-line relevance.>
...

## Contradicting (<N>)
- <Title> — ...

## Adjacent methods (<N>)
- <Title> — ...

## Tangential but interesting (<N>)
- <Title> — ...

## Gaps
<Angles or claims no paper seems to cover — written as prose, not bullets.>

## Recommended next moves
- `/paper-triage` on: <top 2-3>
- `/citation-trace` forward on: <top 1>
- `/lit-review` if the Supporting cluster crosses <threshold>
```

## Guardrails

- Sharpen vague questions by asking, not by guessing. A fuzzy query yields a fuzzy result.
- Never fabricate titles, authors, or venues. An empty source → an empty cluster. Report honestly.
- Do not write to the vault without explicit confirmation and a confirmed folder.

$ARGUMENTS
