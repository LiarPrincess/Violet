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
        self.swift_fields: List[SwiftFieldInMemoryInfo] = []
        self.swift_initializers: List[SwiftInitializerInfo] = []
        self.python_properties: List[PyPropertyInfo] = []
        self.python_methods: List[PyFunctionInfo] = []
        self.python_static_functions: List[PyFunctionInfo] = []
        self.python_class_functions: List[PyFunctionInfo] = []


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


class SwiftFieldInMemoryInfo:
    def __init__(self, swift_name: str, swift_type: str):
        self.swift_name = swift_name
        self.swift_type = swift_type


class SwiftInitializerInfo:
    def __init__(self, selector_with_types: str):
        signature = SignatureInfo(selector_with_types, 'Void')
        self.name = signature.name
        self.arguments = signature.arguments


class PyPropertyInfo:
    '''
    Python property backed by Swift property.

    In Swift:
    ```Swift
    // sourcery: pyproperty = argv, setter = setArgv
    internal var argv: PyObject { ... }
    ```
    '''

    def __init__(self,
                 python_name: str,
                 swift_getter_fn: str,
                 swift_setter_fn: str,
                 swift_type: str,
                 swift_static_doc_property: str):
        self.python_name = python_name
        self.swift_getter_fn = swift_getter_fn
        self.swift_setter_fn = swift_setter_fn or None
        self.swift_type = swift_type
        self.swift_static_doc_property = swift_static_doc_property or None


class PyFunctionInfo:
    '''
    Python function/method.

    In Swift:
    ```Swift
    // sourcery: pymethod = warnoptions
    internal func warnOptions() -> PyObject { ... }
    ```
    '''

    def __init__(self,
                 python_name: str,
                 selector_with_types: str,
                 swift_return_type: str,
                 swift_static_doc_property: str):
        self.python_name = python_name
        self.swift_static_doc_property = swift_static_doc_property or None

        signature = SignatureInfo(selector_with_types, swift_return_type)
        self.swift_name = signature.name
        self.swift_return_type = signature.return_type
        self.swift_arguments = signature.arguments
        # Function name with full arguments.
        # For example: foo(bar: Int)
        self.swift_selector_with_types = signature.selector_with_types
        # Function name with arguments.
        # For example: foo(bar:)
        self.swift_selector = _create_selector(signature)

def _create_selector(signature: SignatureInfo) -> str:
    result = signature.name
    if signature.arguments:
        result += '('

        for arg in signature.arguments:
            label = arg.label or arg.name
            result += label + ':'

        result += ')'

    return result