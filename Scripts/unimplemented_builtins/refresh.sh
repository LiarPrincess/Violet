#!/bin/bash

echo "=== Unimplemented builtins ==="
echo "- Updating list of unimplemented builtins"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OUTPUT_PATH="./Documentation/Unimplemented builtins.txt"

python3 "${SCRIPT_DIR}/__main__.py" > "${OUTPUT_PATH}"

echo "See: ${OUTPUT_PATH}"
