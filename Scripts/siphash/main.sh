script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

clang $script_dir/main.c -o $script_dir/main.out
$script_dir/main.out
