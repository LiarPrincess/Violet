from typing import List, Union

from Sourcery.signature import SignatureInfo


class TypeInfo:
    '''
    Swift type implementing Python type.
    '''

    def __init__(self,
                 python_type_name: str,
                 swift_type_name: str,
                 swift_base_type_name: str,
                 is_error: bool):
        self.python_type_name = python_type_name
        self.swift_type_name = swift_type_name
        self.swift_base_type_name = swift_base_type_name
        self.is_error = is_error

        # To be filled later
        self.swift_static_doc_property: Union[str, None] = None
        self.sourcery_flags: List[str] = []

        # Properties, methods - to be filled later
        self.swift_fields: List[SwiftFieldInfo] = []
        self.swift_initializers: List[SwiftInitInfo] = []
        self.python_properties: List[PyPropertyInfo] = []
        self.python_methods: List[PyFunctionInfo] = []
        self.python_static_functions: List[PyFunctionInfo] = []
        self.python_class_functions: List[PyFunctionInfo] = []


class SwiftFieldInfo:
    '''
    Swift field.
    '''

    def __init__(self,
                 swift_field_name: str,
                 swift_field_type: str):
        self.swift_field_name = swift_field_name
        self.swift_field_type = swift_field_type


def _create_selector(signature: SignatureInfo) -> str:
    result = signature.name
    if signature.arguments:
        result += '('

        for arg in signature.arguments:
            label = arg.label or arg.name
            result += label + ':'

        result += ')'

    return result


class SwiftInitInfo:
    '''
    Swift init function.
    '''

    def __init__(self,
                 access_modifier: str,
                 selector_with_types: str):
        self.access_modifier = access_modifier
        self.is_open_public_internal = access_modifier in ('open', 'public', 'internal')

        signature = SignatureInfo(selector_with_types, '')
        assert signature.name == 'init'
        assert signature.return_type == ''

        self.arguments = signature.arguments
        # Function name with full arguments.
        # For example: foo(bar: Int)
        self.selector_with_types = signature.selector_with_types
        # Function name with arguments.
        # For example: foo(bar:)
        self.swift_selector = _create_selector(signature)


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
