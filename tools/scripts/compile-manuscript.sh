#!/bin/bash

# Compile a book manuscript from individual chapter files
# Usage: ./compile-manuscript.sh <book-directory> [output-file]

BOOK_DIR=$1
OUTPUT_FILE=${2:-"compiled-manuscript.pdf"}
BOOK_TITLE=$3

if [ -z "$BOOK_DIR" ]; then
    echo "Usage: ./compile-manuscript.sh <book-directory> [output-file]"
    echo "Example: ./compile-manuscript.sh books/01-one-cell"
    exit 1
fi

# Concatenate all markdown files in order
pandoc \
    "$BOOK_DIR"/manuscript/*.md \
    --from markdown \
    --to epub \
    --output "$BOOK_DIR/$OUTPUT_FILE" \
    --metadata title="$BOOK_TITLE" \
    --metadata author="A. O. Smith" \
    --toc \
    --toc-depth=1

echo "Compiled to $BOOK_DIR/$OUTPUT_FILE"