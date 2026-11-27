$ErrorActionPreference = "Stop"

$RulesUrl = "https://raw.githubusercontent.com/MoBlockz/.github/main/GLOBAL_AGENTS.md"
$StartMarker = "<!-- moblockz-rules:start -->"
$EndMarker = "<!-- moblockz-rules:end -->"

Write-Host "Downloading MoBlockz global agent rules..." -ForegroundColor Cyan
$RulesBody = (Invoke-WebRequest -UseBasicParsing -Uri $RulesUrl).Content.Trim()
$Block = "$StartMarker`n$RulesBody`n$EndMarker"

$Targets = @(
  (Join-Path $env:USERPROFILE ".claude\CLAUDE.md"),
  (Join-Path $env:USERPROFILE ".codex\AGENTS.md"),
  (Join-Path $env:USERPROFILE ".gemini\config\AGENTS.md")
)

# Apps that run Claude Code with their own config folder (CLAUDE_CONFIG_DIR, e.g. ~/.claude_personal)
# never read ~/.claude/CLAUDE.md, so write the rules there too.
$ClaudeDirs = @()
if ($env:CLAUDE_CONFIG_DIR) { $ClaudeDirs += $env:CLAUDE_CONFIG_DIR }
$ClaudeDirs += Get-ChildItem -Path $env:USERPROFILE -Directory -Force -Filter ".claude_*" -ErrorAction SilentlyContinue |
  Where-Object { Test-Path (Join-Path $_.FullName "projects") } |
  ForEach-Object { $_.FullName }
foreach ($Dir in $ClaudeDirs) {
  $Target = Join-Path $Dir "CLAUDE.md"
  if ($Targets -notcontains $Target) { $Targets += $Target }
}

foreach ($Target in $Targets) {
  $Dir = Split-Path -Parent $Target
  if (-not (Test-Path $Dir)) {
    New-Item -ItemType Directory -Path $Dir -Force | Out-Null
  }

  if (Test-Path $Target) {
    $Existing = Get-Content -Path $Target -Raw -ErrorAction SilentlyContinue
    if ($null -eq $Existing) { $Existing = "" }
    $Pattern = [regex]::Escape($StartMarker) + "[\s\S]*?" + [regex]::Escape($EndMarker)
    if ($Existing -match $Pattern) {
      $Updated = [regex]::Replace($Existing, $Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $Block })
    } elseif ($Existing.Trim().Length -gt 0) {
      $Updated = $Existing.TrimEnd() + "`n`n" + $Block + "`n"
    } else {
      $Updated = $Block + "`n"
    }
  } else {
    $Updated = $Block + "`n"
  }

  [System.IO.File]::WriteAllText($Target, $Updated, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "Updated: $Target" -ForegroundColor Green
}

Write-Host "`nDone! Claude Code, Codex, and Antigravity on this PC will now automatically load MoBlockz rules on every repo." -ForegroundColor Cyan
