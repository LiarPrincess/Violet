from typing import List, NamedTuple

from Sourcery.entities import TypeInfo


def check_final_keyword(types: List[TypeInfo]):
    missing_final: List[TypeInfo] = []

    for t in types:
        name = t.swift_type_name
        is_final = t.swift_is_final

        subclasses: List[TypeInfo] = []
        for potential_subclass in types:
            potential_subclass_base_name = potential_subclass.swift_base_type_name
            is_subclass = potential_subclass_base_name == name
            if is_subclass:
                subclasses.append(potential_subclass)

        should_be_final = len(subclasses) == 0

        is_correctly_final = is_final == should_be_final
        if is_correctly_final:
            continue

        is_missing_final = not is_final and should_be_final
        if is_missing_final:
            missing_final.append(t)
            continue

        # Weird case (should not compile in Swift)
        assert False, f"'{t.swift_type_name}': {subclasses}"

    if not missing_final:
        return

    print('''\
!!! Error !!!
Following types are missing 'final' keyword:\
''')

    for t in missing_final:
        name = t.swift_type_name
        print(f'- {name}')

    print('!!! Error !!!')
