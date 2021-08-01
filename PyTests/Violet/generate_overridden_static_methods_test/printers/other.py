from printers.common import PrintingInfo, print_set_global_value, print_assert_global_value


class CallPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, args=None, kwargs=None):")
        print(f"        return '{info.method_name}'")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"assert o() == '{info.method_name}'")


class InstanceCheckPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, object):")
        print_set_global_value(info)
        print(f"        return False")
        print()

    def print_assert(self, info: PrintingInfo):
        print("isinstance(42, o)")
        print_assert_global_value(info)


class SubclassCheckPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, subclass):")
        print_set_global_value(info)
        print(f"        return False")
        print()

    def print_assert(self, info: PrintingInfo):
        print("issubclass(int, o)")
        print_assert_global_value(info)


class IsAbstractMethodPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self):")
        print_set_global_value(info)
        print(f"        return False")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"o.{info.method_name}()")
        print_assert_global_value(info)
