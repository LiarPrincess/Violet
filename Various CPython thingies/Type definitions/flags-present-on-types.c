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
#define Py_TPFLAGS_LONG_SUBCLASS (1UL << 24)
#define Py_TPFLAGS_LIST_SUBCLASS (1UL << 25)
#define Py_TPFLAGS_TUPLE_SUBCLASS (1UL << 26)
#define Py_TPFLAGS_BYTES_SUBCLASS (1UL << 27)
#define Py_TPFLAGS_UNICODE_SUBCLASS (1UL << 28)
#define Py_TPFLAGS_DICT_SUBCLASS (1UL << 29)
#define Py_TPFLAGS_BASE_EXC_SUBCLASS (1UL << 30)
#define Py_TPFLAGS_TYPE_SUBCLASS (1UL << 31)

#define Py_TPFLAGS_DEFAULT (              \
    Py_TPFLAGS_HAVE_STACKLESS_EXTENSION | \
    Py_TPFLAGS_HAVE_VERSION_TAG |         \
    0)

/* NOTE: The following flags reuse lower bits (removed as part of the
 * Python 3.0 transition). */

/* Type structure has tp_finalize member (3.4) */
#define Py_TPFLAGS_HAVE_FINALIZE (1UL << 0)
