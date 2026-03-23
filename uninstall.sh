#!/usr/bin/env bash
# ============================================================
# Scalpel -- Uninstall (Plug Out)
# Zero trace removal.
# https://github.com/anupmaster/scalpel
# ============================================================

set -euo pipefail

# --- Colors (with terminal detection) ---
if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
  CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; NC=''
fi

PROJECT_DIR="."
PURGE=false

# --- Usage ---
usage() {
  cat <<HELP
${BOLD}Scalpel Uninstaller${NC} -- Remove Scalpel from your project.

Usage: $(basename "$0") [OPTIONS] [PROJECT_DIR]

Options:
  --purge   Also remove scalpel.config.json
  --help    Show this help message

Removes all Scalpel adapter files, scanner, logs, and .gitignore entries.
Your code and git history are never touched.
HELP
  exit 0
}

# --- Parse arguments ---
while [ $# -gt 0 ]; do
  case "$1" in
    --purge)    PURGE=true       ;;
    --help|-h)  usage            ;;
    -*)         echo -e "${RED}Unknown option: $1${NC}"; usage ;;
    *)          PROJECT_DIR="$1" ;;
  esac
  shift
done

PROJECT_DIR="$(cd "$PROJECT_DIR" 2>/dev/null && pwd)" || {
  echo -e "${RED}Error: Project directory not found: $PROJECT_DIR${NC}"; exit 1
}

echo ""
echo -e "${CYAN}${BOLD}Scalpel -- Unplugging...${NC}"
echo -e "  Project: ${GREEN}$(basename "$PROJECT_DIR")${NC}"
echo ""

REMOVED=0

# --- Helper: remove a file or symlink ---
remove_file() {
  local path="$1" label="$2"
  if [ -f "$path" ] || [ -L "$path" ]; then
    rm -f "$path"
    echo -e "  ${GREEN}Removed${NC}  $label"
    REMOVED=$((REMOVED + 1))
  fi
}

# --- Helper: remove file only if it contains Scalpel content ---
remove_if_scalpel() {
  local path="$1" label="$2"
  if [ -L "$path" ]; then
    rm -f "$path"
    echo -e "  ${GREEN}Removed${NC}  $label (symlink)"
    REMOVED=$((REMOVED + 1))
  elif [ -f "$path" ] && grep -q "Scalpel" "$path" 2>/dev/null; then
    rm -f "$path"
    echo -e "  ${GREEN}Removed${NC}  $label"
    REMOVED=$((REMOVED + 1))
  elif [ -f "$path" ]; then
    echo -e "  ${YELLOW}Skipped${NC}  $label (non-Scalpel content)"
  fi
}

# --- Claude Code ---
remove_file "$PROJECT_DIR/.claude/agents/scalpel.md" ".claude/agents/scalpel.md"
remove_file "$PROJECT_DIR/.claude/agents/scanner.sh" ".claude/agents/scanner.sh"
# Clean up empty agents dir
if [ -d "$PROJECT_DIR/.claude/agents" ]; then
  rmdir "$PROJECT_DIR/.claude/agents" 2>/dev/null || true
fi

# --- Codex CLI ---
remove_if_scalpel "$PROJECT_DIR/AGENTS.md" "AGENTS.md"

# --- Cursor ---
remove_if_scalpel "$PROJECT_DIR/.cursorrules" ".cursorrules"

# --- Gemini CLI ---
remove_if_scalpel "$PROJECT_DIR/GEMINI.md" "GEMINI.md"

# --- Windsurf ---
remove_if_scalpel "$PROJECT_DIR/.windsurfrules" ".windsurfrules"

# --- Aider ---
remove_file "$PROJECT_DIR/.scalpel/aider.md" ".scalpel/aider.md"

# --- OpenCode ---
remove_file "$PROJECT_DIR/.scalpel/opencode.md" ".scalpel/opencode.md"

# --- Scanner ---
remove_file "$PROJECT_DIR/.scalpel/scanner.sh" ".scalpel/scanner.sh"

# --- .scalpel/ directory (logs, working data) ---
if [ -d "$PROJECT_DIR/.scalpel" ]; then
  rm -rf "$PROJECT_DIR/.scalpel"
  echo -e "  ${GREEN}Removed${NC}  .scalpel/"
  REMOVED=$((REMOVED + 1))
fi

# --- Config (only with --purge) ---
if $PURGE; then
  remove_file "$PROJECT_DIR/scalpel.config.json" "scalpel.config.json"
else
  if [ -f "$PROJECT_DIR/scalpel.config.json" ]; then
    echo -e "  ${YELLOW}Kept${NC}    scalpel.config.json (use --purge to remove)"
  fi
fi

# --- Clean .gitignore entries ---
if [ -f "$PROJECT_DIR/.gitignore" ]; then
  # macOS sed vs GNU sed compatibility
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' '/# Scalpel/d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    sed -i '' '/^\.scalpel\//d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    sed -i '' '/^\.claude\/agents\/scalpel\.md$/d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    # Remove trailing blank lines
    sed -i '' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
  else
    sed -i '/# Scalpel/d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    sed -i '/^\.scalpel\//d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    sed -i '/^\.claude\/agents\/scalpel\.md$/d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    # Remove trailing blank lines
    sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
  fi
  echo -e "  ${GREEN}Cleaned${NC} .gitignore"
fi

# --- Summary ---
echo ""
if [ $REMOVED -gt 0 ]; then
  echo -e "${GREEN}${BOLD}Scalpel unplugged.${NC} Removed $REMOVED item(s). Zero trace remains."
else
  echo -e "${YELLOW}Nothing to remove. Scalpel was not installed in this project.${NC}"
fi
echo ""
echo "  Your project's git history, config, and code are untouched."
echo "  Only the code improvements from Scalpel's surgical team remain."
echo ""
