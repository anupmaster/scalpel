#!/bin/bash
# ============================================================
# 🔪 Scalpel — Install (Plug In)
# Surgical AI for your codebase.
# https://github.com/anupmaster/scalpel
# ============================================================

set -e

SCALPEL_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${1:-.}"
AGENT_SOURCE="$SCALPEL_DIR/src/scalpel.md"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}🔪 Scalpel — Plugging in...${NC}"
echo ""

# Verify scalpel.md exists
if [ ! -f "$AGENT_SOURCE" ]; then
  echo "Error: scalpel.md not found at $AGENT_SOURCE"
  echo "Make sure you're running this from the Scalpel directory."
  exit 1
fi

# Detect coding agent
AGENT_TYPE="unknown"
if command -v claude &> /dev/null; then
  AGENT_TYPE="claude-code"
elif command -v codex &> /dev/null; then
  AGENT_TYPE="codex"
elif command -v gemini &> /dev/null; then
  AGENT_TYPE="gemini-cli"
elif command -v opencode &> /dev/null; then
  AGENT_TYPE="opencode"
fi

echo -e "  Project:  ${GREEN}$(basename "$(cd "$PROJECT_DIR" && pwd)")${NC}"
echo -e "  Agent:    ${GREEN}${AGENT_TYPE}${NC}"

# Install based on detected agent
case "$AGENT_TYPE" in
  "claude-code")
    mkdir -p "$PROJECT_DIR/.claude/agents"
    ln -sf "$AGENT_SOURCE" "$PROJECT_DIR/.claude/agents/scalpel.md"
    echo -e "  Installed: ${GREEN}.claude/agents/scalpel.md (symlink)${NC}"
    ;;
  *)
    mkdir -p "$PROJECT_DIR/.claude/agents"
    ln -sf "$AGENT_SOURCE" "$PROJECT_DIR/.claude/agents/scalpel.md"
    echo -e "  Installed: ${GREEN}.claude/agents/scalpel.md (symlink)${NC}"
    echo -e "  ${YELLOW}Note: Detected '$AGENT_TYPE'. Scalpel is installed for Claude Code.${NC}"
    echo -e "  ${YELLOW}For other agents, copy src/scalpel.md to your agent's config.${NC}"
    ;;
esac

# Create logs directory
mkdir -p "$PROJECT_DIR/.scalpel/logs"
echo -e "  Logs:     ${GREEN}.scalpel/logs/${NC}"

# Update .gitignore (idempotent)
touch "$PROJECT_DIR/.gitignore"

add_gitignore() {
  grep -qxF "$1" "$PROJECT_DIR/.gitignore" 2>/dev/null || echo "$1" >> "$PROJECT_DIR/.gitignore"
}

add_gitignore ""
add_gitignore "# Scalpel — Surgical AI (portable, never committed)"
add_gitignore ".scalpel/"
add_gitignore ".claude/agents/scalpel.md"

echo -e "  Gitignore: ${GREEN}Updated (Scalpel excluded from commits)${NC}"

# Verify git
if git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
  BRANCH=$(git -C "$PROJECT_DIR" branch --show-current 2>/dev/null || echo "detached")
  COMMITS=$(git -C "$PROJECT_DIR" rev-list --count HEAD 2>/dev/null || echo "0")
  echo -e "  Git:      ${GREEN}$BRANCH ($COMMITS commits)${NC}"
else
  echo -e "  Git:      ${YELLOW}Not a git repo (some features limited)${NC}"
fi

echo ""
echo -e "${GREEN}✅ Scalpel plugged in.${NC}"
echo ""
echo "  Next steps:"
echo "    1. Start your coding agent:  claude  (or codex, gemini, opencode)"
echo '    2. Say:  Hi Scalpel, start work'
echo ""
echo "  Quick commands inside your agent:"
echo '    "Scalpel scan"       → Diagnostic only (no changes)'
echo '    "Scalpel start"      → Full protocol (scan → team → build)'
echo '    "Scalpel skip recon" → Jump straight to task execution'
echo ""
echo -e "  To unplug:  ${CYAN}$SCALPEL_DIR/uninstall.sh $PROJECT_DIR${NC}"
echo ""
