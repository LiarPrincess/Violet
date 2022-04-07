SOURCES_DIR=./Sources
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for f in $SOURCES_DIR/*/; do
  echo "$f"
  swift run Ariel --min-access-level=public --output-path "${SCRIPT_DIR}" "${f}"
done
