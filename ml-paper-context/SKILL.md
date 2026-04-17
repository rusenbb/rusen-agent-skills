---
name: ml-paper-context
description: Produce an AI/ML-specific enrichment block for a paper — benchmarks vs SOTA, code availability, compute scale, model release status, known follow-ups and criticisms. Use as a complement to /paper-notes when the paper is an ML result, or standalone when the user wants only this context. Does not write a full note on its own.
---

# ml-paper-context

Enrichment for ML/AI papers: the context a generic paper-notes skill would miss.

## Invariant: always ask, never default

Any parameter below the user did not specify MUST be asked before doing work. Bundle related questions.

## Required parameters — ASK if missing

1. **Paper identifier** — arxiv ID, DOI, PDF path, Zotero citation key, or Semantic Scholar ID.
2. **Enrichments to include** — checklist; ASK the user to confirm which apply. Options:
   - Benchmarks claimed + current SOTA context
   - Code availability (GitHub, Papers with Code)
   - Compute scale (GPUs × count, training time, estimated cost)
   - Model / weights / API release status
   - Known follow-ups and ablations (forward citations from Semantic Scholar)
   - Reproducibility signals (independent replications, known failures)
   - Critical reception (strongly-cited critiques or responses)

## To confirm — ASK, do not assume

- **Output mode** — inline report, or append as a `## ML Context` section to an existing paper-notes note?
- **Target note path** — if appending, ASK for the full path in `3-Notes/`.
- **Time budget** — fast (skip slow checks like Semantic Scholar follow-ups) or thorough?
- **Cloud pricing assumption** — when estimating compute cost, ASK which cloud's rates to use (AWS, Lambda Labs, market-rate) or skip the cost estimate.

## Data sources

- **Paper text / abstract** — for benchmarks explicitly claimed.
- **Papers with Code** — WebFetch `https://paperswithcode.com/paper/<slug>` for current SOTA context on named benchmarks.
- **GitHub** — `gh repo view <owner>/<repo>` or WebFetch on `https://github.com/<owner>/<repo>` for stars, last commit, README.
- **Semantic Scholar** — forward citations for follow-ups: `https://api.semanticscholar.org/graph/v1/paper/<ID>/citations?fields=title,authors,year,citationCount`.
- **HuggingFace** — WebFetch `https://huggingface.co/<org>/<model>` for weights release.

## Output block

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

Omit any sub-section that wasn't in the confirmed enrichment list.

## Guardrails

- Never fabricate compute figures. If the paper doesn't state them, write "not reported."
- Never infer SOTA from model intuition — always check Papers with Code or the paper's own comparison tables. If neither exists, write "not verified."
- If GitHub / HuggingFace / Semantic Scholar rate-limits or returns no result, write "not checked" rather than guessing.
- If the user asks to append to a note, load `/vaultdb` and `/obsidian-cli` first; append via those tools, not by directly rewriting the file blindly.

$ARGUMENTS
