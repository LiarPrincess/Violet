```c
/*
`Type flags (tp_flags)

These flags are used to extend the type structure in a backwards-compatible
fashion. Extensions can use the flags to indicate (and test) when a given
type structure contains a new feature. The Python core will use these when
introducing new functionality between major revisions (to avoid mid-version
changes in the PYTHON_API_VERSION).

Arbitration of the flag bit positions will need to be coordinated among
all extension writers who publicly release their extensions (this will
be fewer than you might expect!)..

Most flags were removed as of Python 3.0 to make room for new flags.  (Some
flags are not for backwards compatibility but to indicate the presence of an
optional feature; these flags remain of course.)

Type definitions should use Py_TPFLAGS_DEFAULT for their tp_flags value.

Code can use PyType_HasFeature(type_ob, flag_value) to test whether the
given type object has a specified feature.
*/

/* Set if the type object is dynamically allocated */
#define Py_TPFLAGS_HEAPTYPE (1UL << 9)

/* Set if the type allows subclassing */
#define Py_TPFLAGS_BASETYPE (1UL << 10)

/* Set if the type is 'ready' -- fully initialized */
// #define Py_TPFLAGS_READY (1UL << 12)

/* Set while the type is being 'readied', to prevent recursive ready calls */
// #define Py_TPFLAGS_READYING (1UL << 13)

/* Objects support garbage collection (see objimp.h) */
#define Py_TPFLAGS_HAVE_GC (1UL << 14)

/* These two bits are preserved for Stackless Python, next after this is 17 */
// #ifdef STACKLESS
// #define Py_TPFLAGS_HAVE_STACKLESS_EXTENSION (3UL << 15)
// #else
// #define Py_TPFLAGS_HAVE_STACKLESS_EXTENSION 0
// #endif

/* Objects support type attribute cache */
// #define Py_TPFLAGS_HAVE_VERSION_TAG   (1UL << 18)
// #define Py_TPFLAGS_VALID_VERSION_TAG  (1UL << 19)

/* Type is abstract and cannot be instantiated */
#define Py_TPFLAGS_IS_ABSTRACT (1UL << 20)

/* These flags are used to determine if a type is a subclass. */
#define Py_TPFLAGS_LONG_SUBCLASS        (1UL << 24)
#define Py_TPFLAGS_LIST_SUBCLASS        (1UL << 25)
#define Py_TPFLAGS_TUPLE_SUBCLASS       (1UL << 26)
#define Py_TPFLAGS_BYTES_SUBCLASS       (1UL << 27)
#define Py_TPFLAGS_UNICODE_SUBCLASS     (1UL << 28)
#define Py_TPFLAGS_DICT_SUBCLASS        (1UL << 29)
#define Py_TPFLAGS_BASE_EXC_SUBCLASS    (1UL << 30)
#define Py_TPFLAGS_TYPE_SUBCLASS        (1UL << 31)

#define Py_TPFLAGS_DEFAULT  ( \
                Py_TPFLAGS_HAVE_STACKLESS_EXTENSION | \
                Py_TPFLAGS_HAVE_VERSION_TAG | \
                0)

/* NOTE: The following flags reuse lower bits (removed as part of the
 * Python 3.0 transition). */

