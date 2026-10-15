param(
    [Parameter(Position = 0)]
    [string]$Skill = "all"
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsRoot = Join-Path $RepoRoot "skills"
$ClaudeSkillsRoot = Join-Path $HOME ".claude\skills"
$RegistryFile = Join-Path $RepoRoot "registry\skills.json"

function Write-Info($Message) {
    Write-Host $Message -ForegroundColor Cyan
}

function Write-OK($Message) {
    Write-Host "OK: $Message" -ForegroundColor Green
}

function Write-Warn($Message) {
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

if (-not (Test-Path $SkillsRoot)) {
    throw "Skills directory not found: $SkillsRoot"
}

if (-not (Test-Path $RegistryFile)) {
    throw "Registry file not found: $RegistryFile"
}

try {
    $Registry = Get-Content $RegistryFile -Raw | ConvertFrom-Json
}
catch {
    throw "registry/skills.json is not valid JSON."
}

if (-not $Registry.skills) {
    throw "No skills found in registry/skills.json."
}

$AvailableSkills = @(
    $Registry.skills | ForEach-Object {
        if ($_.id) {
            $_.id
        }
        elseif ($_.name) {
            $_.name
        }
    }
)

if ($Skill -eq "list") {
    Write-Info "`nAvailable RepoSkillForge skills:"
    
    foreach ($Name in $AvailableSkills) {
        Write-Host "  - $Name"
    }
    
    exit 0
}

if ($Skill -eq "all") {
    $SelectedSkills = Get-ChildItem $SkillsRoot -Directory
}
else {
    $SkillDirectory = Join-Path $SkillsRoot $Skill

    if (-not (Test-Path $SkillDirectory -PathType Container)) {
        Write-Host "`nSkill '$Skill' was not found." -ForegroundColor Red
        Write-Host "`nAvailable skills:"
        
        foreach ($Name in $AvailableSkills) {
            Write-Host "  - $Name"
        }
        
        exit 1
    }

    $SelectedSkills = @(Get-Item $SkillDirectory)
}

New-Item -ItemType Directory -Force -Path $ClaudeSkillsRoot | Out-Null

foreach ($SkillDirectory in $SelectedSkills) {

    $SkillName = $SkillDirectory.Name
    $Source = $SkillDirectory.FullName
    $Destination = Join-Path $ClaudeSkillsRoot $SkillName
    $SkillFile = Join-Path $Source "SKILL.md"

    if (-not (Test-Path $SkillFile)) {
        Write-Warn "Skipping '$SkillName' - SKILL.md is missing."
        continue
    }

    if (Test-Path $Destination) {
        $Backup = "$Destination.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

        Write-Info "Existing installation found: $Destination"
        Write-Info "Creating backup: $Backup"

        Copy-Item $Destination $Backup -Recurse -Force
        Remove-Item $Destination -Recurse -Force
    }

    New-Item -ItemType Directory -Force -Path $Destination | Out-Null

    Copy-Item "$Source\*" $Destination -Recurse -Force

    Write-OK "Installed $SkillName -> $Destination"
}

Write-Host ""
Write-Host "RepoSkillForge installation complete." -ForegroundColor Green
Write-Host ""
Write-Host "Commands:"
Write-Host "  .\install.ps1 list"
Write-Host "  .\install.ps1 manimgl"
Write-Host "  .\install.ps1 all"