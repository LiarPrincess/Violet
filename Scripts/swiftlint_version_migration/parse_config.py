import os.path
from typing import NamedTuple, List, Set


def get_config_path(config_filename: str) -> str:
    this_file_path = __file__
    this_dir_path = os.path.dirname(this_file_path)

    current_dir = os.path.abspath(this_dir_path)
    while True:
        if current_dir == '/':
            raise ValueError(f"Unable to find config file '{config_filename}'")

        child_nodes = os.listdir(current_dir)
        for node in child_nodes:
            if node == config_filename:
                config_path = os.path.join(current_dir, config_filename)
                return config_path

        current_dir = os.path.dirname(current_dir)


class ConfigFile(NamedTuple):
    rules: Set[str]
    commented: Set[str]


def parse_config(config_filename: str) -> ConfigFile:
    config_path = get_config_path(config_filename)

    lines: List[str]
    with open(config_path, 'r') as f:
        lines = f.readlines()

    result = ConfigFile(set(), set())
    is_in_only_rules_group = False

    for line in lines:
        is_empty = not len(line.strip())
        is_comment = line.startswith('#')
        if is_empty or is_comment:
            continue

        first_character = line[0]
        starts_with_space = first_character.isspace()
        is_group_definition = not starts_with_space

        # Look at us: pro parser writers
        if is_group_definition:
            # If this is not 'only_rules' then it is either unsupported group
            # or rule configuration. We do not care about those.
            is_in_only_rules_group = line.startswith('only_rules:')
            continue

        if not is_in_only_rules_group:
            continue

        line_strip = line.strip()
        is_rule = line_strip.startswith('- ')
        is_commented_rule = line_strip.startswith('# - ')

        is_rule_or_commented_rule = is_rule or is_commented_rule
        if not is_rule_or_commented_rule:
            continue

        # rule:           '- NAME # COMMENT'
        # commented rule: '# - NAME # COMMENT'
        split = line_strip.split('#')
        rule_name = split[0] if is_rule else split[1]

        rule_name = rule_name.strip()

        assert rule_name.startswith('-')
        rule_name = rule_name[1:].strip()

        is_duplicate = rule_name in result.rules or rule_name in result.commented
        if is_duplicate:
            print(f"Duplicate rule in '{config_filename}': {rule_name}")

        if is_rule:
            result.rules.add(rule_name)

        if is_commented_rule:
            result.commented.add(rule_name)

    return result
