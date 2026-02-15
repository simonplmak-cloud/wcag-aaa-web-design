#!/usr/bin/env bash
#
# WCAG 2.2 AAA Accessibility Validator
#
# Runs automated accessibility audits against a running web application or HTML file.
# Uses pa11y (HTML_CodeSniffer) for WCAG 2.2 AAA compliance checking.
#
# Usage:
#   bash validate_accessibility.sh <url_or_filepath> [options]
#
# Options:
#   --standard <WCAG2A|WCAG2AA|WCAG2AAA>  Standard to test against (default: WCAG2AAA)
#   --output <report.json>                 Save JSON report to file
#   --pages <urls.txt>                     Test multiple pages (one URL per line)
#
# Examples:
#   bash validate_accessibility.sh http://localhost:3000
#   bash validate_accessibility.sh http://localhost:3000 --output report.json
#   bash validate_accessibility.sh --pages urls.txt --output report.json
#   bash validate_accessibility.sh ./build/index.html
#
# Prerequisites:
#   - Node.js >= 18
#   - pa11y (installed automatically via npx if missing)
#
# Exit codes:
#   0 = no issues found
#   1 = accessibility issues detected
#   2 = setup or configuration error
#
# Security:
#   - All variable expansions are properly quoted
#   - URL inputs are validated against an allowlist of schemes
#   - JSON report is assembled using Python for safe serialization

set -euo pipefail

# ============================================
# Utility Functions
# ============================================

# Validate that a URL uses an allowed scheme
validate_url() {
    local url="$1"
    if [[ "$url" =~ ^https?:// ]] || [[ "$url" =~ ^file:// ]] || [[ -f "$url" ]]; then
        return 0
    else
        echo "Error: Invalid URL or file path: $url" >&2
        echo "  Allowed schemes: http://, https://, file://, or a local file path." >&2
        return 1
    fi
}

# ============================================
# Argument Parsing
# ============================================

TARGET=""
STANDARD="WCAG2AAA"
OUTPUT=""
PAGES_FILE=""
TARGETS=()

# Parse first positional argument
if [[ "${1:-}" != --* ]] && [[ -n "${1:-}" ]]; then
    TARGET="$1"
    shift || true
fi

# Parse named arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --standard)
            STANDARD="${2:?Error: --standard requires a value}"
            shift 2
            ;;
        --output)
            OUTPUT="${2:?Error: --output requires a value}"
            shift 2
            ;;
        --pages)
            PAGES_FILE="${2:?Error: --pages requires a value}"
            shift 2
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 2
            ;;
    esac
done

# Validate standard
case "$STANDARD" in
    WCAG2A|WCAG2AA|WCAG2AAA) ;;
    *)
        echo "Error: Invalid standard '$STANDARD'. Use WCAG2A, WCAG2AA, or WCAG2AAA." >&2
        exit 2
        ;;
esac

