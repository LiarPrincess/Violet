script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

python3 "$script_dir/__main__.py" "Sources/UnicodeData/Generated.swift"
