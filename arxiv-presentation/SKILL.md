---
name: arxiv-presentation
description: |
  Create YouTube-ready HTML presentations from arxiv papers. Use when the user asks to create a presentation, make slides, or build a video deck from an academic paper (arxiv tar.gz, arxiv ID, or paper PDF). Generates reveal.js HTML slides with narrative structure (not lecture format), speaker notes written as narration scripts, paper-inspired color themes, and fragment animations for visual drama. Output is a self-contained directory with index.html + figures/. The presentations are designed for ~7-8 minute YouTube narrated walkthroughs of AI/CS/ML papers.
---

# arxiv-presentation

Create YouTube-ready HTML slide decks from arxiv papers. The output is a reveal.js presentation with a **narrative arc** (not a lecture), **speaker notes as narration scripts**, and a **paper-inspired color theme**.

## Prerequisites

- `pdftoppm` (from poppler-utils) for converting PDF figures to PNG
- Internet access for reveal.js CDN and Google Fonts

## Workflow

### Phase 1 — Prepare the paper

Run the preparation script:

```bash
bash ~/.claude/skills/arxiv-presentation/scripts/prepare-paper.sh <input> <output-dir>
```

- `<input>`: path to a `.tar.gz` file, or an arxiv ID (e.g., `2603.15569`)
- `<output-dir>`: where to create the presentation (e.g., `output/paper-name/`)

This extracts source files, converts PDF figures to PNG, and writes a manifest.

### Phase 2 — Read and understand the paper

Read the LaTeX source files in order:

1. **Abstract** — the paper's own summary
2. **Introduction** — motivation, problem statement, contributions
3. **Methods/approach** — the core innovations (read each subsection)
4. **Experiments/results** — what they tested, key numbers
5. **Conclusion** — their own takeaways

While reading, note:
- What is the **single most surprising or provocative finding**? (this becomes the hook)
- How many **core innovations** are there? (determines narrative structure)
- Which **figures** are essential to the story? (usually 3–5)
- What are the **key numbers** that prove it works?
- What are the **honest limitations**?

### Phase 3 — Understand figures via captions

Read figure **captions** from the LaTeX `\caption{}` text. This tells you what each figure shows without consuming visual context tokens. For the 1–2 most important figures (architecture diagram, main result plot), visually inspect them to understand layout.

### Phase 4 — Plan the narrative

**MANDATORY: Read the narrative guide before writing any HTML:**

```
Read file: ~/.claude/skills/arxiv-presentation/references/narrative-guide.md
```

Determine:
1. **Hook**: the most surprising stat, finding, or claim (goes on slide 1, before title)
2. **Stakes**: why this matters right now (1–2 slides after title)
3. **Journey structure**: single-insight-cascading or multi-innovation-parallel?
4. **Payoff**: which results answer the audience's implied questions?
5. **Honest limitation**: what doesn't work?

Plan 13–17 slides targeting 7–8 minutes (~25–30 sec per slide).

### Phase 5 — Choose a color theme

Pick colors **inspired by the paper**. Check the paper's own figures, institution branding, or domain conventions:
- **Architecture/systems papers**: cool blues, teals
- **Applied/agents papers**: warm oranges, ambers
- **CV/vision papers**: rich purples, magentas
- **NLP/language papers**: greens, cyans
- **Theory papers**: clean blues, minimal palette

Only the `:root` CSS variables change. Everything else stays the same.

### Phase 6 — Generate the presentation

**MANDATORY: Read the base CSS before writing:**

```
Read file: ~/.claude/skills/arxiv-presentation/assets/base-theme.css
```

Generate a single `index.html` file with:

1. **Inline CSS**: copy the base theme CSS, modify `:root` variables, add paper-specific components if needed
2. **reveal.js from CDN**: version 5.1.0, with Notes and Highlight plugins
3. **Slides as `<section>` elements** with speaker notes in `<aside class="notes">`
4. **Figures referenced as relative paths**: `figures/filename.png`

