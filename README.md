# RepoSkillForge

**Repository → AI Skill → Reusable Capability**

RepoSkillForge is an open collection of repository-derived AI skills. Each skill studies a real open-source project, extracts its practical APIs, workflows, conventions, CLI usage, troubleshooting knowledge, and version-specific behavior, then packages that knowledge in a portable Agent Skill format.

## What is a RepoSkill?

A RepoSkill is **not a copy of the source repository**. It is an AI-facing operating guide derived from a repository.

```text
Open-source repository
        ↓
Documentation + source/API study
        ↓
Examples + compatibility checks
        ↓
Skill instructions
        ↓
Evaluation
        ↓
Published RepoSkill
```

## Repository structure

```text
RepoSkillForge/
├── README.md
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE
├── registry/
│   └── skills.json
├── skills/
│   ├── README.md
│   └── <skill-name>/
│       ├── SKILL.md
│       ├── references/
│       ├── examples/
│       └── evals/
└── .github/
    └── workflows/
        └── validate-skills.yml
```

## First skill: ManimGL

The first RepoSkill is for **3Blue1Brown's ManimGL**:

https://github.com/3b1b/manim

Path:

```text
skills/manimgl/
```

It covers scenes, Mobjects, animations, LaTeX, graphs, updaters, 3D scenes, camera control, CLI rendering, debugging, and ManimGL-versus-Manim Community Edition compatibility.

**ManimGL and Manim Community Edition are different projects.** A RepoSkill must never silently substitute one for the other.

## Quality standard

Before publishing a skill, aim to establish:

1. Exact upstream repository identity.
2. Clear scope.
3. Version/release or source state studied.
4. Official documentation review.
5. Source/API verification where appropriate.
6. Representative examples tested when practical.
7. Common failures documented.
8. Evaluation prompts created.
9. Attribution and license information included.
10. No unnecessary copying of upstream source code.
11. No claim of testing that did not happen.
12. No invented APIs, flags, dependencies, or guarantees.

## Using a skill

### Claude Code

Copy:

```text
skills/<skill-name>/
```

to:

```text
~/.claude/skills/<skill-name>/
```

or install the skill through a Claude Code plugin.

### Other compatible AI agents

Provide the complete skill directory to an agent supporting the Agent Skills convention. Preserve relative paths to references and examples.

## Creating a new RepoSkill

1. Identify the exact upstream repository.
2. Inspect README and official documentation.
3. Inspect source for important APIs.
4. Identify version differences.
5. Create a concise triggerable `SKILL.md`.
6. Move detailed material into `references/`.
7. Add runnable examples when useful.
8. Add evaluation prompts.
9. Validate structure and links.
10. Record upstream source and license.
11. Test representative examples.
12. Publish only after review.

See [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

**RepoSkillForge — turning repository knowledge into reusable AI capabilities.**
