# MoBlockz Global Engineering Rules

These rules apply across all `MoBlockz` repositories and kids' game projects. When a repository has its own `AGENTS.md`, follow both (repo-specific rules win on conflicts).

## Working with Kids (`MoBlockz` Games & Minecraft Add-ons)

- **Keep it simple and encouraging.** Kids (including a 9-year-old) build and playtest these projects. Use plain, short explanations and handle git, file organization, and checks yourself instead of asking a kid to run terminal commands.
- **Keep games safe by default.** Browser games must stay zero-ad, zero-login, and use private room codes only for multiplayer. Minecraft Bedrock add-ons must stay family-safe, avoid modifying vanilla files where possible, and remind players to back up worlds before installing.
- **Ask a grown-up before publishing.** Get a parent's OK before making a repo public, turning on GitHub Pages, publishing a release or download, or adding a game to `moblockz.com`. Working on private repos and local files does not need this.
- **Make original games.** Genres and mechanics are fine to borrow (tower drop, platformer, racing). Names, characters, art, music, and levels should be the kid's own, not copied from an existing game, even if renamed.
- **Playable on cheap devices.** Check new games and heavy effects on a slower phone or Chromebook, or with the browser's CPU throttling. If it stutters, add a low-effects mode or scale effects down automatically.
- **Don't rely on colour alone.** Danger, goals, and team sides need a shape, pattern, icon, or label as well as a colour, so colour-blind players can tell them apart.
- **Auto-bootstrap new repos moving forward.** Whenever you create a new repo in `MoBlockz` — or work in a `MoBlockz` repo that does not yet have `AGENTS.md` — add a concise, stack-appropriate `AGENTS.md` and a 1-line `CLAUDE.md` containing `@AGENTS.md`. Never add fake scripts or unnecessary build tooling to simple HTML/JS games.

## Core Engineering Guardrails

- **Run one local check once.** If the repo defines a diff-scoped check command (such as `bun run check:changed` or `node verify.cjs`), run it once when done editing. If it passes (including cache hits), do not also re-run redundant full suites. Never pass `--no-verify`.
- **Report Observed vs. Not run.** State the exact commands or browser checks you ran and what was skipped. Never claim a game works without running syntax/build checks or testing the actual behavior.
- **Choose good compromises.** Prefer direct, readable solutions (or idempotency key + check + retry) over speculative abstractions.
- **Doc voice.** Write plain, concrete prose. Avoid filler ("It's not X, it's Y", "robust", "seamless", "and that matters"). Integrate doc edits into existing sections instead of appending.
- **Multi-agent Git safety.** Never run `git add -A`, `git stash`, `git reset --hard`, or force-push shared branches. Stage explicit file paths. Never kill processes by name pattern.
- **Selective tests.** Prove behavior against the real game, script, or app. Commit automated tests where a silent regression is costly (game rules/physics invariants, parsers, URLs/assets, Bedrock pack schemas). Skip brittle mock UI tests.
- **Keep private source private.** Never copy licensed `@repo/blocks` / Shadcnblocks source from `MoBlockz/website` into public repos. Keep `.audit/` and `.qa/` local captures gitignored.
