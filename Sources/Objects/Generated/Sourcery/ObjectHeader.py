from typing import List


class ObjectHeader:
    def __init__(self) -> None:
        self.fields: List[ObjectHeaderField] = []


class ObjectHeaderField:
    def __init__(self, swift_name: str, swift_type: str):
        self.swift_name = swift_name
        self.swift_type = swift_type
