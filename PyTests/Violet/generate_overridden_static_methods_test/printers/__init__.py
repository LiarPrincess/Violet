from printers.common import (PrintingInfo)

from printers.basic import (StringConversionPrinter,
                            HashPrinter,
                            DirPrinter,
                            ComparisonPrinter,
                            DelPrinter)
from printers.attribute_index import (GetAttributePrinter,
                                      SetAttributePrinter,
                                      DelAttributePrinter,
                                      GetItemPrinter,
                                      SetItemPrinter,
                                      DelItemPrinter)
from printers.type_conversion import (AsBoolPrinter,
                                      AsIntPrinter,
                                      AsFloatPrinter,
                                      AsComplexPrinter,
                                      AsIndexPrinter)
from printers.collections import (IterPrinter,
                                  NextPrinter,
                                  GetLengthPrinter,
                                  ContainsPrinter,
                                  ReversedPrinter,
                                  KeysPrinter)
from printers.numeric import (NumericUnaryPrinter,
                              NumericTruncPrinter,
                              NumericRoundPrinter,
                              NumericBinaryPrinter,
                              NumericPowPrinter)
from printers.other import (CallPrinter,
                            InstanceCheckPrinter,
                            SubclassCheckPrinter,
                            IsAbstractMethodPrinter)


def get_printer(info: PrintingInfo):
    method_kind = info.method_kind

    if method_kind == 'StringConversion':
        return StringConversionPrinter()

    if method_kind == 'Hash':
        return HashPrinter()
    if method_kind == 'Dir':
        return DirPrinter()

    if method_kind == 'Comparison':
        return ComparisonPrinter()

    if method_kind == 'AsBool':
        return AsBoolPrinter()
    if method_kind == 'AsInt':
        return AsIntPrinter()
    if method_kind == 'AsFloat':
        return AsFloatPrinter()
    if method_kind == 'AsComplex':
        return AsComplexPrinter()
    if method_kind == 'AsIndex':
        return AsIndexPrinter()

    if method_kind == 'GetAttribute':
        return GetAttributePrinter()
    if method_kind == 'SetAttribute':
        return SetAttributePrinter()
    if method_kind == 'DelAttribute':
        return DelAttributePrinter()

    if method_kind == 'GetItem':
        return GetItemPrinter()
    if method_kind == 'SetItem':
        return SetItemPrinter()
    if method_kind == 'DelItem':
        return DelItemPrinter()

    if method_kind == 'Iter':
        return IterPrinter()
    if method_kind == 'Next':
        return NextPrinter()
    if method_kind == 'GetLength':
        return GetLengthPrinter()
    if method_kind == 'Contains':
        return ContainsPrinter()
    if method_kind == 'Reversed':
        return ReversedPrinter()
    if method_kind == 'Keys':
        return KeysPrinter()

    if method_kind == 'Del':
        return DelPrinter()
    if method_kind == 'Call':
        return CallPrinter()

    if method_kind == 'InstanceCheck':
        return InstanceCheckPrinter()
    if method_kind == 'SubclassCheck':
        return SubclassCheckPrinter()
    if method_kind == 'IsAbstractMethod':
        return IsAbstractMethodPrinter()

    if method_kind == 'NumericUnary':
        return NumericUnaryPrinter()
    if method_kind == 'NumericTrunc':
        return NumericTruncPrinter()
    if method_kind == 'NumericRound':
        return NumericRoundPrinter()
    if method_kind == 'NumericBinary':
        return NumericBinaryPrinter()
    if method_kind == 'NumericPow':
        return NumericPowPrinter()

    method_name = info.method_name
    raise ValueError(f"Unknown method '{method_name}'")
