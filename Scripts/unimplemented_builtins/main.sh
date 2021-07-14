echo 'Updating unimplemented builtins...'

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

python3 $script_dir/__main__.py > $script_dir/result.txt

echo "See: ${script_dir}/result.txt"
