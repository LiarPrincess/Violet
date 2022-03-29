#!/bin/bash

# This file is used when you type 'make gen' in repository root.

get_abs_filename() {
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

OBJECTS=./Sources/Objects
OBJECTS_GENERATED=./Sources/Objects/Generated

TESTS=$(get_abs_filename ./Tests/ObjectsTests)
TESTS_GENERATED=$(get_abs_filename ./Tests/ObjectsTests/Generated)

# To be able to import from './Sources/Objects/Generated'
cd "$OBJECTS_GENERATED"

echo "- InvalidSelfArgumentMessageTests.swift - error message when downcasting of the 1st method argument failed"
python3 "$TESTS_GENERATED/InvalidSelfArgumentMessageTests.py" > "$TESTS_GENERATED/InvalidSelfArgumentMessageTests.swift"