**reveal.js configuration** (always use this exact config):
```javascript
Reveal.initialize({
  width: 1280, height: 720, margin: 0,
  hash: true, slideNumber: 'c/t',
  showNotes: false, transition: 'fade',
  transitionSpeed: 'default', backgroundTransition: 'fade',
  center: false,
  plugins: [RevealNotes, RevealHighlight],
});
```

### Phase 7 — Validate

Open the presentation in the browser. Verify:
- All figures load
- Fragment animations work (press right arrow)
- Speaker notes appear (press S)
- Slide count is in the 13–17 range

## Slide Anatomy

Every slide follows this pattern:

```html
<section>
  <div class="stripe"></div>               <!-- accent gradient bar -->
  <div class="chapter">Chapter label</div> <!-- narrative position -->
  <h2>Claim or question title</h2>         <!-- NOT a topic label -->
  <p class="sub">Optional subtitle</p>     <!-- muted context -->
  
  <!-- ONE dominant visual element: -->
  <!-- .hero-num / .fig / .vs-row / .callout / .result-row / .clean-table -->
  
  <!-- Supporting content with fragments -->
  <div class="fragment fade-up">...</div>
  
  <aside class="notes">
    Narration script here. Conversational. 20-35 seconds when read aloud.
  </aside>
</section>
```

**Cold open** and **end card** use `class="centered"` with `data-background-gradient`.

## Key Design Rules

1. **Cold open before title card** — provocative claim or stat, fullscreen centered
2. **Titles are claims or questions**, not topics ("The task Mamba can't solve" not "State Tracking")
3. **One dominant visual per slide** — everything else supports it
4. **Fragments create reveal moments** — 2–4 per slide max, each meaningful
5. **Figures are evidence**, not decoration — they appear when you say "and here's the proof"
6. **Speaker notes read as narration** — conversational, confident, honest
7. **13–17 slides**, 7–8 minutes, never exceed 9 or go below 5
8. **Paper figures used selectively** — 3–5 max, visually inspect key ones
9. **Be honest about limitations** — one "the catch" slide builds credibility
10. **End with "the bigger picture"** — what this means for the field, not just "conclusion"

## Component Quick Reference

| Component | Use for | Example |
|---|---|---|
| `.hero-num.massive` | Dramatic single number | `<1%`, `0.0%`, `6.5×` |
| `.hero-num.large` + `.glow` | Emphasized statement | `it forgets` |
| `.callout` (+ `.green`/`.red`/`.cyan`) | Key insight box | Main claims, summaries |
| `.result-row` > `.result-card` | Metric cards | `+2.2 pts`, `4×` |
| `.vs-row` > `.vs-box` | Before/after comparison | `0.0%` vs `100.0%` |
| `.clean-table` (+ `.winner`) | Data comparison | Speed benchmarks |
| `.meter-wrap` > `.meter-fill` | Utilization bars | GPU usage visualization |
| `.flow-steps` > `.flow-step` | Process steps | Algorithm walkthrough |
| `.eq` | Equation/formula | Math in monospace |
| `.fig` > `img` | Paper figure | With `.cap` caption |

## Fragment Animations

| Class | Effect | Use for |
|---|---|---|
| `fragment fade-up` | Slides up + fades in | General content reveal |
| `fragment fade-in` | Fades in | Subtle additions |
| `fragment scale-in` | Scales from small | Dramatic number reveals |
| `fragment blur-in` | Blurs in from nothing | Impact statements |
| `fragment sweep-right` | Slides in from left | Sequential points |

## Example Presentations

Two complete examples exist for reference:
- `output/mamba3-presentation/` — architecture paper, cool blue theme, 16 slides
- `output/openclaw-presentation/` — agents/RL paper, warm orange theme, 13 slides

These demonstrate different narrative structures (multi-innovation vs single-insight), different color palettes, and different paper-specific components.