# Build target list
if [[ -n "$PAGES_FILE" ]]; then
    if [[ ! -f "$PAGES_FILE" ]]; then
        echo "Error: Pages file not found: $PAGES_FILE" >&2
        exit 2
    fi
    while IFS= read -r line || [[ -n "$line" ]]; do
        line="$(echo "$line" | xargs)"  # trim whitespace
        [[ -z "$line" || "$line" == \#* ]] && continue
        TARGETS+=("$line")
    done < "$PAGES_FILE"
elif [[ -n "$TARGET" ]]; then
    TARGETS+=("$TARGET")
else
    echo "Usage: bash validate_accessibility.sh <url_or_filepath> [--standard WCAG2AAA] [--output report.json]"
    echo "       bash validate_accessibility.sh --pages <urls.txt> [--standard WCAG2AAA] [--output report.json]"
    echo ""
    echo "Standards: WCAG2A, WCAG2AA, WCAG2AAA (default: WCAG2AAA)"
    exit 2
fi

echo "=============================================="
echo "  WCAG 2.2 AAA Accessibility Validator"
echo "=============================================="
echo "  Standard: $STANDARD"
echo "  Pages:    ${#TARGETS[@]}"
echo "=============================================="
echo ""

# ============================================
# Ensure pa11y is available
# ============================================

PA11Y_CMD=""
if command -v pa11y &> /dev/null; then
    PA11Y_CMD="pa11y"
else
    echo "pa11y not found globally. Using npx..."
    PA11Y_CMD="npx --yes pa11y"
fi

# ============================================
# Run audits
# ============================================

OVERALL_EXIT=0
JSON_PARTS_DIR=""

# Create a temp directory for JSON parts if report output is requested
if [[ -n "$OUTPUT" ]]; then
    JSON_PARTS_DIR="$(mktemp -d)"
    trap 'rm -rf "$JSON_PARTS_DIR"' EXIT
fi

PAGE_INDEX=0
for url in "${TARGETS[@]}"; do
    # Validate URL
    if ! validate_url "$url"; then
        OVERALL_EXIT=2
        continue
    fi

    # Convert local file paths to file:// URLs
    if [[ -f "$url" ]]; then
        url="file://$(realpath "$url")"
    fi

    echo "----------------------------------------------"
    echo "  Auditing: $url"
    echo "----------------------------------------------"

    set +e
    RESULT=$($PA11Y_CMD --standard "$STANDARD" --reporter cli "$url" 2>&1)
    EXIT_CODE=$?
    set -e

    echo "$RESULT"
    echo ""

    # pa11y exit codes:
    #   0 = no issues
    #   1 = pa11y error (e.g., could not reach URL)
    #   2 = accessibility issues found
    if [[ $EXIT_CODE -eq 2 ]]; then
        OVERALL_EXIT=1
        echo "  Status: ISSUES FOUND"
    elif [[ $EXIT_CODE -eq 0 ]]; then
        echo "  Status: PASS"
    else
        echo "  Status: ERROR (exit code $EXIT_CODE)"
        if [[ $OVERALL_EXIT -eq 0 ]]; then
            OVERALL_EXIT=2
        fi
    fi

    # Collect JSON for report — save each result to a temp file
    if [[ -n "$JSON_PARTS_DIR" ]]; then
        set +e
        $PA11Y_CMD --standard "$STANDARD" --reporter json "$url" > "$JSON_PARTS_DIR/part_${PAGE_INDEX}.json" 2>/dev/null
        set -e
    fi

    PAGE_INDEX=$((PAGE_INDEX + 1))
    echo ""
done

# ============================================
# Save JSON report (using Python for safe serialization)
# ============================================

if [[ -n "$OUTPUT" ]] && [[ -n "$JSON_PARTS_DIR" ]]; then
    echo "Generating JSON report: $OUTPUT"
    python3 -c "
import json, glob, os, sys

parts_dir = sys.argv[1]
output_path = sys.argv[2]

results = []
for path in sorted(glob.glob(os.path.join(parts_dir, 'part_*.json'))):
    try:
        with open(path, 'r') as f:
            data = json.load(f)
        results.append(data)
    except (json.JSONDecodeError, OSError):
        results.append({'error': 'Failed to parse result', 'file': os.path.basename(path)})

with open(output_path, 'w') as f:
    json.dump(results, f, indent=2)

print(f'Report saved to: {output_path}')
" "$JSON_PARTS_DIR" "$OUTPUT"
    echo ""
fi

# ============================================
# Summary
# ============================================

echo "=============================================="
TOTAL=${#TARGETS[@]}
if [[ $OVERALL_EXIT -eq 0 ]]; then
    echo "  RESULT: PASS - No accessibility issues found across $TOTAL page(s)."
elif [[ $OVERALL_EXIT -eq 1 ]]; then
    echo "  RESULT: FAIL - Accessibility issues detected."
    echo "  Review the issues above and fix them."
    echo "  NOTE: Automated tools catch approximately 30-40% of issues."
    echo "  A manual review is still required for full AAA compliance."
else
    echo "  RESULT: ERROR - One or more audits could not complete."
    echo "  Check that the target URL(s) are accessible."
fi
echo "=============================================="

exit $OVERALL_EXIT
