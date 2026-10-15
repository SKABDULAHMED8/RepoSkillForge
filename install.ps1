param(
    [Parameter(Position=0)]
    [string]$Skill = "all"
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsRoot = Join-Path $RepoRoot "skills"
$Registry = Join-Path $RepoRoot "registry\skills.json"
$ClaudeSkills = Join-Path $HOME ".claude\skills"

function Install-Skill {
    param([string]$Name)

    $Source = Join-Path $SkillsRoot $Name
    $Destination = Join-Path $ClaudeSkills $Name

    if (-not (Test-Path $Source)) {
        Write-Host "ERROR: Skill '$Name' was not found." -ForegroundColor Red
        return $false
    }

    $SkillFile = Join-Path $Source "SKILL.md"

    if (-not (Test-Path $SkillFile)) {
        Write-Host "ERROR: SKILL.md missing for '$Name'." -ForegroundColor Red
        return $false
    }

    New-Item -ItemType Directory -Path $ClaudeSkills -Force | Out-Null

    if (Test-Path $Destination) {
        Remove-Item $Destination -Recurse -Force
    }

    Copy-Item $Source $Destination -Recurse -Force

    Write-Host "OK: Installed $Name -> $Destination" -ForegroundColor Green
    return $true
}

if ($Skill -eq "all") {
    if (-not (Test-Path $SkillsRoot)) {
        Write-Host "ERROR: skills directory not found." -ForegroundColor Red
        exit 1
    }

    $Installed = 0

    Get-ChildItem $SkillsRoot -Directory | ForEach-Object {
        if (Install-Skill $_.Name) {
            $Installed++
        }
    }

    Write-Host ""
    Write-Host "Installed $Installed skill(s)." -ForegroundColor Cyan
}
else {
    if (-not (Install-Skill $Skill)) {
        exit 1
    }
}

Write-Host ""
Write-Host "RepoSkillForge installation complete." -ForegroundColor Cyan