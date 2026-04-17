# Narrative Guide for YouTube Paper Presentations

This is NOT a lecture. It's a YouTube video. The audience can click away at any moment. Every slide must earn their attention.

## The Golden Rule

**Tell a story, not a syllabus.** The paper has sections (Introduction, Methods, Results). Your presentation has an **arc** (hook → tension → journey → payoff → implications).

## Structure: The Five Acts

### Act 1 — The Hook (1 slide, ~15 sec)
Open with the single most surprising, provocative, or relatable thing about this paper. Before the title card.

**Hook types (choose one):**
- **The shocking stat**: "99% of GPU compute is wasted during SSM inference"
- **The impossible task**: "There's a task so simple an LSTM solves it, but this model scores zero"
- **The relatable frustration**: "Every time you correct an AI agent, it forgets"
- **The provocative claim**: "Transformers are dying. They just don't know it yet."
- **The paradox**: "Making the model do 4× more work doesn't slow it down at all"

**How to find the hook**: Read the abstract and results. What surprised YOU? That's the hook.

### Act 2 — Title Card + Stakes (2–3 slides, ~60 sec)
Title card is brief. Then immediately establish WHY this matters. Not "this is important because" — frame it as a problem the viewer should care about.

**Stakes framing:**
- What's broken in the current state of things?
- Why is it getting worse, not better?
- What has been tried and failed?

### Act 3 — The Journey (5–8 slides, ~3–4 min)
This is the bulk. Each innovation or finding is a mini-arc:

```
Setup (what's the specific problem?)
→ Failed/naive attempt (what doesn't work?)
→ Insight (the "aha" moment)
→ Solution (how they fix it)
→ Mini-payoff (one result that proves it works)
```

**For multi-innovation papers** (like Mamba-3): run this cycle for each innovation, with transitions connecting them.

**For single-insight papers** (like OpenClaw-RL): spend more time on the setup and insight, then cascade through implications.

### Act 4 — The Payoff (2–3 slides, ~90 sec)
Results aren't a list of numbers — they're **proof the narrative delivered**.

Frame each result as an answer to a question the audience is already asking:
- "So does it actually work?" → headline number
- "How much faster/better?" → comparison
- "What's the concrete difference?" → before/after examples

### Act 5 — The Bigger Picture + Close (1–2 slides, ~45 sec)
Not "conclusion." What does this MEAN for the field? What design principle does it validate? Where is this going?

Close with paper/code links. Keep it brief.

## Slide Design Principles

### One Idea Per Slide
If you need two paragraphs to explain the slide, split it into two slides. The viewer should understand the slide in 3 seconds of looking at it.

### Titles Are Claims, Not Topics
- BAD: "Complex-Valued State Spaces"
- GOOD: "Real numbers scale. Complex numbers rotate."
- BAD: "Results"
- GOOD: "Does it actually work?"

### Chapter Labels, Not Section Labels
Use `.chapter` for narrative position ("The problem", "Fix 2 · Complex States", "Does it work?", "The honest answer"). Not academic sections ("Introduction", "Methods", "Results").

### Visual Hierarchy
Each slide has ONE dominant visual element:
- A big number (`.hero-num`)
- A figure from the paper (`.fig`)
- A comparison (`.vs-row`)
- A key insight (`.callout`)

Everything else supports that dominant element.

### Fragment Reveals for Drama
Use fragments to create reveal moments:
- Show the problem → fragment reveals the solution
- Show 0% → fragment reveals 100%
- Show the naive approach → fragment reveals what's actually needed

Don't fragment everything. 2–4 fragments per slide max. Each should create a meaningful beat.

## Speaker Notes Guidelines

Speaker notes ARE the narration script. Write them as if the presenter will read them nearly verbatim.

### Tone
- **Explainer persona**: "Here's the thing...", "Let me show you why...", "What's interesting is..."
- **Confident but not arrogant**: state things clearly, show genuine appreciation for clever ideas
- **Honest about limitations**: "Now let me be honest about what this can't do..."
- **Anticipate questions**: "Now you might be thinking..."

### Pacing
- Short sentences for impact
- Vary rhythm: technical explanation → quick one-liner → pause
- Each slide's notes should take 20–35 seconds to read aloud
- Use "..." or sentence breaks to suggest natural pauses

### What NOT to do
- Don't read the slide text back to the viewer
- Don't use academic tone ("We observe that...")
- Don't use hype ("THIS IS INSANE")
- Don't apologize ("This is a bit complex but...")
- Don't narrate your own actions ("Now I'm going to show you...")

## Target Metrics

- **Slides**: 13–17 per paper
- **Duration**: 7–8 minutes (must not exceed 9, must not go below 5)
- **Figures from paper**: 3–5 (used as evidence, not decoration)
- **Fragments**: 20–30 total across the deck
- **Text per slide**: aim for what you could read in 5 seconds max
