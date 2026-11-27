#!/usr/bin/env bash
set -euo pipefail

RULES_URL="https://raw.githubusercontent.com/MoBlockz/.github/main/GLOBAL_AGENTS.md"
START_MARKER="<!-- moblockz-rules:start -->"
END_MARKER="<!-- moblockz-rules:end -->"

TMP_RULES="$(mktemp)"
trap 'rm -f "$TMP_RULES"' EXIT

curl -fsSL "$RULES_URL" -o "$TMP_RULES"

TARGETS=(
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.codex/AGENTS.md"
  "$HOME/.gemini/config/AGENTS.md"
)

# Apps that run Claude Code with their own config folder (CLAUDE_CONFIG_DIR, e.g. ~/.claude_personal)
# never read ~/.claude/CLAUDE.md, so write the rules there too.
CLAUDE_DIRS=()
if [ -n "${CLAUDE_CONFIG_DIR:-}" ]; then CLAUDE_DIRS+=("$CLAUDE_CONFIG_DIR"); fi
for DIR in "$HOME"/.claude_*/; do
  if [ -d "${DIR}projects" ]; then CLAUDE_DIRS+=("${DIR%/}"); fi
done
for DIR in ${CLAUDE_DIRS[@]+"${CLAUDE_DIRS[@]}"}; do
  T="$DIR/CLAUDE.md"
  case " ${TARGETS[*]} " in *" $T "*) ;; *) TARGETS+=("$T") ;; esac
done

for TARGET in "${TARGETS[@]}"; do
  mkdir -p "$(dirname "$TARGET")"
  node -e '
    const fs = require("node:fs");
    const target = process.argv[1];
    const body = fs.readFileSync(process.argv[2], "utf8").trim();
    const start = process.argv[3];
    const end = process.argv[4];
    const block = `${start}\n${body}\n${end}`;
    let existing = fs.existsSync(target) ? fs.readFileSync(target, "utf8") : "";
    const esc = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    const re = new RegExp(`${esc(start)}[\\s\\S]*?${esc(end)}`);
    let next;
    if (re.test(existing)) {
      next = existing.replace(re, () => block);
    } else if (existing.trim().length > 0) {
      next = `${existing.trimEnd()}\n\n${block}\n`;
    } else {
      next = `${block}\n`;
    }
    fs.writeFileSync(target, next, "utf8");
    console.log(`Updated: ${target}`);
  ' "$TARGET" "$TMP_RULES" "$START_MARKER" "$END_MARKER"
done
