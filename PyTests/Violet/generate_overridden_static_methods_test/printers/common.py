from typing import NamedTuple


class PrintingInfo(NamedTuple):
    type_name: str
    test_type_name: str
    method_name: str
    method_kind: str


def print_set_global_value(info: PrintingInfo, *, additional_indent: str = ''):
    print(f"        {additional_indent}global set_global_value")
    print(f"        {additional_indent}set_global_value('{info.test_type_name}', '{info.method_name}')")


def print_assert_global_value(info: PrintingInfo):
    print(f"assert is_global_value_set('{info.test_type_name}', '{info.method_name}')")
