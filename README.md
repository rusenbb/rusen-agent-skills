# rusen-agent-skills

Personal collection of [Claude Code skills](https://docs.claude.com/en/docs/claude-code/skills).

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

# Option B — clone elsewhere and symlink
git clone https://github.com/rusenbb/rusen-agent-skills ~/code/rusen-agent-skills
ln -s ~/code/rusen-agent-skills ~/.claude/skills
```

Changes to skill files take effect in the current Claude Code session without restart.

## Adding a skill

1. Create a new directory named after the skill (kebab-case).
2. Add a `SKILL.md` with at least `name` and `description` in the frontmatter.
3. Keep the description specific — it's what Claude reads to decide when to invoke the skill.
