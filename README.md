# RepoSkillForge

**Repository → AI Skill → Reusable Capability**

RepoSkillForge is an open collection of repository-derived AI skills. Each skill turns knowledge about an open-source project into reusable instructions for compatible AI coding agents. Skills may include API guidance, workflows, CLI usage, compatibility notes, examples, troubleshooting, and evaluation prompts.

> **Project status:** The initial published skill is ManimGL. This repository is early-stage; review each skill's documentation and evaluation notes before relying on it in a production workflow.

## Install a skill

### Windows — PowerShell

Clone the repository, then run the installer from its folder:

```powershell
git clone https://github.com/SKABDULAHMED8/RepoSkillForge.git
Set-Location RepoSkillForge
.\install.ps1 list
.\install.ps1 manimgl
```

The installer copies the skill to `$HOME\.claude\skills\manimgl`. If a skill already exists at that destination, the installer creates a timestamped backup before replacing it.

To install all available skills:

```powershell
.\install.ps1 all
```

To update an existing clone before installing the latest version:

```powershell
git pull
.\install.ps1 manimgl
```

### Manual installation

Copy the complete `skills/<skill-name>/` directory into the skills directory used by your compatible AI agent. Preserve its relative paths, including `references/`, `examples/`, and `evals/`.

## Available skills

| Skill | Purpose | Upstream |
|---|---|---|
| **ManimGL** (`manimgl`) | Guidance for scenes, Mobjects, animations, LaTeX, graphs, updaters, 3D scenes, camera control, CLI rendering, debugging, and compatibility pitfalls. | [3b1b/manim](https://github.com/3b1b/manim) |

Skill directory: [`skills/manimgl/`](skills/manimgl/)

**Important:** ManimGL and Manim Community Edition are different projects. Instructions for one should not be assumed to work for the other.

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
├── .github/workflows/     # Automated validation
├── plugins/               # Agent plugin packages
├── registry/skills.json   # Machine-readable skill registry
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md
│       ├── references/
│       ├── examples/
│       └── evals/
├── install.ps1            # Windows PowerShell installer
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE
└── README.md
```

## Quality standard

Before publishing a skill, the project aims to establish:

1. The exact upstream repository and scope.
2. The version, release, or source state studied.
3. Official documentation review and source/API verification where appropriate.
4. Representative examples tested when practical.
5. Common failures and compatibility differences documented.
6. Evaluation prompts added.
7. Attribution and license information recorded.
8. No unnecessary copying of upstream source code.
9. No unsupported claims that code was tested or that a skill is production-ready.

## Creating a new RepoSkill

1. Identify the upstream repository and license.
2. Review its documentation and relevant source.
3. Record version-specific behavior and important compatibility differences.
4. Write a concise, triggerable `SKILL.md`.
5. Put detailed material in `references/`.
6. Add examples and evaluation prompts where useful.
7. Validate metadata, paths, and links.
8. Review the skill and publish only claims supported by evidence.

See [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Contributing and security

- [Contributing guide](CONTRIBUTING.md)
- [Security policy](SECURITY.md)
- [License](LICENSE)

Issues and contributions are welcome. Please describe the upstream project/version and provide reproducible examples for technical corrections.

---

**RepoSkillForge — turning repository knowledge into reusable AI capabilities.**