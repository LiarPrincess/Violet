from printers.common import PrintingInfo


class NumericUnaryPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print(f"        return '{info.method_name}'")
        print()

    def print_assert(self, info: PrintingInfo):
        method_name = info.method_name
        returned_value = "'" + method_name + "'"

        print(f"assert o.{info.method_name}() == {returned_value}")

        if method_name == '__pos__':
            print(f"assert (+o) == {returned_value}")
        if method_name == '__neg__':
            print(f"assert (-o) == {returned_value}")
        if method_name == '__invert__':
            print(f"assert (~o) == {returned_value}")
        if method_name == '__abs__':
            print(f"assert abs(o) == {returned_value}")


class NumericTruncPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print(f"        return '{info.method_name}'")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"assert o.{info.method_name}() == '{info.method_name}'")


class NumericRoundPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, ndigits = None):")
        print(f"        return '{info.method_name}'")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"assert round(o) == '{info.method_name}'")


def get_superclass_instance(type_name: str) -> str:
    if type_name == 'int':
        return '1'
    if type_name == 'float':
        return '1.0'
    if type_name == 'complex':
        return '1.0j'

    if type_name == 'tuple':
        return "()"
    if type_name == 'list':
        return "[]"

    if type_name == 'str':
        return "''"

    # bytes/bytearray and set/frozenset pairs have to have separate branches!
    # This is important for subclass check in binary operator resolution.
    if type_name == 'bytes':
        return "b''"
    if type_name == 'bytearray':
        return "bytearray()"

    if type_name in 'set':
        return "set()"
    if type_name == 'frozenset':
        return 'frozenset()'

    raise ValueError(f"Unknown type with numeric operation '{type_name}'")


class NumericBinaryPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, o):")
        print(f"        return '{info.method_name}'")
        print()

    def print_assert(self, info: PrintingInfo):
        method_name = info.method_name
        other_value = get_superclass_instance(info.type_name)
        returned_value = "'" + method_name + "'"

        print(f"assert o.{info.method_name}({other_value}) == {returned_value}")

        operator = None
        if method_name in ('__add__', '__radd__', '__iadd__'):
            operator = '+'
        elif method_name in ('__and__', '__rand__', '__iand__'):
            operator = '&'
        elif method_name in ('__divmod__', '__rdivmod__', '__idivmod__'):
            pass
        elif method_name in ('__floordiv__', '__rfloordiv__', '__ifloordiv__'):
            pass
        elif method_name in ('__lshift__', '__rlshift__', '__ilshift__'):
            operator = '<<'
        elif method_name in ('__matmul__', '__rmatmul__', '__imatmul__'):
            pass
        elif method_name in ('__mod__', '__rmod__', '__imod__'):
            operator = '%'
        elif method_name in ('__mul__', '__rmul__', '__imul__'):
            operator = '*'
        elif method_name in ('__or__', '__ror__', '__ior__'):
            operator = '|'
        elif method_name in ('__rshift__', '__rrshift__', '__irshift__'):
            operator = '>>'
        elif method_name in ('__sub__', '__rsub__', '__isub__'):
            operator = '-'
        elif method_name in ('__truediv__', '__rtruediv__', '__itruediv__'):
            operator = '/'
        elif method_name in ('__xor__', '__rxor__', '__ixor__'):
            operator = '^'
        else:
            raise ValueError(f"Unknown numeric operator for '{method_name}'")

        if operator is None:
            return

        is_reflected = method_name != '__rshift__' and method_name.startswith('__r')
        is_in_place = method_name.startswith('__i')

        if is_reflected:
            print(f"assert {other_value} {operator} o == {returned_value}")
        elif is_in_place:
            print(f"o_copy = o")
            print(f"o_copy {operator}= {other_value}")
            print(f"assert o_copy == {returned_value}")
        else:
            print(f"assert o {operator} {other_value} == {returned_value}")


class NumericPowPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, o, mod=None):")
        print(f"        return '{info.method_name}'")
        print()

    def print_assert(self, info: PrintingInfo):
        method_name = info.method_name
        other_value = get_superclass_instance(info.type_name)
        returned_value = "'" + method_name + "'"

        print(f"assert o.{info.method_name}({other_value}) == {returned_value}")

        if method_name == '__pow__':
            print(f"assert pow(o, {other_value}) == {returned_value}")
        elif method_name == '__rpow__':
            print(f"assert pow({other_value}, o) == {returned_value}")
        elif method_name == '__ipow__':
            pass
        else:
            raise ValueError(f"Unknown pow method '{method_name}'")
