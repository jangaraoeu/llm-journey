#!/bin/bash
# Wire llm-journey into Omarchy: `lj` on PATH, bar widget plugin, and a "Learn" menu.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_ID="jangar.llm-journey"
MENU="$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"

mkdir -p "$HOME/.local/bin"
ln -sfn "$REPO/bin/lj" "$HOME/.local/bin/lj"
echo "✓ lj → ~/.local/bin/lj"

# Symlink so edits in the repo hot-reload in the shell.
ln -sfn "$REPO/omarchy/plugin" "$HOME/.config/omarchy/plugins/$PLUGIN_ID"
echo "✓ plugin → ~/.config/omarchy/plugins/$PLUGIN_ID"

if command -v omarchy-shell >/dev/null; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
  omarchy plugin enable "$PLUGIN_ID" && echo "✓ bar widget enabled (move it: omarchy bar move $PLUGIN_ID --section left)"
fi

# Insert the Learn submenu once, just before the final closing brace.
if [[ -f $MENU ]] && ! grep -q '"learn"' "$MENU"; then
  python3 - "$MENU" "$REPO/omarchy/menu.jsonc" <<'PY'
import sys, pathlib
menu, snippet = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2]).read_text()
s = menu.read_text()
i = s.rstrip().rfind("}")
menu.write_text(s[:i] + snippet + s[i:])
PY
  echo "✓ Learn submenu added to omarchy-menu"
fi
