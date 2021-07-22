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
    options: Set[str]
    commented_options: Set[str]
    enabled_rules: Set[str]
    disabled_rules: Set[str]


def get_rule_name(prefix: str, line: str) -> str:
    # Strip leading '--enable'
    assert line.startswith(prefix)
    enable_str_len = len(prefix)
    name = line[enable_str_len:].lstrip()

    # Remove comment
    try:
        name_end = name.index('#')
        name = name[:name_end].rstrip()
    except:
        pass

    # is_duplicate = name in result.enabled_rules or name in result.disabled_rules
    # if is_duplicate:
    #     print('Duplicate rule: ' + name)

    return name


def get_option_name(prefix: str, line: str) -> str:
    # Strip leading '--'
    assert line.startswith(prefix)
    enable_str_len = len(prefix)
    name = line[enable_str_len:].lstrip()

    # Strip comment
    try:
        name_end = name.index('#')
        name = name[:name_end]
    except:
        pass

    # Strip arguments
    try:
        name_end = name.index(' ')
        name = name[:name_end]
    except:
        pass

    # is_duplicate = name in result.options
    # if is_duplicate:
    #     print('Duplicate option: ' + name)

    return name


def parse_config(config_filename: str) -> ConfigFile:
    config_path = get_config_path(config_filename)

    lines: List[str]
    with open(config_path, 'r') as f:
        lines = f.readlines()

    result = ConfigFile(set(), set(), set(), set())

    for line in lines:
        line = line.strip()

        is_empty = not len(line)
        if is_empty:
            continue

        is_exclude = line.startswith('--exclude ')
        if is_exclude:
            # We don't care about those
            continue

        # =============
        # === Rules ===
        # =============

        is_enable_rule = line.startswith('--enable ')
        if is_enable_rule:
            name = get_rule_name('--enable', line)
            result.enabled_rules.add(name)
            continue

        is_disable_rule = line.startswith('--disable ')
        if is_disable_rule:
            name = get_rule_name('--disable', line)
            result.enabled_rules.add(name)
            continue

        # ==============
        # === Option ===
        # ==============

        is_option = line.startswith('--')
        if is_option:
            name = get_option_name('--', line)
            result.options.add(name)
            continue

        is_commented_option = line.startswith('# --')
        if is_commented_option:
            name = get_option_name('# --', line)
            result.commented_options.add(name)
            continue

        assert line.startswith('#'), f"Invalid line: '{line}'"

    return result
