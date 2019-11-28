# int
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_LONG_SUBCLASS
  new: long_new
  init: 0
# bool
  Py_TPFLAGS_DEFAULT
  new: bool_new
  init: 0
# float
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE
  new: float_new
  init: 0
# complex
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE
  new: complex_new
  init: 0
# NoneType
  Py_TPFLAGS_DEFAULT
  new: none_new
  init: 0
# NotImplementedType
  Py_TPFLAGS_DEFAULT
  new: notimplemented_ne
  init: 0
# ellipsis
  Py_TPFLAGS_DEFAULT
  new: ellipsis_new
  init: 0
# types.SimpleNamespace
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: (newfunc)namespace_new
  init: (initproc)namespace_init
# module
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: PyType_GenericNew
  init: module___init__
# builtin_function_or_method
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# property
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: PyType_GenericNew
  init: property_init
# mappingproxy
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: mappingproxy_new
  init: 0
# code
  Py_TPFLAGS_DEFAULT
  new: code_new
  init: 0
# function
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: func_new
  init: 0
# classmethod
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC
  new: PyType_GenericNew
  init: cm_init
# staticmethod
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC
  new: PyType_GenericNew
  init: sm_init
# tuple
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_TUPLE_SUBCLASS
  new: tuple_new
  init: 0
# tuple_iterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# list
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_LIST_SUBCLASS
  new: PyType_GenericNew
  init: (initproc)list___init__
# list_iterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# list_reverseiterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# dict
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_DICT_SUBCLASS
  new: dict_new
  init: dict_init
# dict_keyiterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# dict_valueiterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# dict_itemiterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# dict_keys
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# dict_items
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# dict_values
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# set
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: set_new
  init: (initproc)set_init
# frozenset
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: frozenset_new
  init: 0
# set_iterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# range
  Py_TPFLAGS_DEFAULT
  new: range_new
  init: 0
# range_iterator
  Py_TPFLAGS_DEFAULT
  new: 0
  init: 0
# longrange_iterator
  Py_TPFLAGS_DEFAULT
  new: 0
  init: 0
# enumerate
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: enum_new
  init: 0
# reversed
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: reversed_new
  init: 0
# slice
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: slice_new
  init: 0
# iterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# callable_iterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# BaseException
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASE_EXC_SUBCLASS
  new: BaseException_new
  init: (initproc)BaseException_init
# type
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_TYPE_SUBCLASS
  new: type_new
  init: type_init
# object
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE
  new: object_new
  init: object_init
# super
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: PyType_GenericNew
  init: super_init
# filter
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: filter_new
  init: 0
# map
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: map_new
  init: 0
# zip
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: zip_new
  init: 0
# stderrprinter
  Py_TPFLAGS_DEFAULT
  new: stdprinter_new
  init: stdprinter_init
# frame
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# managedbuffer
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# memoryview
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: memory_new
  init: 0
# weakref
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE
  new: weakref___new__
  ini: weakref___init__
# weakproxy
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# weakcallableproxy
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# symtable
  Py_TPFLAGS_DEFAULT
  new: 0
  init: 0
# traceback
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: tb_new
  init: 0
# str
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_UNICODE_SUBCLASS
  new: unicode_new
  init: 0
# str_iterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# EncodingMap
  Py_TPFLAGS_DEFAULT
  new: 0
  ini: 0
# bytearray
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE
  new: PyType_GenericNew
  init: (initproc)bytearray_init
# bytearray_iterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
# bytes
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_BYTES_SUBCLASS
  new: bytes_new
  init: 0
# bytes_iterator
  Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC
  new: 0
  init: 0
