---
name: lit-research
description: Orienting survey of a research topic — discover the current landscape and understand how people are working on it. Use when the user enters a new research area and wants a field scan rather than a deep read of any single paper. Optionally anchored by one or more exemplars (e.g., "like Tencent's HY-World 2.0") which disambiguate the topic without scoping the search. Produces a clustered report organized by method, finding, theoretical result, problem framing, or a mix — with an executive overview.
---

# lit-research

First-touch survey for a new research area. Not a lit review (which assumes a curated paper set) and not a citation trace (which walks the graph from a seed) — this skill **discovers** the landscape, **understands** how leading work approaches it, and **orients** the user.

## Invariant: always ask, never default

Any parameter below the user did not specify MUST be asked before doing work. Bundle related questions in one turn. Never silently choose a default.

## Required parameters — ASK if missing

1. **Topic** — sharpened. If the user's framing is broad or ambiguous (e.g., "generative world generation"), show 2–3 candidate scopings and ASK which fits before searching.
2. **Exemplar(s)** — optional; ASK whether the user has any in mind. **Exemplars are anchors only** — they disambiguate what the topic means. They do NOT scope the search to the exemplar's citation neighborhood (that's `/citation-trace`). Results may freely include work with zero citation relationship to the exemplar.
3. **Time window** — all time, last N months/years, or an explicit range.
4. **Source types** — ASK one-time which of these to include: peer-reviewed papers, arxiv preprints, tech reports / white papers, blog posts, GitHub READMEs, HuggingFace model cards. Fast-moving subfields often have their frontier in tech-reports-and-below; mature areas may be peer-reviewed-sufficient.
5. **Clustering strategy** — ASK which organizing lens fits the intent:
   - `by-method` — techniques, algorithms, architectures
   - `by-finding` — empirical claims about the world
   - `by-theoretical-result` — mathematical or formal results
   - `by-problem-framing` — how the problem itself is defined
   - `mixed` — combine as the data suggests
   - `propose-from-data-then-confirm` — skill proposes clusters from actual results; user confirms or adjusts before drafting
6. **Cluster count target** — 3–5 (crisp) or 6–10 (thorough).

## To confirm — ASK, do not assume

- **Zotero cross-reference** — flag results already in the user's library (`mcp__zotero__zotero_search_items`)?
- **Vault cross-reference** — flag results matching existing notes in `3-Notes/` (via `/vaultdb`)?
- **Depth per cluster** — one paragraph / one section / mini-review?
- **Reproducibility commentary** — for method-oriented clusters, include code / weights / compute scale? Skip automatically for theoretical-result clusters.
- **Save as a vault note** — if yes, ASK the folder (`1-TempNotes/` for scratch, `3-Notes/` for permanent) and the filename. Never default the folder.
- **Follow-up hand-offs** — suggest (or auto-invoke) `/paper-triage` on top-N candidates? `/citation-trace` forward from an exemplar? `/lit-review` on the curated set?

## Workflow

1. **Sharpen the topic.** Show your interpretation in 1–2 sentences, propose 2–3 candidate scopings if ambiguous, and ASK before searching.
2. **Confirm every parameter** above in one structured turn.
3. **Discover candidates** via parallel strategies (skip any whose source type the user excluded):
   - **WebSearch** on topic terminology + "SOTA", "state-of-the-art", "survey", "benchmark"
   - **arxiv** via `http://export.arxiv.org/api/query?search_query=...` with time-window filter
   - **Semantic Scholar** via `https://api.semanticscholar.org/graph/v1/paper/search?query=...&fields=title,authors,year,venue,abstract,citationCount` with year filter
   - **Papers with Code** (WebFetch) if the topic has standard benchmarks
   - **GitHub** search for trending repos if source types include code
   - **HuggingFace** trending models if source types include model cards
   - **DO NOT** run citation expansion from the exemplar — the exemplar is an anchor, not a seed.
4. **Dedupe and label** each candidate by source type (paper / preprint / tech report / blog / code / model card).
5. **Cluster** per the confirmed strategy. If `propose-from-data-then-confirm`, show candidate clusters and ASK for confirmation or adjustment before drafting.
6. **Draft per cluster** at the confirmed depth. Match framing to the clustering strategy:
   - `by-method`: technique, flag-bearers, tradeoffs, representative results
   - `by-finding`: the claim, supporting evidence, pushback, scope of the claim
   - `by-theoretical-result`: the result, assumptions, proof sketch, consequences
   - `by-problem-framing`: the definition, adherents, implications for downstream work
7. **Executive overview** at the top: "the field has split into N lenses / clusters; your anchor sits in cluster X."
8. **Report** (and optionally save, with coverage caveats explicit).

## Output skeleton

```markdown
# lit-research: <topic>  (as of <YYYY-MM-DD>)

## Executive overview
<1–2 paragraphs: the shape of the field organized by the confirmed clustering strategy. Anchor-to-cluster mapping if exemplars were given.>

---

## <Clustering strategy> (as confirmed)

### <Cluster 1> (<M> sources)
<Prose framed by the cluster type. Representative items below.>

- **<Title>** — <Authors/Org>, <Year>, <venue / "tech report" / "blog">. [source type: <label>] [code: yes/no] [in Zotero: yes/no] [in vault: yes/no]
  <1–2 line characterization tied to the cluster's lens.>
- ...

### <Cluster 2> ...

---

## Cross-cluster comparison
<Prose — convergences, trade-offs, tensions. Skip if not useful for the chosen clustering strategy.>

## Open problems at the frontier
<Prose, grounded in what the sources actually say.>

## Coverage caveats
- Time window: <confirmed>
- Source types searched: <list>
- Clustering strategy: <confirmed>
- Likely gaps: <what the search probably missed — foreign-language venues, unpublished work, closed-source industry work>

## Recommended next moves
- `/paper-triage` on: <top 2–3 in the cluster you care most about>
- `/citation-trace` forward on: <foundational exemplar if you want the graph>
- `/paper-notes` on: <cluster leader you want to read deeply>
- `/lit-review` once you've read <N> — if a formal written review is the goal
```

## Style

- If saving to the vault: match the vault style — **prose paragraphs**, not bullet dumps; inline citations as `(Author et al., Year, Venue)` or `(Org, Year, "tech report")`; wiki-link liberally to existing concept notes (check via `/vaultdb` if cross-ref was confirmed).
- Always include an **"as of <date>"** timestamp in the title — SOTA drifts quickly.

## Guardrails

- Never fabricate findings, results, or citations. If a source is inaccessible, skip it rather than guess its contents.
- Label tech reports and blog posts explicitly — never pass them as peer-reviewed.
- If a cluster turns up fewer than 5 candidates, say so — a thin cluster is data, not a prompt to pad with filler.
- Do not write to the vault without explicit confirmation of folder + filename.

$ARGUMENTS
