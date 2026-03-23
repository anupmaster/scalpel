#!/bin/bash
# ============================================================
# 🔪 Scalpel — Uninstall (Plug Out)
# Zero trace removal.
# https://github.com/anupmaster/scalpel
# ============================================================

set -e

PROJECT_DIR="${1:-.}"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}🔪 Scalpel — Unplugging...${NC}"
echo ""

# Remove agent symlink
if [ -f "$PROJECT_DIR/.claude/agents/scalpel.md" ] || [ -L "$PROJECT_DIR/.claude/agents/scalpel.md" ]; then
  rm -f "$PROJECT_DIR/.claude/agents/scalpel.md"
  echo -e "  ${GREEN}✓${NC} Removed .claude/agents/scalpel.md"
fi

# Remove logs directory
if [ -d "$PROJECT_DIR/.scalpel" ]; then
  rm -rf "$PROJECT_DIR/.scalpel"
  echo -e "  ${GREEN}✓${NC} Removed .scalpel/"
fi

# Clean .gitignore entries
if [ -f "$PROJECT_DIR/.gitignore" ]; then
  # macOS sed vs GNU sed compatibility
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' '/# Scalpel/d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    sed -i '' '/^\.scalpel\//d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    sed -i '' '/^\.claude\/agents\/scalpel\.md$/d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
  else
    sed -i '/# Scalpel/d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    sed -i '/^\.scalpel\//d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
    sed -i '/^\.claude\/agents\/scalpel\.md$/d' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
  fi
  # Remove trailing empty lines
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$PROJECT_DIR/.gitignore" 2>/dev/null || true
  fi
  echo -e "  ${GREEN}✓${NC} Cleaned .gitignore"
fi

echo ""
echo -e "${GREEN}✅ Scalpel unplugged. Zero trace remains.${NC}"
echo ""
echo "  Your project's git history, config, and code are untouched."
echo "  Only the code improvements from Scalpel's surgical team remain."
echo ""
