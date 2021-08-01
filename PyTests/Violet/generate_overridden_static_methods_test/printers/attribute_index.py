from printers.common import PrintingInfo, print_set_global_value, print_assert_global_value


class GetAttributePrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, name):")
        print(f"        global attribute_name")
        print(f"        if name == attribute_name:")
        print_set_global_value(info, additional_indent='    ')
        print(f"            return None")
        print(f"        return super().{info.method_name}(name)")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"getattr(o, attribute_name)")
        print_assert_global_value(info)


class SetAttributePrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, name, value):")
        print(f"        global attribute_name")
        print(f"        if name == attribute_name:")
        print_set_global_value(info, additional_indent='    ')
        print(f"            return None")
        print(f"        return super().{info.method_name}(name, value)")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"setattr(o, attribute_name, 42)")
        print_assert_global_value(info)


class DelAttributePrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, name):")
        print(f"        global attribute_name")
        print(f"        if name == attribute_name:")
        print_set_global_value(info, additional_indent='    ')
        print(f"            return None")
        print(f"        return super().{info.method_name}(name)")
        print()

    def print_assert(self, info: PrintingInfo):
        print(f"delattr(o, attribute_name)")
        print_assert_global_value(info)


class GetItemPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, index):")
        print(f"        global index_value")
        print(f"        if index == index_value:")
        print_set_global_value(info, additional_indent='    ')
        print(f"            return None")
        print(f"        return super().{info.method_name}(index)")
        print()

    def print_assert(self, info: PrintingInfo):
        print("o[index_value]")
        print_assert_global_value(info)


class SetItemPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, index, value):")
        print(f"        global index_value")
        print(f"        if index == index_value:")
        print_set_global_value(info, additional_indent='    ')
        print(f"            return None")
        print(f"        return super().{info.method_name}(index, value)")
        print()

    def print_assert(self, info: PrintingInfo):
        print("o[index_value] = 43")
        print_assert_global_value(info)


class DelItemPrinter:
    def print_method(self, info: PrintingInfo):
        print(f"    def {info.method_name}(self, index):")
        print(f"        global index_value")
        print(f"        if index == index_value:")
        print_set_global_value(info, additional_indent='    ')
        print(f"            return None")
        print(f"        return super().{info.method_name}(index)")
        print()

    def print_assert(self, info: PrintingInfo):
        print("del o[index_value]")
        print_assert_global_value(info)
