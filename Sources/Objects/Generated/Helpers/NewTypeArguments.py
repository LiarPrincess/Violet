from typing import List, Optional
from Sourcery import TypeInfo
from Helpers.PyTypeDefinition_helpers import get_static_methods_property_name

class NewTypeArguments:
    'Arguments to provide when calling py.memory.newType(THIS)'

    def __init__(self, t: TypeInfo) -> None:
        self.name: str = t.python_type_name
        self.qualname: str = t.python_type_name

        self.flags: List[str] = []
        for flag in t.sourcery_flags:
            self.flags.append('.' + flag + 'Flag')

        self.mro_without_self: List[TypeInfo] = get_mro_without_self(t)

        # 'base' is always 1st in 'mro_without_self'.
        # Edge case: 'object' type has empty 'mro_without_self'.
        self.base: Optional[TypeInfo] = None
        if len(self.mro_without_self):
            self.base = self.mro_without_self[0]

        swift_name = t.swift_type_name
        self.size_without_tail: str = f'{swift_name}.layout.size'

        container_type = 'Py.ErrorTypes' if t.is_error else 'Py.Types'
        static_methods_property = get_static_methods_property_name(swift_name)
        self.static_methods_property: str = f'{container_type}.{static_methods_property}'

        self.debugFn: str = f'{swift_name}.createDebugInfo(ptr:)'
        self.deinitialize: str = f'{swift_name}.deinitialize(_:ptr:)'

def get_mro_without_self(type: TypeInfo) -> List[TypeInfo]:
    result: List[TypeInfo] = []

    base_info = type.base_type_info
    while base_info is not None:
        result.append(base_info)
        base_info = base_info.base_type_info

    return result
