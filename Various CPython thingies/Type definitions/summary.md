int
- flags: default | baseType | longSubclass
- `__new__`: long_new
- `__init__`: 0

bool
- flags: default
- `__new__`: bool_new
- `__init__`: 0

float
- flags: default | baseType
- `__new__`: float_new
- `__init__`: 0

complex
- flags: default | baseType
- `__new__`: complex_new
- `__init__`: 0

NoneType
- flags: default
- `__new__`: none_new
- `__init__`: 0

NotImplementedType
- flags: default
- `__new__`: notimplemented_ne
- `__init__`: 0

ellipsis
- flags: default
- `__new__`: ellipsis_new
- `__init__`: 0

types.SimpleNamespace
- flags: default | hasGC | baseType
- `__new__`: (newfunc)namespace_new
- `__init__`: (initproc)namespace_init

module
- flags: default | hasGC | baseType
- `__new__`: PyType_GenericNew
- `__init__`: module___init__

builtin_function_or_method
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

property
- flags: default | hasGC | baseType
- `__new__`: PyType_GenericNew
- `__init__`: property_init

mappingproxy
- flags: default | hasGC
- `__new__`: mappingproxy_new
- `__init__`: 0

code
- flags: default
- `__new__`: code_new
- `__init__`: 0

function
- flags: default | hasGC
- `__new__`: func_new
- `__init__`: 0

classmethod
- flags: default | baseType | hasGC
- `__new__`: PyType_GenericNew
- `__init__`: cm_init

staticmethod
- flags: default | baseType | hasGC
- `__new__`: PyType_GenericNew
- `__init__`: sm_init

tuple
- flags: default | hasGC | baseType | tupleSubclass
- `__new__`: tuple_new
- `__init__`: 0

tuple_iterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

list
- flags: default | hasGC | baseType | listSubclass
- `__new__`: PyType_GenericNew
- `__init__`: (initproc)list___init__

list_iterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

list_reverseiterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

dict
- flags: default | hasGC | baseType | dictSubclass
- `__new__`: dict_new
- `__init__`: dict_init

dict_keyiterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

dict_valueiterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

dict_itemiterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

dict_keys
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

dict_items
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

dict_values
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

set
- flags: default | hasGC | baseType
- `__new__`: set_new
- `__init__`: (initproc)set_init

frozenset
- flags: default | hasGC | baseType
- `__new__`: frozenset_new
- `__init__`: 0

set_iterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

range
- flags: default
- `__new__`: range_new
- `__init__`: 0

range_iterator
- flags: default
- `__new__`: 0
- `__init__`: 0

longrange_iterator
- flags: default
- `__new__`: 0
- `__init__`: 0

enumerate
- flags: default | hasGC | baseType
- `__new__`: enum_new
- `__init__`: 0

reversed
- flags: default | hasGC | baseType
- `__new__`: reversed_new
- `__init__`: 0

slice
- flags: default | hasGC
- `__new__`: slice_new
- `__init__`: 0

iterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

callable_iterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

BaseException
- flags: default | baseType | hasGC | baseExceptionSubclass
- `__new__`: BaseException_new
- `__init__`: (initproc)BaseException_init

type
- flags: default | hasGC | baseType | typeSubclass
- `__new__`: type_new
- `__init__`: type_init

object
- flags: default | baseType
- `__new__`: object_new
- `__init__`: object_init

super
- flags: default | hasGC | baseType
- `__new__`: PyType_GenericNew
- `__init__`: super_init

filter
- flags: default | hasGC | baseType
- `__new__`: filter_new
- `__init__`: 0

map
- flags: default | hasGC | baseType
- `__new__`: map_new
- `__init__`: 0

zip
- flags: default | hasGC | baseType
- `__new__`: zip_new
- `__init__`: 0

stderrprinter
- flags: default
- `__new__`: stdprinter_new
- `__init__`: stdprinter_init

frame
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

managedbuffer
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

memoryview
- flags: default | hasGC
- `__new__`: memory_new
- `__init__`: 0

weakref
- flags: default | hasGC | baseType
- `__new__`: weakref___new__
- `__ini__`: weakref___init__

weakproxy
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

weakcallableproxy
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

symtable
- flags: default
- `__new__`: 0
- `__init__`: 0

traceback
- flags: default | hasGC
- `__new__`: tb_new
- `__init__`: 0

str
- flags: default | baseType | unicodeSubclass
- `__new__`: unicode_new
- `__init__`: 0

str_iterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

EncodingMap
- flags: default
- `__new__`: 0
- `__ini__`: 0

bytearray
- flags: default | baseType
- `__new__`: PyType_GenericNew
- `__init__`: (initproc)bytearray_init

bytearray_iterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0

bytes
- flags: default | baseType | bytesSubclass
- `__new__`: bytes_new
- `__init__`: 0

bytes_iterator
- flags: default | hasGC
- `__new__`: 0
- `__init__`: 0
