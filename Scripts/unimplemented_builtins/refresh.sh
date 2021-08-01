#!/bin/bash

echo "=== Unimplemented builtins ==="
echo "- Updating list of unimplemented builtins"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

python3 "$SCRIPT_DIR/__main__.py" > "$SCRIPT_DIR/result.txt"

echo "See: ${SCRIPT_DIR}/result.txt"
