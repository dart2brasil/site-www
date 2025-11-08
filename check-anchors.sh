#!/bin/bash

# Script to validate anchor links in translated markdown files
# Checks that all {:#anchor-id} anchors exist where they're referenced

echo "Checking for missing anchor IDs in resources directory..."
echo ""

MISSING_ANCHORS=0

# Find all markdown files in resources
find src/content/resources -name "*.md" | while read -r file; do
    # Extract all anchor references from links like [text](#anchor-id)
    # Also check internal links like (#anchor-id) or [text](file#anchor-id)
    grep -oP '(?<=\(#)[a-zA-Z0-9_-]+(?=\))' "$file" 2>/dev/null | sort -u | while read -r anchor; do
        # Check if this anchor exists in the same file with pattern {:#anchor-id}
        if ! grep -q "{:#${anchor}}" "$file"; then
            echo "Missing anchor in $file: {:#${anchor}}"
            MISSING_ANCHORS=$((MISSING_ANCHORS + 1))
        fi
    done

    # Also check for links to other files in resources with anchors
    grep -oP '(?<=\]\()[^)]*#[^)]+(?=\))' "$file" 2>/dev/null | while read -r link; do
        # Extract file path and anchor
        link_file=$(echo "$link" | cut -d'#' -f1)
        anchor=$(echo "$link" | cut -d'#' -f2)

        # Skip external links, absolute paths, and links starting with /
        if [[ "$link_file" =~ ^http ]] || [[ "$link_file" =~ ^/ ]]; then
            continue
        fi

        # If link_file is empty, it's a same-file reference (already checked above)
        if [[ -z "$link_file" ]]; then
            continue
        fi

        # Resolve relative path
        target_file=$(dirname "$file")/"$link_file"

        if [[ -f "$target_file" ]]; then
            if ! grep -q "{:#${anchor}}" "$target_file"; then
                echo "Missing anchor in $target_file: {:#${anchor}} (referenced from $file)"
                MISSING_ANCHORS=$((MISSING_ANCHORS + 1))
            fi
        fi
    done
done

echo ""
if [ $MISSING_ANCHORS -eq 0 ]; then
    echo "✓ All anchor IDs are properly defined!"
    exit 0
else
    echo "✗ Found $MISSING_ANCHORS missing anchor ID(s)"
    exit 1
fi
