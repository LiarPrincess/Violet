from typing import List, Union

from Sourcery.signature import SignatureInfo


class TypeInfo:
    '''
    Swift type implementing Python type.
    '''

    def __init__(self,
                 swift_type_name: str,
                 python_type_name: str,
                 python_base_type_name: str,
                 is_error: bool):
        self.swift_type_name = swift_type_name
        self.python_type_name = python_type_name
        self.python_base_type_name = python_base_type_name
        self.is_error = is_error

        # To be filled later
        self.swift_static_doc_property: Union[str, None] = None
        self.sourcery_flags: SourceryFlags = SourceryFlags()

        # Properties, methods - to be filled later
        self.swift_properties: List[SwiftPropertyInfo] = []
        self.swift_initializers: List[SwiftInitializerInfo] = []
        # self.swift_methods: List[SwiftFunctionInfo] = []
        # self.swift_initializers: List[SwiftFunctionInfo] = []
        # self.python_properties: List[PyPropertyInfo] = []
        # self.python_methods: List[PyFunctionInfo] = []
        # self.python_static_functions: List[PyFunctionInfo] = []
        # self.python_class_functions: List[PyFunctionInfo] = []


class SourceryFlags:
    def __init__(self):
        self.values = []

    @property
    def is_base_type(self) -> bool:
        return 'isBaseType' in self.values

    def __iter__(self):
        return iter(self.values)

    def append(self, flag: str):
        self.values.append(flag)

    def sort(self):
        self.values.sort()


class SwiftPropertyInfo:
    def __init__(self, swift_name: str, swift_type: str):
        self.swift_name = swift_name
        self.swift_type = swift_type

class SwiftInitializerInfo:
    def __init__(self, selector_with_types: str):
        signature = SignatureInfo(selector_with_types, 'Void')
        self.name = signature.name
        self.arguments = signature.arguments
