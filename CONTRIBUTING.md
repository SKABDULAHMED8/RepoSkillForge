# Contributing to RepoSkillForge

## New skill workflow

1. Identify the exact upstream repository.
2. Check its license.
3. Read its README and official documentation.
4. Inspect important source/API modules.
5. Identify version-specific behavior.
6. Create `skills/<name>/SKILL.md`.
7. Add references only where useful.
8. Add runnable examples when practical.
9. Add evaluation prompts.
10. Test representative examples.
11. Update `registry/skills.json`.
12. Submit a pull request.

## Quality rules

- Never invent an API.
- Never claim an example was tested if it was not.
- Never silently substitute a different project.
- Record important version assumptions.
- Avoid copying large amounts of upstream source.
- Preserve required upstream attribution.
- Do not include secrets or credentials.
- Keep destructive commands clearly identified.

## PR title

Use:

```text
feat(skill): add <project> skill
```

Include the upstream repository, version/commit studied, tests performed, known limitations, and licensing information.
