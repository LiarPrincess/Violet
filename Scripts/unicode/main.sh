script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

python3 "$script_dir/generate-database.py" "Sources/UnicodeData/Generated.swift"
python3 "$script_dir/generate-tests.py" "Tests/UnicodeDataTests/Generated/"
