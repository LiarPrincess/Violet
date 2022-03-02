from typing import List


class ErrorHeader:
    def __init__(self) -> None:
        self.fields: List[ErrorHeaderField] = []


class ErrorHeaderField:
    def __init__(self, swift_name: str, swift_type: str):
        self.swift_name = swift_name
        self.swift_type = swift_type
