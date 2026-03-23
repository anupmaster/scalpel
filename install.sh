#!/usr/bin/env bash
# Scalpel -- Install (Plug In) | https://github.com/anupmaster/scalpel
set -euo pipefail

# Colors (with terminal detection)
if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
  CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; NC=''
fi

SCALPEL_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="."; FORCE_AGENT=""; INSTALL_ALL=false; USE_SYMLINK=false

usage() {
  echo -e "${BOLD}Scalpel Installer${NC} -- Plug surgical AI into your project."
  echo ""
  echo "Usage: $(basename "$0") [OPTIONS] [PROJECT_DIR]"
  echo ""
  echo "Options:"
  echo "  --claude/--codex/--cursor/--gemini   Force specific agent"
  echo "  --windsurf/--aider/--opencode        Force specific agent"
  echo "  --all    Install for all detected agents"
  echo "  --link   Symlink adapter files instead of copying"
  echo "  --help   Show this help message"
  echo ""
  echo "If no agent flag is given, Scalpel auto-detects the best agent."
  exit 0
}

while [ $# -gt 0 ]; do
  case "$1" in
    --claude|--codex|--cursor|--gemini|--windsurf|--aider|--opencode)
      FORCE_AGENT="${1#--}" ;;
    --all)      INSTALL_ALL=true  ;;
    --link)     USE_SYMLINK=true  ;;
    --help|-h)  usage             ;;
    -*)         echo -e "${RED}Unknown option: $1${NC}"; usage ;;
    *)          PROJECT_DIR="$1"  ;;
  esac
  shift
done

PROJECT_DIR="$(cd "$PROJECT_DIR" 2>/dev/null && pwd)" || {
  echo -e "${RED}Error: Project directory not found${NC}"; exit 1
}

# Detection functions
detect_claude()   { command -v claude   >/dev/null 2>&1 || [ -d "$PROJECT_DIR/.claude" ]; }
detect_codex()    { command -v codex    >/dev/null 2>&1; }
detect_cursor()   { [ -f "$PROJECT_DIR/.cursorrules" ] || command -v cursor >/dev/null 2>&1; }
detect_gemini()   { command -v gemini   >/dev/null 2>&1; }
detect_windsurf() { [ -f "$PROJECT_DIR/.windsurfrules" ]; }
detect_aider()    { command -v aider    >/dev/null 2>&1; }
detect_opencode() { command -v opencode >/dev/null 2>&1; }

# Copy or symlink a file. Never overwrite non-Scalpel content.
place_file() {
  local src="$1" dst="$2"
  if [ -f "$dst" ] && ! grep -q "Scalpel" "$dst" 2>/dev/null && [ ! -L "$dst" ]; then
    echo -e "  ${YELLOW}Skipped${NC} $(basename "$dst") (non-Scalpel content exists)"; return 1
  fi
  mkdir -p "$(dirname "$dst")"
  if $USE_SYMLINK; then ln -sf "$src" "$dst"; echo -e "  ${GREEN}Linked${NC}  $(basename "$dst")"
  else cp -f "$src" "$dst"; echo -e "  ${GREEN}Copied${NC}  $(basename "$dst")"; fi
}

# Resolve adapter source: use adapter file if present, else fall back to scalpel.md
adapter_src() {
  local path="$SCALPEL_DIR/src/adapters/$1"
  if [ -f "$path" ]; then echo "$path"; else echo "$SCALPEL_DIR/src/scalpel.md"; fi
}

# Install for a single agent. Adds scanner.sh alongside the adapter.
install_agent() {
  local agent="$1" scanner="$SCALPEL_DIR/src/scanner.sh" src dst scanner_dst
  case "$agent" in
    claude)
      src="$SCALPEL_DIR/src/scalpel.md"; dst="$PROJECT_DIR/.claude/agents/scalpel.md"
      scanner_dst="$PROJECT_DIR/.claude/agents/scanner.sh" ;;
    codex)    src="$(adapter_src codex.md)";            dst="$PROJECT_DIR/AGENTS.md"
              scanner_dst="$PROJECT_DIR/.scalpel/scanner.sh" ;;
    cursor)   src="$(adapter_src cursor.cursorrules)";  dst="$PROJECT_DIR/.cursorrules"
              scanner_dst="$PROJECT_DIR/.scalpel/scanner.sh" ;;
    gemini)   src="$(adapter_src gemini.md)";           dst="$PROJECT_DIR/GEMINI.md"
              scanner_dst="$PROJECT_DIR/.scalpel/scanner.sh" ;;
    windsurf) src="$(adapter_src windsurf.md)";         dst="$PROJECT_DIR/.windsurfrules"
              scanner_dst="$PROJECT_DIR/.scalpel/scanner.sh" ;;
    aider)    src="$(adapter_src aider.md)";            dst="$PROJECT_DIR/.scalpel/aider.md"
              scanner_dst="$PROJECT_DIR/.scalpel/scanner.sh" ;;
    opencode) src="$(adapter_src opencode.md)";         dst="$PROJECT_DIR/.scalpel/opencode.md"
              scanner_dst="$PROJECT_DIR/.scalpel/scanner.sh" ;;
    *)        echo -e "${RED}Unknown agent: $agent${NC}"; return 1 ;;
  esac
  place_file "$src" "$dst"
  [ -f "$scanner" ] && place_file "$scanner" "$scanner_dst"
  INSTALLED+=("$agent")
}

