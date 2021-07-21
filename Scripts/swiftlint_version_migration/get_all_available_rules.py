import subprocess
from typing import List, NamedTuple

SWIFTLINT_RULES_OUTPUT_HAS_CHANGED = "'swiftlint rules' command output has changed!"


class Rule(NamedTuple):
    name: str
    kind: str
    configuration: str


class SwiftLintRules(NamedTuple):
    non_optional_rules: List[Rule]
    optional_rules: List[Rule]
    analyzer_rules: List[Rule]


def get_all_available_rules() -> SwiftLintRules:
    process = subprocess.run(["swiftlint", "rules"], capture_output=True, universal_newlines=True)
    stdout = process.stdout

    lines = stdout.splitlines()
    assert len(lines)

    result = SwiftLintRules([], [], [])
    for line in lines:
        is_header_or_footer = line.startswith('+-----------') or line.startswith('| identifier')
        if is_header_or_footer:
            continue

        split = line.split('|')
        assert len(split) == 9, SWIFTLINT_RULES_OUTPUT_HAS_CHANGED

        name = split[1].strip()
        is_opt_in = split[2].strip()
        is_correctable = split[3].strip()
        is_enabled = split[4].strip()
        kind = split[5].strip()
        is_analyzer = split[6].strip()
        configuration = split[7].strip()

        is_opt_in = is_opt_in == 'yes'
        is_correctable = is_correctable == 'yes'
        is_enabled = is_enabled == 'yes'
        is_analyzer = is_analyzer == 'yes'

        rule = Rule(name, kind, configuration)

        if is_analyzer:
            result.analyzer_rules.append(rule)
        elif is_opt_in:
            result.optional_rules.append(rule)
        else:
            result.non_optional_rules.append(rule)

    return result
