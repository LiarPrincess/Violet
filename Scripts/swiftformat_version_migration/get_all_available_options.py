import subprocess
from typing import List, NamedTuple

SWIFTFORMAT_OPTIONS_OUTPUT_HAS_CHANGED = "'swiftformat --options' command output has changed!"


class Option(NamedTuple):
    name: str
    name_with_hyphens: str
    description: str


def get_all_available_options() -> List[Option]:
    process = subprocess.run(["swiftformat", "--options"], capture_output=True, universal_newlines=True)
    stdout = process.stdout

    lines = stdout.splitlines()
    assert len(lines)

    result: List[Option] = []
    for line in lines:
        try:
            name_end = line.index(' ')
        except:
            assert False, SWIFTFORMAT_OPTIONS_OUTPUT_HAS_CHANGED

        name_with_hyphens = line[:name_end]
        assert name_with_hyphens.startswith('--'), SWIFTFORMAT_OPTIONS_OUTPUT_HAS_CHANGED
        name = name_with_hyphens[2:]

        description = line[name_end:].strip()
        option = Option(name, name_with_hyphens, description)
        result.append(option)

    return result
