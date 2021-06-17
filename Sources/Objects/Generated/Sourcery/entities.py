from typing import List, Union

from Sourcery.signature import SignatureInfo


class TypeInfo:
    '''
    Swift type implementing Python type.
    '''

    def __init__(self,
                 python_type: str,
                 swift_type: str,
                 swift_base_type: str,
                 is_error: bool):
        self.python_type = python_type
        self.swift_type = swift_type
        self.swift_base_type = swift_base_type
        self.is_error = is_error

        # To be filled later
        self.swift_static_doc_property: Union[str, None] = None
        self.sourcery_flags: List[str] = []

        # Properties, methods - to be filled later
        self.fields: List[FieldInfo] = []
        self.properties: List[PyPropertyInfo] = []
        self.methods: List[PyFunctionInfo] = []
        self.static_functions: List[PyFunctionInfo] = []
        self.class_functions: List[PyFunctionInfo] = []


class FieldInfo:
    '''
    Swift field.
    '''

    def __init__(self,
                 swift_field_name: str,
                 swift_field_type: str):
        self.swift_field_name = swift_field_name
        self.swift_field_type = swift_field_type


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
        selector = signature.name
        if signature.arguments:
            selector += '('

            for arg in signature.arguments:
                label = arg.label or arg.name
                selector += label + ':'

            selector += ')'

        self.swift_selector = selector
