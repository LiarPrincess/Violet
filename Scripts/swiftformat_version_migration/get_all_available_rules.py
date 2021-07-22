import subprocess
from typing import List, NamedTuple

SWIFTFORMAT_RULES_OUTPUT_HAS_CHANGED = "'swiftformat --rules' command output has changed!"


class Rule(NamedTuple):
    name: str


def get_all_available_rules() -> List[Rule]:
    process = subprocess.run(["swiftformat", "--rules"], capture_output=True, universal_newlines=True)
    stdout = process.stdout

    lines = stdout.splitlines()
    assert len(lines)

    result: List[Rule] = []
    for line in lines:
        name = line.strip()
        try:
            # Sometimes we have:
            # RULE_NAME (disabled)
            name_end = name.index(' ')
            name = name[:name_end]
        except:
            pass

        rule = Rule(name)
        result.append(rule)

    return result
