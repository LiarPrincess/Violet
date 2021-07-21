from typing import List

from parse_config import parse_config
from get_all_available_rules import Rule, get_all_available_rules

CONFIG_FILENAME = '.swiftlint.yml'

if __name__ == '__main__':
    config = parse_config(CONFIG_FILENAME)
    swiftlint_rules = get_all_available_rules()

    config_rules = config.rules
    config_commented = config.commented
    config_all = config_rules.union(config_commented)

    # ====================
    # === Non optional ===
    # ====================

    non_optional_rules_missing_from_config: List[Rule] = []
    disabled_non_optional_rules_with_configuration: List[Rule] = []
    for rule in swiftlint_rules.non_optional_rules:
        name = rule.name

        is_in_config = name in config_all
        if not is_in_config:
            non_optional_rules_missing_from_config.append(rule)

        # Maybe rule configuration will help us?
        is_disabled = name in config_commented
        has_configuration = rule.configuration != 'warning'
        if is_disabled and has_configuration:
            disabled_non_optional_rules_with_configuration.append(rule)

    if len(non_optional_rules_missing_from_config):
        print('Missing non optional rules:')
        for rule in non_optional_rules_missing_from_config:
            print(f'  - {rule.name}')

        print()

    if len(disabled_non_optional_rules_with_configuration):
        print('Disabled non optional rules (maybe we have to apply some configuration, see: https://realm.github.io/SwiftLint/rule-directory.html):')
        for rule in disabled_non_optional_rules_with_configuration:
            print(f'  - {rule.name}')

        print()

    # ================
    # === Optional ===
    # ================

    optional_rules_missing_from_config: List[Rule] = []
    for rule in swiftlint_rules.optional_rules:
        name = rule.name

        is_in_config = name in config_all
        if not is_in_config:
            optional_rules_missing_from_config.append(rule)

    if len(optional_rules_missing_from_config):
        print('Missing optional rules:')
        for rule in optional_rules_missing_from_config:
            print(f'  - {rule.name}')

        print()

    print('Finished')
