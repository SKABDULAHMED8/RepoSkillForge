# Upstream & Provenance

## Skill

`win-shell-fixer`

## Origin

This skill is an original RepoSkillForge skill. It is not a wrapper or reproduction of a single upstream repository.

It was designed for RepoSkillForge to provide a compact, safety-first troubleshooting workflow for Windows CMD and PowerShell.

## Primary domain references

The skill's command behavior is based on standard Windows command-line and PowerShell behavior.

Relevant Microsoft documentation should be consulted when validating platform-specific behavior, especially for:

- Windows PowerShell
- PowerShell 7
- Windows command-line utilities
- Windows execution policy
- Windows networking
- DISM / SFC
- winget
- WSL

## Scope

The skill covers:

- Windows CMD
- Windows PowerShell 5.1
- PowerShell 7
- Common Windows command-line diagnostics
- PATH and command-not-found problems
- permissions and execution-policy issues
- networking and TLS diagnostics
- Git, npm, pip, winget and WSL troubleshooting
- Windows system repair diagnostics

## Safety provenance

The safety rules are intentional RepoSkillForge design requirements.

The skill must not recommend:

- disabling Defender, UAC or the firewall as a generic fix
- blindly executing downloaded content through `iex`
- requesting passwords, API keys or tokens
- destructive operations without identifying the target and obtaining confirmation

## Versioning

This document describes the provenance of the skill itself.

The skill should be updated when Windows, PowerShell, package-manager or WSL behavior changes materially.
