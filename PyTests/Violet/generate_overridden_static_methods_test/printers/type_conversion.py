from printers.common import PrintingInfo, print_set_global_value, print_assert_global_value


class AsBoolPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return False")
        print()

    def print_assert(self, info: PrintingInfo):
        print("bool(o)")
        print_assert_global_value(info)


class AsIntPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return 42")
        print()

    def print_assert(self, info: PrintingInfo):
        print("int(o)")
        print_assert_global_value(info)


class AsFloatPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return 42.3")
        print()

    def print_assert(self, info: PrintingInfo):
        print("float(o)")
        print_assert_global_value(info)


class AsComplexPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return 42j")
        print()

    def print_assert(self, info: PrintingInfo):
        print("complex(o)")
        print_assert_global_value(info)


class AsIndexPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return 42")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"o.{info.method_name}()")
        print_assert_global_value(info)