# Usage hint per agent
hint() {
  case "$1" in
    claude)   echo "  Claude Code:  claude  ->  \"Hi Scalpel, start work\"" ;;
    codex)    echo "  Codex CLI:    codex   ->  \"Hi Scalpel, start work\"" ;;
    cursor)   echo "  Cursor:       Open project in Cursor (rules auto-loaded)" ;;
    gemini)   echo "  Gemini CLI:   gemini  ->  \"Hi Scalpel, start work\"" ;;
    windsurf) echo "  Windsurf:     Open project in Windsurf (rules auto-loaded)" ;;
    aider)    echo "  Aider:        aider --read .scalpel/aider.md" ;;
    opencode) echo "  OpenCode:     opencode -> \"Hi Scalpel, start work\"" ;;
  esac
}

# --- Main ---
echo ""
echo -e "${CYAN}${BOLD}Scalpel -- Plugging in...${NC}"
echo -e "  Project: ${GREEN}$(basename "$PROJECT_DIR")${NC}"
echo ""

if [ ! -f "$SCALPEL_DIR/src/scalpel.md" ]; then
  echo -e "${RED}Error: scalpel.md not found at $SCALPEL_DIR/src/scalpel.md${NC}"; exit 1
fi

INSTALLED=()

if [ -n "$FORCE_AGENT" ]; then
  echo -e "  Agent:   ${GREEN}$FORCE_AGENT${NC} (forced)"
  install_agent "$FORCE_AGENT"
elif $INSTALL_ALL; then
  echo -e "  Mode:    ${GREEN}all detected agents${NC}"
  for a in claude codex cursor gemini windsurf aider opencode; do
    "detect_$a" && install_agent "$a" || true
  done
else
  DETECTED=""
  for a in claude codex cursor gemini windsurf aider opencode; do
    if "detect_$a"; then DETECTED="$a"; break; fi
  done
  if [ -z "$DETECTED" ]; then
    echo -e "  ${YELLOW}No agent detected. Defaulting to Claude Code layout.${NC}"
    DETECTED="claude"
  fi
  echo -e "  Agent:   ${GREEN}$DETECTED${NC} (auto-detected)"
  install_agent "$DETECTED"
fi

# Create working directory and update .gitignore (idempotent)
mkdir -p "$PROJECT_DIR/.scalpel/logs"
touch "$PROJECT_DIR/.gitignore"
add_gi() { grep -qxF "$1" "$PROJECT_DIR/.gitignore" 2>/dev/null || echo "$1" >> "$PROJECT_DIR/.gitignore"; }
add_gi ""; add_gi "# Scalpel -- Surgical AI (portable, never committed)"
add_gi ".scalpel/"; add_gi ".claude/agents/scalpel.md"
echo -e "  Gitignore: ${GREEN}updated${NC}"

if git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH=$(git -C "$PROJECT_DIR" branch --show-current 2>/dev/null || echo "detached")
  COMMITS=$(git -C "$PROJECT_DIR" rev-list --count HEAD 2>/dev/null || echo "0")
  echo -e "  Git:       ${GREEN}$BRANCH ($COMMITS commits)${NC}"
fi

echo ""
if [ ${#INSTALLED[@]} -eq 0 ]; then
  echo -e "${YELLOW}No agents were installed. Use --help to see options.${NC}"; exit 1
fi

echo -e "${GREEN}${BOLD}Scalpel plugged in.${NC} Installed for: ${GREEN}${INSTALLED[*]}${NC}"
echo ""
for agent in "${INSTALLED[@]}"; do hint "$agent"; done
echo ""
echo '  Quick commands: "Scalpel scan" | "Scalpel start" | "Scalpel skip recon"'
echo ""
echo -e "  To unplug:  ${CYAN}$SCALPEL_DIR/uninstall.sh $PROJECT_DIR${NC}"
echo ""