/* Type structure has tp_finalize member (3.4) */
#define Py_TPFLAGS_HAVE_FINALIZE (1UL << 0)
```

# int
  flags: default | baseType | longSubclass
  new: long_new
  init: 0
# bool
  flags: default
  new: bool_new
  init: 0
# float
  flags: default | baseType
  new: float_new
  init: 0
# complex
  flags: default | baseType
  new: complex_new
  init: 0
# NoneType
  flags: default
  new: none_new
  init: 0
# NotImplementedType
  flags: default
  new: notimplemented_ne
  init: 0
# ellipsis
  flags: default
  new: ellipsis_new
  init: 0
# types.SimpleNamespace
  flags: default | hasGC | baseType
  new: (newfunc)namespace_new
  init: (initproc)namespace_init
# module
  flags: default | hasGC | baseType
  new: PyType_GenericNew
  init: module___init__
# builtin_function_or_method
  flags: default | hasGC
  new: 0
  init: 0
# property
  flags: default | hasGC | baseType
  new: PyType_GenericNew
  init: property_init
# mappingproxy
  flags: default | hasGC
  new: mappingproxy_new
  init: 0
# code
  flags: default
  new: code_new
  init: 0
# function
  flags: default | hasGC
  new: func_new
  init: 0
# classmethod
  flags: default | baseType | hasGC
  new: PyType_GenericNew
  init: cm_init
# staticmethod
  flags: default | baseType | hasGC
  new: PyType_GenericNew
  init: sm_init
# tuple
  flags: default | hasGC | baseType | tupleSubclass
  new: tuple_new
  init: 0
# tuple_iterator
  flags: default | hasGC
  new: 0
  init: 0
# list
  flags: default | hasGC | baseType | listSubclass
  new: PyType_GenericNew
  init: (initproc)list___init__
# list_iterator
  flags: default | hasGC
  new: 0
  init: 0
# list_reverseiterator
  flags: default | hasGC
  new: 0
  init: 0
# dict
  flags: default | hasGC | baseType | dictSubclass
  new: dict_new
  init: dict_init
# dict_keyiterator
  flags: default | hasGC
  new: 0
  init: 0
# dict_valueiterator
  flags: default | hasGC
  new: 0
  init: 0
# dict_itemiterator
  flags: default | hasGC
  new: 0
  init: 0
# dict_keys
  flags: default | hasGC
  new: 0
  init: 0
# dict_items
  flags: default | hasGC
  new: 0
  init: 0
# dict_values
  flags: default | hasGC
  new: 0
  init: 0
# set
  flags: default | hasGC | baseType
  new: set_new
  init: (initproc)set_init
# frozenset
  flags: default | hasGC | baseType
  new: frozenset_new
  init: 0
# set_iterator
  flags: default | hasGC
  new: 0
  init: 0
# range
  flags: default
  new: range_new
  init: 0
# range_iterator
  flags: default
  new: 0
  init: 0
# longrange_iterator
  flags: default
  new: 0
  init: 0
# enumerate
  flags: default | hasGC | baseType
  new: enum_new
  init: 0
# reversed
  flags: default | hasGC | baseType
  new: reversed_new
  init: 0
# slice
  flags: default | hasGC
  new: slice_new
  init: 0
# iterator
  flags: default | hasGC
  new: 0
  init: 0
# callable_iterator
  flags: default | hasGC
  new: 0
  init: 0
# BaseException
  flags: default | baseType | hasGC | baseExceptionSubclass
  new: BaseException_new
  init: (initproc)BaseException_init
# type
  flags: default | hasGC | baseType | typeSubclass
  new: type_new
  init: type_init
# object
  flags: default | baseType
  new: object_new
  init: object_init
# super
  flags: default | hasGC | baseType
  new: PyType_GenericNew
  init: super_init
# filter
  flags: default | hasGC | baseType
  new: filter_new
  init: 0
# map
  flags: default | hasGC | baseType
  new: map_new
  init: 0
# zip
  flags: default | hasGC | baseType
  new: zip_new
  init: 0
# stderrprinter
  flags: default
  new: stdprinter_new
  init: stdprinter_init
# frame
  flags: default | hasGC
  new: 0
  init: 0
# managedbuffer
  flags: default | hasGC
  new: 0
  init: 0
# memoryview
  flags: default | hasGC
  new: memory_new
  init: 0
# weakref
  flags: default | hasGC | baseType
  new: weakref___new__
  ini: weakref___init__
# weakproxy
  flags: default | hasGC
  new: 0
  init: 0
# weakcallableproxy
  flags: default | hasGC
  new: 0
  init: 0
# symtable
  flags: default
  new: 0
  init: 0
# traceback
  flags: default | hasGC
  new: tb_new
  init: 0
# str
  flags: default | baseType | unicodeSubclass
  new: unicode_new
  init: 0
# str_iterator
  flags: default | hasGC
  new: 0
  init: 0
# EncodingMap
  flags: default
  new: 0
  ini: 0
# bytearray
  flags: default | baseType
  new: PyType_GenericNew
  init: (initproc)bytearray_init
# bytearray_iterator
  flags: default | hasGC
  new: 0
  init: 0
# bytes
  flags: default | baseType | bytesSubclass
  new: bytes_new
  init: 0
# bytes_iterator
  flags: default | hasGC
  new: 0
  init: 0
