#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OUTPUT_PATH="./Documentation/Unimplemented builtins.txt"

echo "- $OUTPUT_PATH"
python3 "${SCRIPT_DIR}/__main__.py" > "${OUTPUT_PATH}"
