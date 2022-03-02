from typing import Dict, List, Optional
from Sourcery import TypeInfo
from Helpers.PyTypeDefinition_helpers import get_layout_property_name, get_static_methods_property_name

class NewTypeArguments:
    'Arguments to PyMemory.newType'
    def __init__(self, t: TypeInfo, all_types: List[TypeInfo]) -> None:

        self.name: str = t.python_type_name
        self.qualname: str = t.python_type_name

        self.flags: List[str] = []
        for flag in t.sourcery_flags:
            self.flags.append('.' + flag + 'Flag')

        self.mro_without_self: List[TypeInfo] = get_mro_without_self(t, all_types)

        # 'base' is always 1st in 'mro_without_self'.
        # Edge case: object type has empty 'mro_without_self'.
        self.base: Optional[TypeInfo] = None
        if len(self.mro_without_self):
            self.base = self.mro_without_self[0]

        swift_name = t.swift_type_name

        layout_property = get_layout_property_name(swift_name)
        self.layout_property: str = f'Py.Types.{layout_property}'

        static_methods_property = get_static_methods_property_name(swift_name)
        self.static_methods_property: str = f'Py.Types.{static_methods_property}'

        self.debugFn: str = f'{swift_name}.createDebugString(ptr:)'
        self.deinitialize: str = f'{swift_name}.deinitialize(ptr:)'

def get_mro_without_self(type: TypeInfo, all_types: List[TypeInfo]) -> List[TypeInfo]:
    # Object -> empty
    python_name = type.python_type_name
    if python_name == 'object':
        return []

    python_name_to_type: Dict[str, TypeInfo] = {}
    for t in all_types:
        python_name_to_type[t.python_type_name] = t

    object_type = python_name_to_type['object']

    # No base -> only object
    python_base_name = type.python_base_type_name
    if not python_base_name:
        return [object_type]

    result = []
    while python_base_name:
        t = python_name_to_type[python_base_name]
        result.append(t)
        python_base_name = t.python_base_type_name

    has_object = result[-1] == object_type
    if not has_object:
        result.append(object_type)

    return result
