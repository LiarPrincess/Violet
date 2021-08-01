from printers.common import PrintingInfo, print_set_global_value, print_assert_global_value


class IterPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return super().{info.method_name}()")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"iter(o)")
        print_assert_global_value(info)


class NextPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return 'infinite loop'")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"next(o)")
        print_assert_global_value(info)


class GetLengthPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return 1")
        print()

    def print_assert(self, info: PrintingInfo):
        print("len(o)")
        print_assert_global_value(info)


class ContainsPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, element):")
        print_set_global_value(info)
        print(f"        return False")
        print()

    def print_assert(self, info: PrintingInfo):
        print("42 in o")
        print_assert_global_value(info)


class ReversedPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return super().{info.method_name}()")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"o.{info.method_name}()")
        print_assert_global_value(info)


class KeysPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return super().{info.method_name}()")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"o.{info.method_name}()")
        print_assert_global_value(info)
