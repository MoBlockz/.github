# MoBlockz Organization Defaults

This repository supplies organization-wide GitHub defaults and shared AI coding rules for **MoBlockz** (`https://moblockz.com`).

## What's Inside

- `.github/pull_request_template.md` — Automatically applied by GitHub to every repository in `MoBlockz` (`Observed / Not Run` and `Performance` disclosure).
- `GLOBAL_AGENTS.md` — Shared Week 1 engineering guardrails and kid-safe `MoBlockz` rules (including auto-bootstrapping `AGENTS.md` + `CLAUDE.md` on every new repo).
- `install-windows.ps1` / `install-mac.sh` — Idempotent one-line installers that sync `GLOBAL_AGENTS.md` into Claude Code, Codex, and Antigravity using safe `<!-- moblockz-rules:start/end -->` markers without touching existing personal rules. They also cover extra Claude Code config folders (`CLAUDE_CONFIG_DIR`, or any `~/.claude_*` folder with a `projects/` subfolder), which apps like T3 Code use instead of `~/.claude`.

## One-Time Setup on the Robbs PC (Windows PowerShell)

Run once in PowerShell to keep Claude Code, Codex, and Antigravity automatically configured for every existing and future repo:

```powershell
irm https://raw.githubusercontent.com/MoBlockz/.github/main/install-windows.ps1 | iex
```

Re-run the same command anytime to pull rule updates.

## One-Time Setup on macOS

```sh
curl -fsSL https://raw.githubusercontent.com/MoBlockz/.github/main/install-mac.sh | bash
```

## Starting a New Game Repo

Create new repositories from **[MoBlockz/game-template](https://github.com/MoBlockz/game-template)** ("Use this template") so `AGENTS.md`, `CLAUDE.md`, and `.gitignore` are already wired from commit 1.
