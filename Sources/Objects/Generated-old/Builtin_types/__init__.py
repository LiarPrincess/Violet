from Sourcery import TypeInfo

from Builtin_types.property import (get_property_name,
                                    get_property_name_escaped,
                                    print_property,
                                    print_set_property)
from Builtin_types.cast_self import (get_castSelf_function_name,
                                     get_castSelfOptional_function_name,
                                     print_castSelf_functions)
from Builtin_types.fill import (print_fill_helpers,
                                get_fill_function_name,
                                print_fill_function)


def print_type_mark(t: TypeInfo):
    print(f'  // MARK: - {t.swift_type_name.replace("Py", "")}')
    print()
