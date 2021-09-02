https://docs.python.org/3/c-api/structures.html

# methodobject.h
// This is about the type 'builtin_function_or_method',
// not Python methods in user-defined classes.

## functions()
typedef PyNoArgsFunction        = (PyObject data) -> PyObject // METH_VARARGS
typedef PyCFunction             = (PyObject data, PyObject args) -> PyObject // METH_NOARGS
typedef PyCFunctionWithKeywords = (PyObject data, PyObject args, PyObject kwds) -> PyObject // METH_KEYWORDS

typedef _PyCFunctionFast             = (PyObject, PyObject const, Py_ssize_t) -> PyObject
typedef _PyCFunctionFastWithKeywords = (PyObject, PyObject const, Py_ssize_t, PyObject) -> PyObject

struct PyMethodDef {
  const char  *ml_name;   /* The name of the built-in function/method */
  PyCFunction  ml_meth;   /* The C function that implements it */
  int          ml_flags;  /* Combination of METH_xxx flags, which mostly describe the args expected by the C func */
  const char  *ml_doc;    /* The __doc__ attribute, or NULL */
};

## builtin_function_or_method()
typedef struct {
  PyObject_HEAD
  PyMethodDef *m_ml; /* Description of the C function to call */
  PyObject    *m_self; /* Passed as 'self' arg to the C func, can be NULL */
  PyObject    *m_module; /* The __module__ attribute, can be anything */
  PyObject    *m_weakreflist; /* List of weak references */
} PyCFunctionObject;









# classobject.h
// Former class object interface -- now only bound methods are here
// Class object implementation (dead now except for methods)

## method()
// method(function, instance)
// Create a bound instance method object.

typedef struct {
  PyObject_HEAD
  PyObject *im_func;   /* The callable object implementing the method */
  PyObject *im_self;   /* The instance it is bound to */
  PyObject *im_weakreflist; /* List of weak references */
} PyMethodObject;

## instancemethod()
// instancemethod(function)
// Bind a function to a class.

typedef struct {
  PyObject_HEAD
  PyObject *func;
} PyInstanceMethodObject;











# funcobject.h
// Function objects are created by the execution of the 'def' statement.
// They reference a code object in their __code__ attribute.
// There is one code object per source code "fragment",
// but each code object can be referenced by zero or many function objects
// depending only on how many times the 'def' statement in the source was
// executed so far.

## function()
// function(code, globals, name=None, argdefs=None, closure=None)
// --

// Create a function object.

//   code
//     a code object
//   globals
//     the globals dictionary
//   name
//     a string that overrides the name from the code object
//   argdefs
//     a tuple that specifies the default argument values
//   closure
//     a tuple that supplies the bindings for free variables
typedef struct {
  PyObject_HEAD
  PyObject *func_code;        /* A code object, the __code__ attribute */

  PyObject *func_globals;     /* A dictionary (other mappings won't do) */
  PyObject *func_defaults;    /* NULL or a tuple */
  PyObject *func_kwdefaults;  /* NULL or a dict */
  PyObject *func_closure;     /* NULL or a tuple of cell objects */

  PyObject *func_doc;         /* The __doc__ attribute, can be anything */
  PyObject *func_name;        /* The __name__ attribute, a string object */
  PyObject *func_qualname;    /* The qualified name */
  PyObject *func_dict;        /* The __dict__ attribute, a dict or NULL */
  PyObject *func_module;      /* The __module__ attribute, can be anything */

  PyObject *func_weakreflist; /* List of weak references */
  PyObject *func_annotations; /* Annotations, a dict or NULL */

  /* Invariant:
    *     func_closure contains the bindings for func_code->co_freevars, so
    *     PyTuple_Size(func_closure) == PyCode_GetNumFree(func_code)
    *     (func_closure may be NULL if PyCode_GetNumFree(func_code) == 0).
    */
} PyFunctionObject;











# descrobject.h
// Descriptors -- a new, flexible way to describe attributes

typedef struct PyGetSetDef {
    const char *name;
    getter get;
    setter set;
    const char *doc;
    void *closure;
} PyGetSetDef;

struct wrapperbase {
    const char *name;
    int offset;
    void *function;
    wrapperfunc wrapper;
    const char *doc;
    int flags;
    PyObject *name_strobj;
};

// Various kinds of descriptor objects

typedef struct {
    PyObject_HEAD
    PyTypeObject *d_type;
    PyObject *d_name;
    PyObject *d_qualname;
} PyDescrObject;

## method_descriptor()
typedef struct {
    PyDescr_COMMON;
    PyMethodDef *d_method;
} PyMethodDescrObject;

## classmethod_descriptor()
// This is for METH_CLASS in C, not for "f = classmethod(f)" in Python!

## member_descriptor()
typedef struct {
    PyDescr_COMMON;
    struct PyMemberDef *d_member;
} PyMemberDescrObject;

## getset_descriptor()
typedef struct {
    PyDescr_COMMON;
    PyGetSetDef *d_getset;
} PyGetSetDescrObject;

## wrapper_descriptor()
typedef struct {
    PyDescr_COMMON;
    struct wrapperbase *d_base;
    void *d_wrapped; /* This can be any function pointer */
} PyWrapperDescrObject;

## method-wrapper()
## mappingproxy()
## property()
