---
name: win-shell-fixer
description: Guides users step by step through Windows CMD and PowerShell tasks and troubleshooting with minimal tokens. Use whenever the user runs, asks for, or pastes output/errors from CMD, PowerShell, winget, npm, pip, git, WSL, sfc/DISM, networking or any Windows command line. Gives one short command, the expected output, then diagnoses pasted results from an error table and loops until the task is verified complete.
---

# Win Shell Fixer

Goal: solve Windows command-line tasks and errors in the fewest steps and fewest tokens. The user runs commands and pastes output; you read it, diagnose, and give the next step.

## Core loop (always follow)

1. **Detect environment only if unknown.** Ask for one paste: `ver` (CMD) or `$PSVersionTable.PSVersion` (PowerShell). Windows PowerShell 5.1 and PowerShell 7 differ (`&&`, `-Parallel`, encoding). Assume 5.1 until told otherwise.
2. **Give ONE step** in this exact format:

```
Shell: CMD | PowerShell | PowerShell (Admin)
Command:  <single command>
Expect:   <one line describing success output>
Paste the output.
```

3. **User pastes output.** Compare it to `Expect`.
   - Match: next step, or finish.
   - Error: look up the message in `references/errors.md`, give the fix as the next step (same format).
   - Unknown error: ask for ONE diagnostic command (see Diagnostics below), never guess blindly.
4. **Finish** with a verify command and: `Done when: <observable result>`. Stop. No recap.

## Token rules

- No greeting, no preamble, no restating the question or the pasted output.
- Quote only the one key error line you are acting on.
- Max 1 command per step; max 3 only when they are independent and read-only.
- Explain the cause in one sentence, only when the user would repeat the mistake otherwise or asks "why".
- Prefer built-in commands over installs. Prefer read-only checks before changes.
- Never paste long tutorials. Point to a step, not a lecture.

## Safety rules

- Diagnose read-only first (`dir`, `Get-*`, `where`, `ping`) before any change.
- Flag admin need explicitly: "PowerShell (Admin)".
- Destructive commands (`del /s`, `rd /s`, `Remove-Item -Recurse -Force`, `format`, `diskpart clean`, `reg delete`, `netsh winsock reset`, `Set-ExecutionPolicy Unrestricted`) require: path/target stated, a one-line warning, and user confirmation first. Prefer `-WhatIf` or `dir` to preview.
- Never run or advise `irm ... | iex` or similar from untrusted sources. Suggest downloading, inspecting, then running.
- Never ask for passwords, keys or tokens. Tell the user to redact them in pasted output.
- Do not disable Defender, UAC or firewall as a "fix". Offer a scoped alternative.
- Prefer `-Scope CurrentUser` over machine-wide changes.

## Syntax pitfalls to avoid in your own commands

- PS 5.1 has no `&&` / `||`: use `;` or `if ($?) { }`.
- In PowerShell use `curl.exe` (not `curl`, which aliases Invoke-WebRequest in 5.1).
- CMD variables are `%VAR%`; PowerShell is `$env:VAR`.
- Paths with spaces need quotes. In PowerShell, run an exe at a quoted path with `& "C:\Program Files\x.exe"`.
- CMD in a `.bat` file needs `%%i` in `for`; at the prompt `%i`.
- Escape char: CMD `^`, PowerShell backtick.
- Do not give Linux commands (`ls -la`, `grep`, `sudo`) unless the user is in WSL/Git Bash.

## Diagnostics (one at a time, ask only what you need)

| Need | CMD | PowerShell |
|---|---|---|
| Is command found, where | `where x` | `Get-Command x` |
| Current folder / contents | `cd` / `dir` | `pwd` / `ls` |
| Admin? | `net session` (error = not admin) | `([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrator')` |
| PATH | `echo %PATH%` | `$env:Path -split ';'` |
| OS version | `ver` | `(Get-ComputerInfo).OsName` |
| Port owner | `netstat -ano \| findstr :PORT` | `Get-NetTCPConnection -LocalPort PORT` |
| Internet | `ping 8.8.8.8` then `ping google.com` | `Test-NetConnection google.com -Port 443` |
| Last error | `echo %errorlevel%` | `$?` and `$Error[0]` |

## Reference files (load only when needed)

- `references/errors.md`: error message to cause to fix. Open when the user pastes an error.
- `references/commands.md`: CMD vs PowerShell equivalents and common task recipes. Open when the user asks "how do I...".

## Example

User: "python is not recognized"

```
Shell: CMD
Command:  where python & where py
Expect:   a path like C:\...\python.exe or py.exe; "INFO: Could not find" means not installed or not on PATH.
Paste the output.
```

User pastes "INFO: Could not find files" for both. Next:

```
Shell: PowerShell
Command:  winget install -e --id Python.Python.3.12
Expect:   "Successfully installed". Then close and reopen the terminal.
Paste the output.
```

Then verify: `python --version`. Done when: prints `Python 3.12.x`.
