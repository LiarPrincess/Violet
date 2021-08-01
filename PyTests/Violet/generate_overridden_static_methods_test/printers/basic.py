from printers.common import PrintingInfo, print_set_global_value, print_assert_global_value


class StringConversionPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print(f"        return '{info.method_name}'")
        print()

    def print_assert(self, info: PrintingInfo):
        method_name = info.method_name

        if method_name == '__repr__':
            print("assert repr(o) == '__repr__'")
        elif method_name == '__str__':
            print("assert str(o) == '__str__'")
        else:
            raise ValueError(f"'{method_name}' is not an 'StringConversion'")


class HashPrinter:
    def print_method(self, info: PrintingInfo):
        print("    def __hash__(self):")
        print("        global hash_value")
        print("        return hash_value")
        print()

    def print_assert(self, info: PrintingInfo):
        print("assert hash(o) == hash_value")


class DirPrinter:
    def print_method(self, info: PrintingInfo):
        print("    def __dir__(self):")
        print("        global dir_value")
        print("        return dir_value")
        print()

    def print_assert(self, info: PrintingInfo):
        print("assert dir(o) == dir_value")


class ComparisonPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, o):")
        print(f"        return o == '{info.method_name}'")
        print()

    def print_assert(self, info: PrintingInfo):
        method_name = info.method_name
        if method_name == '__eq__':
            print("assert o == '__eq__'")
        elif method_name == '__ne__':
            print("assert o != '__ne__'")
        elif method_name == '__lt__':
            print("assert o < '__lt__'")
        elif method_name == '__le__':
            print("assert o <= '__le__'")
        elif method_name == '__gt__':
            print("assert o > '__gt__'")
        elif method_name == '__ge__':
            print("assert o >= '__ge__'")
        else:
            raise ValueError(f"'{method_name}' is not an 'Comparison'")


class DelPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return super().{info.method_name}()")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"del o")
        print_assert_global_value(info)
