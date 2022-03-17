from typing import List

from Sourcery.signature import SignatureInfo


class ExceptionByHand:
    '''
    Python error implemented manually in Swift.
    '''

    def __init__(self, swift_type_name: str, python_type_name: str):
        self.swift_type_name = swift_type_name
        self.python_type_name = python_type_name
        self.swift_initializers: List[SwiftInitializerInfo] = []


class SwiftInitializerInfo:
    def __init__(self, selector_with_types: str):
        signature = SignatureInfo(selector_with_types, 'Void')
        self.name = signature.name
        self.arguments = signature.arguments
