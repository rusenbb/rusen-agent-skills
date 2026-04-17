---
name: citation-trace
description: Explore the citation graph around a seed paper — forward (who cites it), backward (what it cites), or both. Use when the user is building out related work, looking for prior art, or hunting for extensions. Produces grouped, scored suggestions, cross-referenced against the user's Zotero library and rusen-brain vault. The direction parameter has no default — it is always confirmed with the user.
---

# citation-trace

Citation graph exploration for a seed paper.

## Invariant: always ask, never default

Any parameter below the user did not specify MUST be asked before doing work. Bundle related questions.

**`direction` has no default and must always be confirmed.** The user flagged this specifically — even if the seed paper and every other parameter is clear, STOP and ask for direction.

## Required parameters — ASK if missing

1. **Seed paper** — arxiv ID, DOI, Semantic Scholar ID, or Zotero citation key.
2. **Direction** — `forward` (papers citing the seed), `backward` (papers the seed cites), or `both`. **Never assume.**
3. **Depth** — hops from the seed (1 = direct; 2 = also citations-of-citations).
4. **Cap per direction** — a max results limit (e.g., 20 / 50 / 100).

## To confirm — ASK, do not assume

- **Relevance filter** — keywords, topics, year range, or none?
- **Cross-reference against Zotero** — flag results already in the user's library? If yes, use `mcp__zotero__zotero_search_items` / similar to check.
- **Cross-reference against vault** — flag results that match existing notes in `3-Notes/`? If yes, load `/vaultdb`.
- **Grouping of results** — by relevance / by year / by venue / by topical cluster?
- **Save output as a note?** Default is NO (inline report). If yes, hand off to `/paper-notes`.

## Data sources

- **Semantic Scholar** is the primary citation-graph source. Endpoints:
  - Backward: `https://api.semanticscholar.org/graph/v1/paper/<ID>/references`
  - Forward: `https://api.semanticscholar.org/graph/v1/paper/<ID>/citations`
  - Useful fields: `?fields=title,authors,year,venue,abstract,citationCount,externalIds`
- **arxiv** — metadata for arxiv-hosted results (WebFetch `arxiv.org/abs/<id>`).
- **Zotero MCP** — cross-ref against the user's library.

## Workflow

1. **Confirm every parameter** (above). Do not skip.
2. **Fetch seed metadata** and echo it back: "Seed: <title>, <first author et al.>, <year>. Proceed?"
3. **Fetch citations** in confirmed direction(s) up to confirmed depth and cap.
4. **Apply relevance filter** per confirmation.
5. **Cross-reference** with Zotero / vault per confirmation.
6. **Group** per confirmed strategy.
7. **Report.**

## Output format

```
## Seed
<Title> — <Authors>, <Year>, <Venue>

## Parameters (as confirmed)
direction=<...>, depth=<N>, cap=<M>, filter=<...>, grouping=<...>

## Results by <confirmed grouping>

### <Group 1> (<count>)

- **<Title>** — <Authors>, <Year>, <Venue>. Cited <N>. [in library: yes/no] [in vault: yes/no]
  Why relevant: <1-line rationale tied to the seed's content>

...

## Suggestions
- Strongest prior-art seeds: <top 3>
- Strongest extension seeds: <top 3>
- Consider `/paper-triage` on: <top 2-3>
- Consider `/lit-review` if any cluster crosses <threshold>
```

## Guardrails

- Never fabricate citation counts. If an API omits the field, omit it in output.
- If Semantic Scholar rate-limits or the seed isn't found, report honestly — do not invent a graph.
- Do not persist results to the vault without explicit confirmation.

$ARGUMENTS
