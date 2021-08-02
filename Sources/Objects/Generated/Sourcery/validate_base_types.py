from typing import Dict, List, NamedTuple

from Sourcery.entities import TypeInfo, SwiftFunctionInfo


def _get_initializers(initial_type: TypeInfo,
                      types_by_swift_name: Dict[str, TypeInfo]) -> List[SwiftFunctionInfo]:
    current_type_name = initial_type.swift_type_name
    while True:
        t = types_by_swift_name[current_type_name]

        if t.swift_initializers:
            return t.swift_initializers

        current_type_name = t.swift_base_type_name

        if current_type_name == 'PyObject':
            name = initial_type.swift_type_name
            raise ValueError(f"Unable to find 'init' for '{name}'")


class TypeWithInitializers(NamedTuple):
    typ: TypeInfo
    initializers: List[SwiftFunctionInfo]


def check_base_types(types: List[TypeInfo]):
    missing_init_with_type_argument: List[TypeWithInitializers] = []
    missing_new_method: List[TypeInfo] = []

    types_by_swift_name: Dict[str, TypeInfo] = {}
    for t in types:
        swift_name = t.swift_type_name
        types_by_swift_name[swift_name] = t

    for t in types:
        is_base_type = 'baseType' in t.sourcery_flags
        if not is_base_type:
            continue

        # 'object' and 'type' have special rules
        swift_name = t.swift_type_name
        if swift_name in ('PyType', 'PyObject'):
            continue

        # ============
        # === init ===
        # ============

        initializers = _get_initializers(t, types_by_swift_name)

        has_type_init_argument = False
        for init in initializers:
            if init.arguments:
                first_argument = init.arguments[0]
                if first_argument.typ == 'PyType':
                    has_type_init_argument = True

        if not has_type_init_argument:
            i = TypeWithInitializers(t, initializers)
            missing_init_with_type_argument.append(i)

        # ===============
        # === __new__ ===
        # ===============

        has_new_method = False
        for fn in t.python_static_functions:
            if fn.python_name == '__new__':
                has_new_method = True

        if not has_new_method:
            missing_new_method.append(t)

    if missing_init_with_type_argument:
        print('!!! Error !!!')
        print('Following base types are missing \'init\' method with type as 1st argument:')

        for typeInits in missing_init_with_type_argument:
            t = typeInits.typ
            print(f'- {t.swift_type_name}')
            for i in typeInits.initializers:
                print(f'  - {i.selector_with_types}')

        print('!!! Error !!!')

    if missing_new_method:
        print('!!! Error !!!')
        print('Following base types are missing \'__new__\' method:')

        for t in missing_new_method:
            print(f'- {t.swift_type_name}')
            for fn in t.python_static_functions:
                print(f'  - {fn.python_name}')

        print('!!! Error !!!')
