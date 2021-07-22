from typing import List

from parse_config import parse_config
from get_all_available_rules import Rule, get_all_available_rules
from get_all_available_options import Option, get_all_available_options

CONFIG_FILENAME = '.swiftformat'

if __name__ == '__main__':
    rules = get_all_available_rules()
    options = get_all_available_options()
    config = parse_config(CONFIG_FILENAME)

    # ===============
    # === Options ===
    # ===============

    config_all_options = config.options.union(config.commented_options)

    options_missing_from_config: List[Option] = []
    for option in options:
        name = option.name

        is_in_config = name in config_all_options
        if not is_in_config:
            options_missing_from_config.append(option)

    if len(options_missing_from_config):
        print('Missing options:')
        for option in options_missing_from_config:
            print(f'{option.name_with_hyphens} - {option.description}')

        print()

    # =============
    # === Rules ===
    # =============

    config_all_rules = config.enabled_rules.union(config.disabled_rules)

    rules_missing_from_config: List[Rule] = []
    for rule in rules:
        name = rule.name

        is_in_config = name in config_all_rules
        if not is_in_config:
            rules_missing_from_config.append(rule)

    if len(rules_missing_from_config):
        print('Missing rules:')
        for rule in rules_missing_from_config:
            print(f'{rule.name}')

        print()
