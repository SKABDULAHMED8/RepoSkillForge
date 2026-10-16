# win-shell-fixer

A token-lean skill that makes any AI a precise Windows CMD / PowerShell troubleshooter.
Loop: one command, expected output, you paste output, AI diagnoses from an error table, repeat until verified done.

## Contents
- `SKILL.md`: core protocol (loop, token rules, safety rules, syntax pitfalls, diagnostics)
- `references/errors.md`: error message to cause to fix (loaded only when you paste an error)
- `references/commands.md`: CMD vs PowerShell equivalents and recipes (loaded on "how do I...")

## Install

**Claude (claude.ai / Claude Desktop):** Settings > Capabilities > Skills > Upload skill, choose `win-shell-fixer.zip`.

**Claude Code:** copy the folder to `~/.claude/skills/win-shell-fixer/` (Windows: `%USERPROFILE%\.claude\skills\win-shell-fixer\`). Or per project: `.claude/skills/win-shell-fixer/`.

**ChatGPT / Custom GPT:** paste `SKILL.md` body into Instructions; upload the two reference files under Knowledge.

**Gemini (Gem), Copilot, DeepSeek, Grok, Perplexity Spaces, any chat AI:** paste `SKILL.md` as the system/custom instruction; paste `errors.md` or `commands.md` into chat only when needed.

**Local models / API:** use `SKILL.md` as the system prompt; inject reference files on demand.

## Use
Just say what you want or paste the error:
- "python is not recognized"
- "Install Node and verify"
- paste any red error text

The AI replies with:
```
Shell: PowerShell
Command:  <one command>
Expect:   <success output>
Paste the output.
```

## Customize
Add rows to `references/errors.md` for errors you hit often. Keep each row to one line.
