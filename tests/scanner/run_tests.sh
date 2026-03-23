#!/usr/bin/env bash
set -euo pipefail

# run_tests.sh — Test suite for the Scalpel standalone scanner.
# Runs scanner.sh against each fixture project and validates output in all modes.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
SCANNER="${PROJECT_ROOT}/src/scanner.sh"
FIXTURES_DIR="${SCRIPT_DIR}/fixtures"
SETUP_SCRIPT="${SCRIPT_DIR}/setup_fixtures.sh"

# Counters
PASS=0
FAIL=0
SKIP=0
TOTAL=0

# Colors (disabled if not a terminal)
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[0;33m'
    CYAN='\033[0;36m'
    RESET='\033[0m'
else
    GREEN='' RED='' YELLOW='' CYAN='' RESET=''
fi

# --------------------------------------------------------------------------
# Test helpers
# --------------------------------------------------------------------------

assert() {
    local name="$1"
    local condition="$2" # "pass" or "fail"
    local detail="${3:-}"
    TOTAL=$((TOTAL + 1))
    if [[ "$condition" == "pass" ]]; then
        PASS=$((PASS + 1))
        printf "  ${GREEN}PASS${RESET}  %s\n" "$name"
    else
        FAIL=$((FAIL + 1))
        printf "  ${RED}FAIL${RESET}  %s\n" "$name"
        if [[ -n "$detail" ]]; then
            printf "        %s\n" "$detail"
        fi
    fi
}

skip_test() {
    local name="$1"
    local reason="$2"
    TOTAL=$((TOTAL + 1))
    SKIP=$((SKIP + 1))
    printf "  ${YELLOW}SKIP${RESET}  %s (%s)\n" "$name" "$reason"
}

# Run scanner and capture output + exit code
run_scanner() {
    local fixture_dir="$1"
    shift
    local output
    local exit_code=0
    output="$(cd "$fixture_dir" && bash "$SCANNER" "$@" 2>&1)" || exit_code=$?
    echo "$output"
    return $exit_code
}

# --------------------------------------------------------------------------
# Pre-flight checks
# --------------------------------------------------------------------------

echo ""
echo "${CYAN}========================================${RESET}"
echo "${CYAN}  Scalpel Scanner Test Suite${RESET}"
echo "${CYAN}========================================${RESET}"
echo ""

# Check scanner exists
if [[ ! -f "$SCANNER" ]]; then
    echo "${RED}ERROR: scanner.sh not found at ${SCANNER}${RESET}"
    echo "The scanner must be built before running tests."
    exit 1
fi

chmod +x "$SCANNER"

# Initialize fixtures if .git dirs are missing
needs_setup=false
for fixture in nextjs-project python-project empty-repo; do
    if [[ ! -d "${FIXTURES_DIR}/${fixture}/.git" ]]; then
        needs_setup=true
        break
    fi
done

if $needs_setup; then
    echo "Initializing fixture git repositories..."
    chmod +x "$SETUP_SCRIPT"
    bash "$SETUP_SCRIPT"
    echo ""
fi

# --------------------------------------------------------------------------
# Test Suite: nextjs-project (expected score: 75-90)
# --------------------------------------------------------------------------

echo "${CYAN}--- nextjs-project ---${RESET}"
NEXTJS="${FIXTURES_DIR}/nextjs-project"

# Test: default (terminal) output runs without error
output="$(run_scanner "$NEXTJS" 2>&1)" && ec=0 || ec=$?
assert "terminal mode exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

# Test: terminal output contains box-drawing characters
if echo "$output" | grep -q '║\|╔\|╚'; then
    assert "terminal output contains Vitals box characters" "pass"
else
    assert "terminal output contains Vitals box characters" "fail" "no box chars found"
fi

# Test: --json output is valid JSON
json_output="$(run_scanner "$NEXTJS" --json 2>&1)" && ec=0 || ec=$?
assert "--json exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if echo "$json_output" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
    assert "--json output is valid JSON" "pass"
else
    assert "--json output is valid JSON" "fail" "python3 json.load failed"
fi

# Test: --score-only output is a single integer 0-100
score_output="$(run_scanner "$NEXTJS" --score-only 2>&1)" && ec=0 || ec=$?
assert "--score-only exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

score_trimmed="$(echo "$score_output" | tr -d '[:space:]')"
if [[ "$score_trimmed" =~ ^[0-9]+$ ]] && [ "$score_trimmed" -ge 0 ] && [ "$score_trimmed" -le 100 ]; then
    assert "--score-only output is integer 0-100" "pass"
else
    assert "--score-only output is integer 0-100" "fail" "got: '$score_trimmed'"
fi

# Test: score is in expected range (75-90 for well-structured project)
if [[ "$score_trimmed" =~ ^[0-9]+$ ]] && [ "$score_trimmed" -ge 65 ] && [ "$score_trimmed" -le 95 ]; then
    assert "nextjs score in expected range (65-95)" "pass"
else
    assert "nextjs score in expected range (65-95)" "fail" "got: $score_trimmed"
fi

# Test: --markdown output starts with #
md_output="$(run_scanner "$NEXTJS" --markdown 2>&1)" && ec=0 || ec=$?
assert "--markdown exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if echo "$md_output" | head -5 | grep -q '^#'; then
    assert "--markdown output starts with #" "pass"
else
    assert "--markdown output starts with #" "fail" "first lines: $(echo "$md_output" | head -3)"
fi

# Test: --ci output contains GitHub Actions annotations
ci_output="$(run_scanner "$NEXTJS" --ci 2>&1)" && ec=0 || ec=$?
assert "--ci exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if echo "$ci_output" | grep -q '::notice\|::warning\|::error'; then
    assert "--ci output contains GH Actions annotations" "pass"
else
    assert "--ci output contains GH Actions annotations" "fail" "no ::notice/::warning found"
fi

echo ""

# --------------------------------------------------------------------------
# Test Suite: python-project (expected score: 55-80)
# --------------------------------------------------------------------------

echo "${CYAN}--- python-project ---${RESET}"
PYTHON="${FIXTURES_DIR}/python-project"

# Test: default output runs without error
output="$(run_scanner "$PYTHON" 2>&1)" && ec=0 || ec=$?
assert "terminal mode exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

# Test: terminal output contains box-drawing characters
if echo "$output" | grep -q '║\|╔\|╚'; then
    assert "terminal output contains Vitals box characters" "pass"
else
    assert "terminal output contains Vitals box characters" "fail" "no box chars found"
fi

# Test: --json is valid JSON
json_output="$(run_scanner "$PYTHON" --json 2>&1)" && ec=0 || ec=$?
assert "--json exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if echo "$json_output" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
    assert "--json output is valid JSON" "pass"
else
    assert "--json output is valid JSON" "fail" "python3 json.load failed"
fi

# Test: --score-only
score_output="$(run_scanner "$PYTHON" --score-only 2>&1)" && ec=0 || ec=$?
score_trimmed="$(echo "$score_output" | tr -d '[:space:]')"

assert "--score-only exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if [[ "$score_trimmed" =~ ^[0-9]+$ ]] && [ "$score_trimmed" -ge 0 ] && [ "$score_trimmed" -le 100 ]; then
    assert "--score-only output is integer 0-100" "pass"
else
    assert "--score-only output is integer 0-100" "fail" "got: '$score_trimmed'"
fi

# Test: score in expected range (55-80 for medium project)
if [[ "$score_trimmed" =~ ^[0-9]+$ ]] && [ "$score_trimmed" -ge 45 ] && [ "$score_trimmed" -le 85 ]; then
    assert "python score in expected range (45-85)" "pass"
else
    assert "python score in expected range (45-85)" "fail" "got: $score_trimmed"
fi

# Test: --markdown
md_output="$(run_scanner "$PYTHON" --markdown 2>&1)" && ec=0 || ec=$?
assert "--markdown exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if echo "$md_output" | head -5 | grep -q '^#'; then
    assert "--markdown output starts with #" "pass"
else
    assert "--markdown output starts with #" "fail"
fi

# Test: --ci
ci_output="$(run_scanner "$PYTHON" --ci 2>&1)" && ec=0 || ec=$?
assert "--ci exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if echo "$ci_output" | grep -q '::notice\|::warning\|::error'; then
    assert "--ci output contains GH Actions annotations" "pass"
else
    assert "--ci output contains GH Actions annotations" "fail"
fi

echo ""

# --------------------------------------------------------------------------
# Test Suite: empty-repo (expected score: 10-35)
# --------------------------------------------------------------------------

echo "${CYAN}--- empty-repo ---${RESET}"
EMPTY="${FIXTURES_DIR}/empty-repo"

# Test: default output runs without error
output="$(run_scanner "$EMPTY" 2>&1)" && ec=0 || ec=$?
assert "terminal mode exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

# Test: terminal output contains box-drawing characters
if echo "$output" | grep -q '║\|╔\|╚'; then
    assert "terminal output contains Vitals box characters" "pass"
else
    assert "terminal output contains Vitals box characters" "fail" "no box chars found"
fi

# Test: --json is valid JSON
json_output="$(run_scanner "$EMPTY" --json 2>&1)" && ec=0 || ec=$?
assert "--json exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if echo "$json_output" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
    assert "--json output is valid JSON" "pass"
else
    assert "--json output is valid JSON" "fail" "python3 json.load failed"
fi

# Test: --score-only
score_output="$(run_scanner "$EMPTY" --score-only 2>&1)" && ec=0 || ec=$?
score_trimmed="$(echo "$score_output" | tr -d '[:space:]')"

assert "--score-only exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if [[ "$score_trimmed" =~ ^[0-9]+$ ]] && [ "$score_trimmed" -ge 0 ] && [ "$score_trimmed" -le 100 ]; then
    assert "--score-only output is integer 0-100" "pass"
else
    assert "--score-only output is integer 0-100" "fail" "got: '$score_trimmed'"
fi

# Test: score in expected range (10-35 for bare-minimum project)
if [[ "$score_trimmed" =~ ^[0-9]+$ ]] && [ "$score_trimmed" -ge 0 ] && [ "$score_trimmed" -le 40 ]; then
    assert "empty-repo score in expected range (0-40)" "pass"
else
    assert "empty-repo score in expected range (0-40)" "fail" "got: $score_trimmed"
fi

# Test: --markdown
md_output="$(run_scanner "$EMPTY" --markdown 2>&1)" && ec=0 || ec=$?
assert "--markdown exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if echo "$md_output" | head -5 | grep -q '^#'; then
    assert "--markdown output starts with #" "pass"
else
    assert "--markdown output starts with #" "fail"
fi

# Test: --ci
ci_output="$(run_scanner "$EMPTY" --ci 2>&1)" && ec=0 || ec=$?
assert "--ci exits 0" "$([ $ec -eq 0 ] && echo pass || echo fail)" "exit code: $ec"

if echo "$ci_output" | grep -q '::notice\|::warning\|::error'; then
    assert "--ci output contains GH Actions annotations" "pass"
else
    assert "--ci output contains GH Actions annotations" "fail"
fi

echo ""

# --------------------------------------------------------------------------
# Cross-fixture validation
# --------------------------------------------------------------------------

echo "${CYAN}--- Cross-fixture validation ---${RESET}"

# Get all three scores
nextjs_score="$(run_scanner "$NEXTJS" --score-only 2>&1 | tr -d '[:space:]')"
python_score="$(run_scanner "$PYTHON" --score-only 2>&1 | tr -d '[:space:]')"
empty_score="$(run_scanner "$EMPTY" --score-only 2>&1 | tr -d '[:space:]')"

# Test: nextjs score > python score > empty score
if [[ "$nextjs_score" =~ ^[0-9]+$ ]] && [[ "$python_score" =~ ^[0-9]+$ ]] && [[ "$empty_score" =~ ^[0-9]+$ ]]; then
    if [ "$nextjs_score" -gt "$python_score" ]; then
        assert "nextjs ($nextjs_score) > python ($python_score)" "pass"
    else
        assert "nextjs ($nextjs_score) > python ($python_score)" "fail"
    fi

    if [ "$python_score" -gt "$empty_score" ]; then
        assert "python ($python_score) > empty ($empty_score)" "pass"
    else
        assert "python ($python_score) > empty ($empty_score)" "fail"
    fi
else
    skip_test "score ordering" "could not parse all scores"
fi

# Test: JSON output contains expected keys
nextjs_json="$(run_scanner "$NEXTJS" --json 2>&1)"
if echo "$nextjs_json" | python3 -c "
import sys, json
data = json.load(sys.stdin)
assert 'health' in data and 'score' in data['health'], 'missing health.score key'
" 2>/dev/null; then
    assert "JSON contains score/health_score key" "pass"
else
    assert "JSON contains score/health_score key" "fail"
fi

echo ""

# --------------------------------------------------------------------------
# Summary
# --------------------------------------------------------------------------

echo "${CYAN}========================================${RESET}"
echo "${CYAN}  Test Summary${RESET}"
echo "${CYAN}========================================${RESET}"
echo ""
printf "  Total:   %d\n" "$TOTAL"
printf "  ${GREEN}Passed:  %d${RESET}\n" "$PASS"
if [ "$FAIL" -gt 0 ]; then
    printf "  ${RED}Failed:  %d${RESET}\n" "$FAIL"
else
    printf "  Failed:  %d\n" "$FAIL"
fi
if [ "$SKIP" -gt 0 ]; then
    printf "  ${YELLOW}Skipped: %d${RESET}\n" "$SKIP"
fi
echo ""

if [ "$FAIL" -gt 0 ]; then
    echo "${RED}RESULT: FAILED${RESET}"
    exit 1
else
    echo "${GREEN}RESULT: ALL TESTS PASSED${RESET}"
    exit 0
fi
