// This file contains all of the CPython type definitions.

PyTypeObject PyLong_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "int",                        /* tp_name */
    offsetof(PyLongObject, ob_digit),                                    /* tp_basicsize */
    sizeof(digit),                                                       /* tp_itemsize */
    long_dealloc,                                                        /* tp_dealloc */
    0,                                                                   /* tp_print */
    0,                                                                   /* tp_getattr */
    0,                                                                   /* tp_setattr */
    0,                                                                   /* tp_reserved */
    long_to_decimal_string,                                              /* tp_repr */
    &long_as_number,                                                     /* tp_as_number */
    0,                                                                   /* tp_as_sequence */
    0,                                                                   /* tp_as_mapping */
    (hashfunc)long_hash,                                                 /* tp_hash */
    0,                                                                   /* tp_call */
    long_to_decimal_string,                                              /* tp_str */
    PyObject_GenericGetAttr,                                             /* tp_getattro */
    0,                                                                   /* tp_setattro */
    0,                                                                   /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_LONG_SUBCLASS, /* tp_flags */
    long_doc,                                                            /* tp_doc */
    0,                                                                   /* tp_traverse */
    0,                                                                   /* tp_clear */
    long_richcompare,                                                    /* tp_richcompare */
    0,                                                                   /* tp_weaklistoffset */
    0,                                                                   /* tp_iter */
    0,                                                                   /* tp_iternext */
    long_methods,                                                        /* tp_methods */
    0,                                                                   /* tp_members */
    long_getset,                                                         /* tp_getset */
    0,                                                                   /* tp_base */
    0,                                                                   /* tp_dict */
    0,                                                                   /* tp_descr_get */
    0,                                                                   /* tp_descr_set */
    0,                                                                   /* tp_dictoffset */
    0,                                                                   /* tp_init */
    0,                                                                   /* tp_alloc */
    long_new,                                                            /* tp_new */
    PyObject_Del,                                                        /* tp_free */
};

PyTypeObject PyBool_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "bool",
    sizeof(struct _longobject),
    0,
    0,                  /* tp_dealloc */
    0,                  /* tp_print */
    0,                  /* tp_getattr */
    0,                  /* tp_setattr */
    0,                  /* tp_reserved */
    bool_repr,          /* tp_repr */
    &bool_as_number,    /* tp_as_number */
    0,                  /* tp_as_sequence */
    0,                  /* tp_as_mapping */
    0,                  /* tp_hash */
    0,                  /* tp_call */
    bool_repr,          /* tp_str */
    0,                  /* tp_getattro */
    0,                  /* tp_setattro */
    0,                  /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT, /* tp_flags */
    bool_doc,           /* tp_doc */
    0,                  /* tp_traverse */
    0,                  /* tp_clear */
    0,                  /* tp_richcompare */
    0,                  /* tp_weaklistoffset */
    0,                  /* tp_iter */
    0,                  /* tp_iternext */
    0,                  /* tp_methods */
    0,                  /* tp_members */
    0,                  /* tp_getset */
    &PyLong_Type,       /* tp_base */
    0,                  /* tp_dict */
    0,                  /* tp_descr_get */
    0,                  /* tp_descr_set */
    0,                  /* tp_dictoffset */
    0,                  /* tp_init */
    0,                  /* tp_alloc */
    bool_new,           /* tp_new */
};

PyTypeObject PyFloat_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "float",
    sizeof(PyFloatObject),
    0,
    (destructor)float_dealloc,                /* tp_dealloc */
    0,                                        /* tp_print */
    0,                                        /* tp_getattr */
    0,                                        /* tp_setattr */
    0,                                        /* tp_reserved */
    (reprfunc)float_repr,                     /* tp_repr */
    &float_as_number,                         /* tp_as_number */
    0,                                        /* tp_as_sequence */
    0,                                        /* tp_as_mapping */
    (hashfunc)float_hash,                     /* tp_hash */
    0,                                        /* tp_call */
    (reprfunc)float_repr,                     /* tp_str */
    PyObject_GenericGetAttr,                  /* tp_getattro */
    0,                                        /* tp_setattro */
    0,                                        /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE, /* tp_flags */
    float_new__doc__,                         /* tp_doc */
    0,                                        /* tp_traverse */
    0,                                        /* tp_clear */
    float_richcompare,                        /* tp_richcompare */
    0,                                        /* tp_weaklistoffset */
    0,                                        /* tp_iter */
    0,                                        /* tp_iternext */
    float_methods,                            /* tp_methods */
    0,                                        /* tp_members */
    float_getset,                             /* tp_getset */
    0,                                        /* tp_base */
    0,                                        /* tp_dict */
    0,                                        /* tp_descr_get */
    0,                                        /* tp_descr_set */
    0,                                        /* tp_dictoffset */
    0,                                        /* tp_init */
    0,                                        /* tp_alloc */
    float_new,                                /* tp_new */
};

PyTypeObject PyComplex_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "complex",
    sizeof(PyComplexObject),
    0,
    complex_dealloc,                          /* tp_dealloc */
    0,                                        /* tp_print */
    0,                                        /* tp_getattr */
    0,                                        /* tp_setattr */
    0,                                        /* tp_reserved */
    (reprfunc)complex_repr,                   /* tp_repr */
    &complex_as_number,                       /* tp_as_number */
    0,                                        /* tp_as_sequence */
    0,                                        /* tp_as_mapping */
    (hashfunc)complex_hash,                   /* tp_hash */
    0,                                        /* tp_call */
    (reprfunc)complex_repr,                   /* tp_str */
    PyObject_GenericGetAttr,                  /* tp_getattro */
    0,                                        /* tp_setattro */
    0,                                        /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE, /* tp_flags */
    complex_new__doc__,                       /* tp_doc */
    0,                                        /* tp_traverse */
    0,                                        /* tp_clear */
    complex_richcompare,                      /* tp_richcompare */
    0,                                        /* tp_weaklistoffset */
    0,                                        /* tp_iter */
    0,                                        /* tp_iternext */
    complex_methods,                          /* tp_methods */
    complex_members,                          /* tp_members */
    0,                                        /* tp_getset */
    0,                                        /* tp_base */
    0,                                        /* tp_dict */
    0,                                        /* tp_descr_get */
    0,                                        /* tp_descr_set */
    0,                                        /* tp_dictoffset */
    0,                                        /* tp_init */
    PyType_GenericAlloc,                      /* tp_alloc */
    complex_new,                              /* tp_new */
    PyObject_Del,                             /* tp_free */
};

PyTypeObject _PyNone_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "NoneType",
    0,
    0,
    none_dealloc, /*tp_dealloc*/ /*never called*/
    0,                           /*tp_print*/
    0,                           /*tp_getattr*/
    0,                           /*tp_setattr*/
    0,                           /*tp_reserved*/
    none_repr,                   /*tp_repr*/
    &none_as_number,             /*tp_as_number*/
    0,                           /*tp_as_sequence*/
    0,                           /*tp_as_mapping*/
    0,                           /*tp_hash */
    0,                           /*tp_call */
    0,                           /*tp_str */
    0,                           /*tp_getattro */
    0,                           /*tp_setattro */
    0,                           /*tp_as_buffer */
    Py_TPFLAGS_DEFAULT,          /*tp_flags */
    0,                           /*tp_doc */
    0,                           /*tp_traverse */
    0,                           /*tp_clear */
    0,                           /*tp_richcompare */
    0,                           /*tp_weaklistoffset */
    0,                           /*tp_iter */
    0,                           /*tp_iternext */
    0,                           /*tp_methods */
    0,                           /*tp_members */
    0,                           /*tp_getset */
    0,                           /*tp_base */
    0,                           /*tp_dict */
    0,                           /*tp_descr_get */
    0,                           /*tp_descr_set */
    0,                           /*tp_dictoffset */
    0,                           /*tp_init */
    0,                           /*tp_alloc */
    none_new,                    /*tp_new */
};

PyTypeObject _PyNotImplemented_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "NotImplementedType",
    0,
    0,
    notimplemented_dealloc, /*tp_dealloc*/ /*never called*/
    0,                                     /*tp_print*/
    0,                                     /*tp_getattr*/
    0,                                     /*tp_setattr*/
    0,                                     /*tp_reserved*/
    NotImplemented_repr,                   /*tp_repr*/
    0,                                     /*tp_as_number*/
    0,                                     /*tp_as_sequence*/
    0,                                     /*tp_as_mapping*/
    0,                                     /*tp_hash */
    0,                                     /*tp_call */
    0,                                     /*tp_str */
    0,                                     /*tp_getattro */
    0,                                     /*tp_setattro */
    0,                                     /*tp_as_buffer */
    Py_TPFLAGS_DEFAULT,                    /*tp_flags */
    0,                                     /*tp_doc */
    0,                                     /*tp_traverse */
    0,                                     /*tp_clear */
    0,                                     /*tp_richcompare */
    0,                                     /*tp_weaklistoffset */
    0,                                     /*tp_iter */
    0,                                     /*tp_iternext */
    notimplemented_methods,                /*tp_methods */
    0,                                     /*tp_members */
    0,                                     /*tp_getset */
    0,                                     /*tp_base */
    0,                                     /*tp_dict */
    0,                                     /*tp_descr_get */
    0,                                     /*tp_descr_set */
    0,                                     /*tp_dictoffset */
    0,                                     /*tp_init */
    0,                                     /*tp_alloc */
    notimplemented_new,                    /*tp_new */
};

PyTypeObject PyEllipsis_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "ellipsis", /* tp_name */
    0,                                                 /* tp_basicsize */
    0,                                                 /* tp_itemsize */
    0, /*never called*/                                /* tp_dealloc */
    0,                                                 /* tp_print */
    0,                                                 /* tp_getattr */
    0,                                                 /* tp_setattr */
    0,                                                 /* tp_reserved */
    ellipsis_repr,                                     /* tp_repr */
    0,                                                 /* tp_as_number */
    0,                                                 /* tp_as_sequence */
    0,                                                 /* tp_as_mapping */
    0,                                                 /* tp_hash */
    0,                                                 /* tp_call */
    0,                                                 /* tp_str */
    PyObject_GenericGetAttr,                           /* tp_getattro */
    0,                                                 /* tp_setattro */
    0,                                                 /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT,                                /* tp_flags */
    0,                                                 /* tp_doc */
    0,                                                 /* tp_traverse */
    0,                                                 /* tp_clear */
    0,                                                 /* tp_richcompare */
    0,                                                 /* tp_weaklistoffset */
    0,                                                 /* tp_iter */
    0,                                                 /* tp_iternext */
    ellipsis_methods,                                  /* tp_methods */
    0,                                                 /* tp_members */
    0,                                                 /* tp_getset */
    0,                                                 /* tp_base */
    0,                                                 /* tp_dict */
    0,                                                 /* tp_descr_get */
    0,                                                 /* tp_descr_set */
    0,                                                 /* tp_dictoffset */
    0,                                                 /* tp_init */
    0,                                                 /* tp_alloc */
    ellipsis_new,                                      /* tp_new */
};
PyTypeObject _PyNamespace_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "types.SimpleNamespace", /* tp_name */
    sizeof(_PyNamespaceObject),                                     /* tp_basicsize */
    0,                                                              /* tp_itemsize */
    (destructor)namespace_dealloc,                                  /* tp_dealloc */
    0,                                                              /* tp_print */
    0,                                                              /* tp_getattr */
    0,                                                              /* tp_setattr */
    0,                                                              /* tp_reserved */
    (reprfunc)namespace_repr,                                       /* tp_repr */
    0,                                                              /* tp_as_number */
    0,                                                              /* tp_as_sequence */
    0,                                                              /* tp_as_mapping */
    0,                                                              /* tp_hash */
    0,                                                              /* tp_call */
    0,                                                              /* tp_str */
    PyObject_GenericGetAttr,                                        /* tp_getattro */
    PyObject_GenericSetAttr,                                        /* tp_setattro */
    0,                                                              /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE,  /* tp_flags */
    namespace_doc,                                                  /* tp_doc */
    (traverseproc)namespace_traverse,                               /* tp_traverse */
    (inquiry)namespace_clear,                                       /* tp_clear */
    namespace_richcompare,                                          /* tp_richcompare */
    0,                                                              /* tp_weaklistoffset */
    0,                                                              /* tp_iter */
    0,                                                              /* tp_iternext */
    namespace_methods,                                              /* tp_methods */
    namespace_members,                                              /* tp_members */
    0,                                                              /* tp_getset */
    0,                                                              /* tp_base */
    0,                                                              /* tp_dict */
    0,                                                              /* tp_descr_get */
    0,                                                              /* tp_descr_set */
    offsetof(_PyNamespaceObject, ns_dict),                          /* tp_dictoffset */
    (initproc)namespace_init,                                       /* tp_init */
    PyType_GenericAlloc,                                            /* tp_alloc */
    (newfunc)namespace_new,                                         /* tp_new */
    PyObject_GC_Del,                                                /* tp_free */
};

PyTypeObject PyModule_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "module",               /* tp_name */
    sizeof(PyModuleObject),                                        /* tp_basicsize */
    0,                                                             /* tp_itemsize */
    (destructor)module_dealloc,                                    /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    (reprfunc)module_repr,                                         /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    (getattrofunc)module_getattro,                                 /* tp_getattro */
    PyObject_GenericSetAttr,                                       /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    module___init____doc__,                                        /* tp_doc */
    (traverseproc)module_traverse,                                 /* tp_traverse */
    (inquiry)module_clear,                                         /* tp_clear */
    0,                                                             /* tp_richcompare */
    offsetof(PyModuleObject, md_weaklist),                         /* tp_weaklistoffset */
    0,                                                             /* tp_iter */
    0,                                                             /* tp_iternext */
    module_methods,                                                /* tp_methods */
    module_members,                                                /* tp_members */
    0,                                                             /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    0,                                                             /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    offsetof(PyModuleObject, md_dict),                             /* tp_dictoffset */
    module___init__,                                               /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    PyType_GenericNew,                                             /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PyCFunction_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "builtin_function_or_method",
    sizeof(PyCFunctionObject),
    0,
    (destructor)meth_dealloc,                   /* tp_dealloc */
    0,                                          /* tp_print */
    0,                                          /* tp_getattr */
    0,                                          /* tp_setattr */
    0,                                          /* tp_reserved */
    (reprfunc)meth_repr,                        /* tp_repr */
    0,                                          /* tp_as_number */
    0,                                          /* tp_as_sequence */
    0,                                          /* tp_as_mapping */
    (hashfunc)meth_hash,                        /* tp_hash */
    PyCFunction_Call,                           /* tp_call */
    0,                                          /* tp_str */
    PyObject_GenericGetAttr,                    /* tp_getattro */
    0,                                          /* tp_setattro */
    0,                                          /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC,    /* tp_flags */
    0,                                          /* tp_doc */
    (traverseproc)meth_traverse,                /* tp_traverse */
    0,                                          /* tp_clear */
    meth_richcompare,                           /* tp_richcompare */
    offsetof(PyCFunctionObject, m_weakreflist), /* tp_weaklistoffset */
    0,                                          /* tp_iter */
    0,                                          /* tp_iternext */
    meth_methods,                               /* tp_methods */
    meth_members,                               /* tp_members */
    meth_getsets,                               /* tp_getset */
    0,                                          /* tp_base */
    0,                                          /* tp_dict */
    0,                                          /* tp_init */
    0,                                          /* tp_new */
};

PyTypeObject PyProperty_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "property", /* tp_name */
    sizeof(propertyobject),                            /* tp_basicsize */
    0,                                                 /* tp_itemsize */
    /* methods */
    property_dealloc,                                              /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    0,                                                             /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    PyObject_GenericGetAttr,                                       /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    property_init__doc__,                                          /* tp_doc */
    property_traverse,                                             /* tp_traverse */
    (inquiry)property_clear,                                       /* tp_clear */
    0,                                                             /* tp_richcompare */
    0,                                                             /* tp_weaklistoffset */
    0,                                                             /* tp_iter */
    0,                                                             /* tp_iternext */
    property_methods,                                              /* tp_methods */
    property_members,                                              /* tp_members */
    property_getsetlist,                                           /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    property_descr_get,                                            /* tp_descr_get */
    property_descr_set,                                            /* tp_descr_set */
    0,                                                             /* tp_dictoffset */
    property_init,                                                 /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    PyType_GenericNew,                                             /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PyDictProxy_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "mappingproxy", /* tp_name */
    sizeof(mappingproxyobject),                            /* tp_basicsize */
    0,                                                     /* tp_itemsize */
    /* methods */
    (destructor)mappingproxy_dealloc,        /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    (reprfunc)mappingproxy_repr,             /* tp_repr */
    0,                                       /* tp_as_number */
    &mappingproxy_as_sequence,               /* tp_as_sequence */
    &mappingproxy_as_mapping,                /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    (reprfunc)mappingproxy_str,              /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    mappingproxy_traverse,                   /* tp_traverse */
    0,                                       /* tp_clear */
    (richcmpfunc)mappingproxy_richcompare,   /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    (getiterfunc)mappingproxy_getiter,       /* tp_iter */
    0,                                       /* tp_iternext */
    mappingproxy_methods,                    /* tp_methods */
    0,                                       /* tp_members */
    0,                                       /* tp_getset */
    0,                                       /* tp_base */
    0,                                       /* tp_dict */
    0,                                       /* tp_descr_get */
    0,                                       /* tp_descr_set */
    0,                                       /* tp_dictoffset */
    0,                                       /* tp_init */
    0,                                       /* tp_alloc */
    mappingproxy_new,                        /* tp_new */
};

PyTypeObject PyCode_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "code",
    sizeof(PyCodeObject),
    0,
    (destructor)code_dealloc,               /* tp_dealloc */
    0,                                      /* tp_print */
    0,                                      /* tp_getattr */
    0,                                      /* tp_setattr */
    0,                                      /* tp_reserved */
    (reprfunc)code_repr,                    /* tp_repr */
    0,                                      /* tp_as_number */
    0,                                      /* tp_as_sequence */
    0,                                      /* tp_as_mapping */
    (hashfunc)code_hash,                    /* tp_hash */
    0,                                      /* tp_call */
    0,                                      /* tp_str */
    PyObject_GenericGetAttr,                /* tp_getattro */
    0,                                      /* tp_setattro */
    0,                                      /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT,                     /* tp_flags */
    code_doc,                               /* tp_doc */
    0,                                      /* tp_traverse */
    0,                                      /* tp_clear */
    code_richcompare,                       /* tp_richcompare */
    offsetof(PyCodeObject, co_weakreflist), /* tp_weaklistoffset */
    0,                                      /* tp_iter */
    0,                                      /* tp_iternext */
    code_methods,                           /* tp_methods */
    code_memberlist,                        /* tp_members */
    0,                                      /* tp_getset */
    0,                                      /* tp_base */
    0,                                      /* tp_dict */
    0,                                      /* tp_descr_get */
    0,                                      /* tp_descr_set */
    0,                                      /* tp_dictoffset */
    0,                                      /* tp_init */
    0,                                      /* tp_alloc */
    code_new,                               /* tp_new */
};

PyTypeObject PyFunction_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "function",
    sizeof(PyFunctionObject),
    0,
    (destructor)func_dealloc,                     /* tp_dealloc */
    0,                                            /* tp_print */
    0,                                            /* tp_getattr */
    0,                                            /* tp_setattr */
    0,                                            /* tp_reserved */
    (reprfunc)func_repr,                          /* tp_repr */
    0,                                            /* tp_as_number */
    0,                                            /* tp_as_sequence */
    0,                                            /* tp_as_mapping */
    0,                                            /* tp_hash */
    function_call,                                /* tp_call */
    0,                                            /* tp_str */
    0,                                            /* tp_getattro */
    0,                                            /* tp_setattro */
    0,                                            /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC,      /* tp_flags */
    func_new__doc__,                              /* tp_doc */
    (traverseproc)func_traverse,                  /* tp_traverse */
    0,                                            /* tp_clear */
    0,                                            /* tp_richcompare */
    offsetof(PyFunctionObject, func_weakreflist), /* tp_weaklistoffset */
    0,                                            /* tp_iter */
    0,                                            /* tp_iternext */
    0,                                            /* tp_methods */
    func_memberlist,                              /* tp_members */
    func_getsetlist,                              /* tp_getset */
    0,                                            /* tp_base */
    0,                                            /* tp_dict */
    func_descr_get,                               /* tp_descr_get */
    0,                                            /* tp_descr_set */
    offsetof(PyFunctionObject, func_dict),        /* tp_dictoffset */
    0,                                            /* tp_init */
    0,                                            /* tp_alloc */
    func_new,                                     /* tp_new */
};

PyTypeObject PyClassMethod_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "classmethod",
    sizeof(classmethod),
    0,
    (destructor)cm_dealloc,                                        /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    0,                                                             /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    0,                                                             /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    classmethod_doc,                                               /* tp_doc */
    (traverseproc)cm_traverse,                                     /* tp_traverse */
    (inquiry)cm_clear,                                             /* tp_clear */
    0,                                                             /* tp_richcompare */
    0,                                                             /* tp_weaklistoffset */
    0,                                                             /* tp_iter */
    0,                                                             /* tp_iternext */
    0,                                                             /* tp_methods */
    cm_memberlist,                                                 /* tp_members */
    cm_getsetlist,                                                 /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    cm_descr_get,                                                  /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    offsetof(classmethod, cm_dict),                                /* tp_dictoffset */
    cm_init,                                                       /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    PyType_GenericNew,                                             /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PyStaticMethod_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "staticmethod",
    sizeof(staticmethod),
    0,
    (destructor)sm_dealloc,                                        /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    0,                                                             /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    0,                                                             /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    staticmethod_doc,                                              /* tp_doc */
    (traverseproc)sm_traverse,                                     /* tp_traverse */
    (inquiry)sm_clear,                                             /* tp_clear */
    0,                                                             /* tp_richcompare */
    0,                                                             /* tp_weaklistoffset */
    0,                                                             /* tp_iter */
    0,                                                             /* tp_iternext */
    0,                                                             /* tp_methods */
    sm_memberlist,                                                 /* tp_members */
    sm_getsetlist,                                                 /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    sm_descr_get,                                                  /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    offsetof(staticmethod, sm_dict),                               /* tp_dictoffset */
    sm_init,                                                       /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    PyType_GenericNew,                                             /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};
PyTypeObject PyTuple_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "tuple",
    sizeof(PyTupleObject) - sizeof(PyObject *),
    sizeof(PyObject *),
    (destructor)tupledealloc,                                                                  /* tp_dealloc */
    0,                                                                                         /* tp_print */
    0,                                                                                         /* tp_getattr */
    0,                                                                                         /* tp_setattr */
    0,                                                                                         /* tp_reserved */
    (reprfunc)tuplerepr,                                                                       /* tp_repr */
    0,                                                                                         /* tp_as_number */
    &tuple_as_sequence,                                                                        /* tp_as_sequence */
    &tuple_as_mapping,                                                                         /* tp_as_mapping */
    (hashfunc)tuplehash,                                                                       /* tp_hash */
    0,                                                                                         /* tp_call */
    0,                                                                                         /* tp_str */
    PyObject_GenericGetAttr,                                                                   /* tp_getattro */
    0,                                                                                         /* tp_setattro */
    0,                                                                                         /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_TUPLE_SUBCLASS, /* tp_flags */
    tuple_new__doc__,                                                                          /* tp_doc */
    (traverseproc)tupletraverse,                                                               /* tp_traverse */
    0,                                                                                         /* tp_clear */
    tuplerichcompare,                                                                          /* tp_richcompare */
    0,                                                                                         /* tp_weaklistoffset */
    tuple_iter,                                                                                /* tp_iter */
    0,                                                                                         /* tp_iternext */
    tuple_methods,                                                                             /* tp_methods */
    0,                                                                                         /* tp_members */
    0,                                                                                         /* tp_getset */
    0,                                                                                         /* tp_base */
    0,                                                                                         /* tp_dict */
    0,                                                                                         /* tp_descr_get */
    0,                                                                                         /* tp_descr_set */
    0,                                                                                         /* tp_dictoffset */
    0,                                                                                         /* tp_init */
    0,                                                                                         /* tp_alloc */
    tuple_new,                                                                                 /* tp_new */
    PyObject_GC_Del,                                                                           /* tp_free */
};

PyTypeObject PyTupleIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "tuple_iterator", /* tp_name */
    sizeof(tupleiterobject),                                 /* tp_basicsize */
    0,                                                       /* tp_itemsize */
    /* methods */
    (destructor)tupleiter_dealloc,           /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)tupleiter_traverse,        /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)tupleiter_next,            /* tp_iternext */
    tupleiter_methods,                       /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

PyTypeObject PyList_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "list",
    sizeof(PyListObject),
    0,
    (destructor)list_dealloc,                                                                 /* tp_dealloc */
    0,                                                                                        /* tp_print */
    0,                                                                                        /* tp_getattr */
    0,                                                                                        /* tp_setattr */
    0,                                                                                        /* tp_reserved */
    (reprfunc)list_repr,                                                                      /* tp_repr */
    0,                                                                                        /* tp_as_number */
    &list_as_sequence,                                                                        /* tp_as_sequence */
    &list_as_mapping,                                                                         /* tp_as_mapping */
    PyObject_HashNotImplemented,                                                              /* tp_hash */
    0,                                                                                        /* tp_call */
    0,                                                                                        /* tp_str */
    PyObject_GenericGetAttr,                                                                  /* tp_getattro */
    0,                                                                                        /* tp_setattro */
    0,                                                                                        /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_LIST_SUBCLASS, /* tp_flags */
    list___init____doc__,                                                                     /* tp_doc */
    (traverseproc)list_traverse,                                                              /* tp_traverse */
    (inquiry)_list_clear,                                                                     /* tp_clear */
    list_richcompare,                                                                         /* tp_richcompare */
    0,                                                                                        /* tp_weaklistoffset */
    list_iter,                                                                                /* tp_iter */
    0,                                                                                        /* tp_iternext */
    list_methods,                                                                             /* tp_methods */
    0,                                                                                        /* tp_members */
    0,                                                                                        /* tp_getset */
    0,                                                                                        /* tp_base */
    0,                                                                                        /* tp_dict */
    0,                                                                                        /* tp_descr_get */
    0,                                                                                        /* tp_descr_set */
    0,                                                                                        /* tp_dictoffset */
    (initproc)list___init__,                                                                  /* tp_init */
    PyType_GenericAlloc,                                                                      /* tp_alloc */
    PyType_GenericNew,                                                                        /* tp_new */
    PyObject_GC_Del,                                                                          /* tp_free */
};

PyTypeObject PyListIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "list_iterator", /* tp_name */
    sizeof(listiterobject),                                 /* tp_basicsize */
    0,                                                      /* tp_itemsize */
    /* methods */
    (destructor)listiter_dealloc,            /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)listiter_traverse,         /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)listiter_next,             /* tp_iternext */
    listiter_methods,                        /* tp_methods */
    0,                                       /* tp_members */
    0,                                       /* tp_init */
    0,                                       /* tp_new */
};

PyTypeObject PyListRevIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "list_reverseiterator", /* tp_name */
    sizeof(listreviterobject),                                     /* tp_basicsize */
    0,                                                             /* tp_itemsize */
    /* methods */
    (destructor)listreviter_dealloc,         /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)listreviter_traverse,      /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)listreviter_next,          /* tp_iternext */
    listreviter_methods,                     /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

PyTypeObject PyDict_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "dict",
    sizeof(PyDictObject),
    0,
    (destructor)dict_dealloc,                                                                 /* tp_dealloc */
    0,                                                                                        /* tp_print */
    0,                                                                                        /* tp_getattr */
    0,                                                                                        /* tp_setattr */
    0,                                                                                        /* tp_reserved */
    (reprfunc)dict_repr,                                                                      /* tp_repr */
    0,                                                                                        /* tp_as_number */
    &dict_as_sequence,                                                                        /* tp_as_sequence */
    &dict_as_mapping,                                                                         /* tp_as_mapping */
    PyObject_HashNotImplemented,                                                              /* tp_hash */
    0,                                                                                        /* tp_call */
    0,                                                                                        /* tp_str */
    PyObject_GenericGetAttr,                                                                  /* tp_getattro */
    0,                                                                                        /* tp_setattro */
    0,                                                                                        /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_DICT_SUBCLASS, /* tp_flags */
    dictionary_doc,                                                                           /* tp_doc */
    dict_traverse,                                                                            /* tp_traverse */
    dict_tp_clear,                                                                            /* tp_clear */
    dict_richcompare,                                                                         /* tp_richcompare */
    0,                                                                                        /* tp_weaklistoffset */
    (getiterfunc)dict_iter,                                                                   /* tp_iter */
    0,                                                                                        /* tp_iternext */
    mapp_methods,                                                                             /* tp_methods */
    0,                                                                                        /* tp_members */
    0,                                                                                        /* tp_getset */
    0,                                                                                        /* tp_base */
    0,                                                                                        /* tp_dict */
    0,                                                                                        /* tp_descr_get */
    0,                                                                                        /* tp_descr_set */
    0,                                                                                        /* tp_dictoffset */
    dict_init,                                                                                /* tp_init */
    PyType_GenericAlloc,                                                                      /* tp_alloc */
    dict_new,                                                                                 /* tp_new */
    PyObject_GC_Del,                                                                          /* tp_free */
};

PyTypeObject PyDictIterKey_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "dict_keyiterator", /* tp_name */
    sizeof(dictiterobject),                                    /* tp_basicsize */
    0,                                                         /* tp_itemsize */
    /* methods */
    (destructor)dictiter_dealloc,            /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)dictiter_traverse,         /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)dictiter_iternextkey,      /* tp_iternext */
    dictiter_methods,                        /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

PyTypeObject PyDictIterValue_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "dict_valueiterator", /* tp_name */
    sizeof(dictiterobject),                                      /* tp_basicsize */
    0,                                                           /* tp_itemsize */
    /* methods */
    (destructor)dictiter_dealloc,            /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)dictiter_traverse,         /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)dictiter_iternextvalue,    /* tp_iternext */
    dictiter_methods,                        /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

PyTypeObject PyDictIterItem_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "dict_itemiterator", /* tp_name */
    sizeof(dictiterobject),                                     /* tp_basicsize */
    0,                                                          /* tp_itemsize */
    /* methods */
    (destructor)dictiter_dealloc,            /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)dictiter_traverse,         /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)dictiter_iternextitem,     /* tp_iternext */
    dictiter_methods,                        /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

PyTypeObject PyDictKeys_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "dict_keys", /* tp_name */
    sizeof(_PyDictViewObject),                          /* tp_basicsize */
    0,                                                  /* tp_itemsize */
    /* methods */
    (destructor)dictview_dealloc,            /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    (reprfunc)dictview_repr,                 /* tp_repr */
    &dictviews_as_number,                    /* tp_as_number */
    &dictkeys_as_sequence,                   /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)dictview_traverse,         /* tp_traverse */
    0,                                       /* tp_clear */
    dictview_richcompare,                    /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    (getiterfunc)dictkeys_iter,              /* tp_iter */
    0,                                       /* tp_iternext */
    dictkeys_methods,                        /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

PyTypeObject PyDictItems_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "dict_items", /* tp_name */
    sizeof(_PyDictViewObject),                           /* tp_basicsize */
    0,                                                   /* tp_itemsize */
    /* methods */
    (destructor)dictview_dealloc,            /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    (reprfunc)dictview_repr,                 /* tp_repr */
    &dictviews_as_number,                    /* tp_as_number */
    &dictitems_as_sequence,                  /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)dictview_traverse,         /* tp_traverse */
    0,                                       /* tp_clear */
    dictview_richcompare,                    /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    (getiterfunc)dictitems_iter,             /* tp_iter */
    0,                                       /* tp_iternext */
    dictitems_methods,                       /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

PyTypeObject PyDictValues_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "dict_values", /* tp_name */
    sizeof(_PyDictViewObject),                            /* tp_basicsize */
    0,                                                    /* tp_itemsize */
    /* methods */
    (destructor)dictview_dealloc,            /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    (reprfunc)dictview_repr,                 /* tp_repr */
    0,                                       /* tp_as_number */
    &dictvalues_as_sequence,                 /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)dictview_traverse,         /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    (getiterfunc)dictvalues_iter,            /* tp_iter */
    0,                                       /* tp_iternext */
    dictvalues_methods,                      /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

// jumphere
PyTypeObject PySet_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "set", /* tp_name */
    sizeof(PySetObject),                          /* tp_basicsize */
    0,                                            /* tp_itemsize */
    /* methods */
    (destructor)set_dealloc,                                       /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    (reprfunc)set_repr,                                            /* tp_repr */
    &set_as_number,                                                /* tp_as_number */
    &set_as_sequence,                                              /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    PyObject_HashNotImplemented,                                   /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    PyObject_GenericGetAttr,                                       /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    set_doc,                                                       /* tp_doc */
    (traverseproc)set_traverse,                                    /* tp_traverse */
    (inquiry)set_clear_internal,                                   /* tp_clear */
    (richcmpfunc)set_richcompare,                                  /* tp_richcompare */
    offsetof(PySetObject, weakreflist),                            /* tp_weaklistoffset */
    (getiterfunc)set_iter,                                         /* tp_iter */
    0,                                                             /* tp_iternext */
    set_methods,                                                   /* tp_methods */
    0,                                                             /* tp_members */
    0,                                                             /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    0,                                                             /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    0,                                                             /* tp_dictoffset */
    (initproc)set_init,                                            /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    set_new,                                                       /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PyFrozenSet_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "frozenset", /* tp_name */
    sizeof(PySetObject),                                /* tp_basicsize */
    0,                                                  /* tp_itemsize */
    /* methods */
    (destructor)set_dealloc,                                       /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    (reprfunc)set_repr,                                            /* tp_repr */
    &frozenset_as_number,                                          /* tp_as_number */
    &set_as_sequence,                                              /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    frozenset_hash,                                                /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    PyObject_GenericGetAttr,                                       /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    frozenset_doc,                                                 /* tp_doc */
    (traverseproc)set_traverse,                                    /* tp_traverse */
    (inquiry)set_clear_internal,                                   /* tp_clear */
    (richcmpfunc)set_richcompare,                                  /* tp_richcompare */
    offsetof(PySetObject, weakreflist),                            /* tp_weaklistoffset */
    (getiterfunc)set_iter,                                         /* tp_iter */
    0,                                                             /* tp_iternext */
    frozenset_methods,                                             /* tp_methods */
    0,                                                             /* tp_members */
    0,                                                             /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    0,                                                             /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    0,                                                             /* tp_dictoffset */
    0,                                                             /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    frozenset_new,                                                 /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PySetIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "set_iterator", /* tp_name */
    sizeof(setiterobject),                                 /* tp_basicsize */
    0,                                                     /* tp_itemsize */
    /* methods */
    (destructor)setiter_dealloc,             /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)setiter_traverse,          /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)setiter_iternext,          /* tp_iternext */
    setiter_methods,                         /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

PyTypeObject PyRange_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "range", /* Name of this type */
    sizeof(rangeobject),                            /* Basic object size */
    0,                                              /* Item size for varobject */
    (destructor)range_dealloc,                      /* tp_dealloc */
    0,                                              /* tp_print */
    0,                                              /* tp_getattr */
    0,                                              /* tp_setattr */
    0,                                              /* tp_reserved */
    (reprfunc)range_repr,                           /* tp_repr */
    &range_as_number,                               /* tp_as_number */
    &range_as_sequence,                             /* tp_as_sequence */
    &range_as_mapping,                              /* tp_as_mapping */
    (hashfunc)range_hash,                           /* tp_hash */
    0,                                              /* tp_call */
    0,                                              /* tp_str */
    PyObject_GenericGetAttr,                        /* tp_getattro */
    0,                                              /* tp_setattro */
    0,                                              /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT,                             /* tp_flags */
    range_doc,                                      /* tp_doc */
    0,                                              /* tp_traverse */
    0,                                              /* tp_clear */
    range_richcompare,                              /* tp_richcompare */
    0,                                              /* tp_weaklistoffset */
    range_iter,                                     /* tp_iter */
    0,                                              /* tp_iternext */
    range_methods,                                  /* tp_methods */
    range_members,                                  /* tp_members */
    0,                                              /* tp_getset */
    0,                                              /* tp_base */
    0,                                              /* tp_dict */
    0,                                              /* tp_descr_get */
    0,                                              /* tp_descr_set */
    0,                                              /* tp_dictoffset */
    0,                                              /* tp_init */
    0,                                              /* tp_alloc */
    range_new,                                      /* tp_new */
};

PyTypeObject PyRangeIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "range_iterator", /* tp_name */
    sizeof(rangeiterobject),                                 /* tp_basicsize */
    0,                                                       /* tp_itemsize */
    /* methods */
    (destructor)PyObject_Del,     /* tp_dealloc */
    0,                            /* tp_print */
    0,                            /* tp_getattr */
    0,                            /* tp_setattr */
    0,                            /* tp_reserved */
    0,                            /* tp_repr */
    0,                            /* tp_as_number */
    0,                            /* tp_as_sequence */
    0,                            /* tp_as_mapping */
    0,                            /* tp_hash */
    0,                            /* tp_call */
    0,                            /* tp_str */
    PyObject_GenericGetAttr,      /* tp_getattro */
    0,                            /* tp_setattro */
    0,                            /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT,           /* tp_flags */
    0,                            /* tp_doc */
    0,                            /* tp_traverse */
    0,                            /* tp_clear */
    0,                            /* tp_richcompare */
    0,                            /* tp_weaklistoffset */
    PyObject_SelfIter,            /* tp_iter */
    (iternextfunc)rangeiter_next, /* tp_iternext */
    rangeiter_methods,            /* tp_methods */
    0,                            /* tp_members */
    0,                            /* tp_init */
    0,                            /* tp_new */
};

PyTypeObject PyLongRangeIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "longrange_iterator", /* tp_name */
    sizeof(longrangeiterobject),                                 /* tp_basicsize */
    0,                                                           /* tp_itemsize */
    /* methods */
    (destructor)longrangeiter_dealloc, /* tp_dealloc */
    0,                                 /* tp_print */
    0,                                 /* tp_getattr */
    0,                                 /* tp_setattr */
    0,                                 /* tp_reserved */
    0,                                 /* tp_repr */
    0,                                 /* tp_as_number */
    0,                                 /* tp_as_sequence */
    0,                                 /* tp_as_mapping */
    0,                                 /* tp_hash */
    0,                                 /* tp_call */
    0,                                 /* tp_str */
    PyObject_GenericGetAttr,           /* tp_getattro */
    0,                                 /* tp_setattro */
    0,                                 /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT,                /* tp_flags */
    0,                                 /* tp_doc */
    0,                                 /* tp_traverse */
    0,                                 /* tp_clear */
    0,                                 /* tp_richcompare */
    0,                                 /* tp_weaklistoffset */
    PyObject_SelfIter,                 /* tp_iter */
    (iternextfunc)longrangeiter_next,  /* tp_iternext */
    longrangeiter_methods,             /* tp_methods */
    0,                                 /* tp_init */
    0,                                 /* tp_new */
    0,
};

PyTypeObject PyEnum_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "enumerate", /* tp_name */
    sizeof(enumobject),                                 /* tp_basicsize */
    0,                                                  /* tp_itemsize */
    /* methods */
    (destructor)enum_dealloc,                                      /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    0,                                                             /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    PyObject_GenericGetAttr,                                       /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    enum_new__doc__,                                               /* tp_doc */
    (traverseproc)enum_traverse,                                   /* tp_traverse */
    0,                                                             /* tp_clear */
    0,                                                             /* tp_richcompare */
    0,                                                             /* tp_weaklistoffset */
    PyObject_SelfIter,                                             /* tp_iter */
    (iternextfunc)enum_next,                                       /* tp_iternext */
    enum_methods,                                                  /* tp_methods */
    0,                                                             /* tp_members */
    0,                                                             /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    0,                                                             /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    0,                                                             /* tp_dictoffset */
    0,                                                             /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    enum_new,                                                      /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PyReversed_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "reversed", /* tp_name */
    sizeof(reversedobject),                            /* tp_basicsize */
    0,                                                 /* tp_itemsize */
    /* methods */
    (destructor)reversed_dealloc,                                  /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    0,                                                             /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    PyObject_GenericGetAttr,                                       /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    reversed_new__doc__,                                           /* tp_doc */
    (traverseproc)reversed_traverse,                               /* tp_traverse */
    0,                                                             /* tp_clear */
    0,                                                             /* tp_richcompare */
    0,                                                             /* tp_weaklistoffset */
    PyObject_SelfIter,                                             /* tp_iter */
    (iternextfunc)reversed_next,                                   /* tp_iternext */
    reversediter_methods,                                          /* tp_methods */
    0,                                                             /* tp_members */
    0,                                                             /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    0,                                                             /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    0,                                                             /* tp_dictoffset */
    0,                                                             /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    reversed_new,                                                  /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PySlice_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "slice", /* Name of this type */
    sizeof(PySliceObject),                          /* Basic object size */
    0,                                              /* Item size for varobject */
    (destructor)slice_dealloc,                      /* tp_dealloc */
    0,                                              /* tp_print */
    0,                                              /* tp_getattr */
    0,                                              /* tp_setattr */
    0,                                              /* tp_reserved */
    (reprfunc)slice_repr,                           /* tp_repr */
    0,                                              /* tp_as_number */
    0,                                              /* tp_as_sequence */
    0,                                              /* tp_as_mapping */
    PyObject_HashNotImplemented,                    /* tp_hash */
    0,                                              /* tp_call */
    0,                                              /* tp_str */
    PyObject_GenericGetAttr,                        /* tp_getattro */
    0,                                              /* tp_setattro */
    0,                                              /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC,        /* tp_flags */
    slice_doc,                                      /* tp_doc */
    (traverseproc)slice_traverse,                   /* tp_traverse */
    0,                                              /* tp_clear */
    slice_richcompare,                              /* tp_richcompare */
    0,                                              /* tp_weaklistoffset */
    0,                                              /* tp_iter */
    0,                                              /* tp_iternext */
    slice_methods,                                  /* tp_methods */
    slice_members,                                  /* tp_members */
    0,                                              /* tp_getset */
    0,                                              /* tp_base */
    0,                                              /* tp_dict */
    0,                                              /* tp_descr_get */
    0,                                              /* tp_descr_set */
    0,                                              /* tp_dictoffset */
    0,                                              /* tp_init */
    0,                                              /* tp_alloc */
    slice_new,                                      /* tp_new */
};

PyTypeObject PySeqIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "iterator", /* tp_name */
    sizeof(seqiterobject),                             /* tp_basicsize */
    0,                                                 /* tp_itemsize */
    /* methods */
    (destructor)iter_dealloc,                /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)iter_traverse,             /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    iter_iternext,                           /* tp_iternext */
    seqiter_methods,                         /* tp_methods */
    0,                                       /* tp_members */
    0,                                       /* tp_init */
    0,                                       /* tp_new */
};

PyTypeObject PyCallIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "callable_iterator", /* tp_name */
    sizeof(calliterobject),                                     /* tp_basicsize */
    0,                                                          /* tp_itemsize */
    /* methods */
    (destructor)calliter_dealloc,            /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)calliter_traverse,         /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)calliter_iternext,         /* tp_iternext */
    calliter_methods,                        /* tp_methods */
    0,                                       /* tp_init */
    0,                                       /* tp_new */
};

static PyTypeObject _PyExc_BaseException = {
    PyVarObject_HEAD_INIT(NULL, 0) "BaseException",                                               /*tp_name*/
    sizeof(PyBaseExceptionObject),                                                                /*tp_basicsize*/
    0,                                                                                            /*tp_itemsize*/
    (destructor)BaseException_dealloc,                                                            /*tp_dealloc*/
    0,                                                                                            /*tp_print*/
    0,                                                                                            /*tp_getattr*/
    0,                                                                                            /*tp_setattr*/
    0,                                                                                            /* tp_reserved; */
    (reprfunc)BaseException_repr,                                                                 /*tp_repr*/
    0,                                                                                            /*tp_as_number*/
    0,                                                                                            /*tp_as_sequence*/
    0,                                                                                            /*tp_as_mapping*/
    0,                                                                                            /*tp_hash */
    0,                                                                                            /*tp_call*/
    (reprfunc)BaseException_str,                                                                  /*tp_str*/
    PyObject_GenericGetAttr,                                                                      /*tp_getattro*/
    PyObject_GenericSetAttr,                                                                      /*tp_setattro*/
    0,                                                                                            /*tp_as_buffer*/
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASE_EXC_SUBCLASS, /*tp_flags*/
    PyDoc_STR("Common base class for all exceptions"),                                            /* tp_doc */
    (traverseproc)BaseException_traverse,                                                         /* tp_traverse */
    (inquiry)BaseException_clear,                                                                 /* tp_clear */
    0,                                                                                            /* tp_richcompare */
    0,                                                                                            /* tp_weaklistoffset */
    0,                                                                                            /* tp_iter */
    0,                                                                                            /* tp_iternext */
    BaseException_methods,                                                                        /* tp_methods */
    BaseException_members,                                                                        /* tp_members */
    BaseException_getset,                                                                         /* tp_getset */
    0,                                                                                            /* tp_base */
    0,                                                                                            /* tp_dict */
    0,                                                                                            /* tp_descr_get */
    0,                                                                                            /* tp_descr_set */
    offsetof(PyBaseExceptionObject, dict),                                                        /* tp_dictoffset */
    (initproc)BaseException_init,                                                                 /* tp_init */
    0,                                                                                            /* tp_alloc */
    BaseException_new,                                                                            /* tp_new */
};
PyTypeObject PyType_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "type",                                            /* tp_name */
    sizeof(PyHeapTypeObject),                                                                 /* tp_basicsize */
    sizeof(PyMemberDef),                                                                      /* tp_itemsize */
    (destructor)type_dealloc,                                                                 /* tp_dealloc */
    0,                                                                                        /* tp_print */
    0,                                                                                        /* tp_getattr */
    0,                                                                                        /* tp_setattr */
    0,                                                                                        /* tp_reserved */
    (reprfunc)type_repr,                                                                      /* tp_repr */
    0,                                                                                        /* tp_as_number */
    0,                                                                                        /* tp_as_sequence */
    0,                                                                                        /* tp_as_mapping */
    0,                                                                                        /* tp_hash */
    (ternaryfunc)type_call,                                                                   /* tp_call */
    0,                                                                                        /* tp_str */
    (getattrofunc)type_getattro,                                                              /* tp_getattro */
    (setattrofunc)type_setattro,                                                              /* tp_setattro */
    0,                                                                                        /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_TYPE_SUBCLASS, /* tp_flags */
    type_doc,                                                                                 /* tp_doc */
    (traverseproc)type_traverse,                                                              /* tp_traverse */
    (inquiry)type_clear,                                                                      /* tp_clear */
    0,                                                                                        /* tp_richcompare */
    offsetof(PyTypeObject, tp_weaklist),                                                      /* tp_weaklistoffset */
    0,                                                                                        /* tp_iter */
    0,                                                                                        /* tp_iternext */
    type_methods,                                                                             /* tp_methods */
    type_members,                                                                             /* tp_members */
    type_getsets,                                                                             /* tp_getset */
    0,                                                                                        /* tp_base */
    0,                                                                                        /* tp_dict */
    0,                                                                                        /* tp_descr_get */
    0,                                                                                        /* tp_descr_set */
    offsetof(PyTypeObject, tp_dict),                                                          /* tp_dictoffset */
    type_init,                                                                                /* tp_init */
    0,                                                                                        /* tp_alloc */
    type_new,                                                                                 /* tp_new */
    PyObject_GC_Del,                                                                          /* tp_free */
    (inquiry)type_is_gc,                                                                      /* tp_is_gc */
};

PyTypeObject PyBaseObject_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "object", /* tp_name */
    sizeof(PyObject),                                /* tp_basicsize */
    0,                                               /* tp_itemsize */
    object_dealloc,                                  /* tp_dealloc */
    0,                                               /* tp_print */
    0,                                               /* tp_getattr */
    0,                                               /* tp_setattr */
    0,                                               /* tp_reserved */
    object_repr,                                     /* tp_repr */
    0,                                               /* tp_as_number */
    0,                                               /* tp_as_sequence */
    0,                                               /* tp_as_mapping */
    (hashfunc)_Py_HashPointer,                       /* tp_hash */
    0,                                               /* tp_call */
    object_str,                                      /* tp_str */
    PyObject_GenericGetAttr,                         /* tp_getattro */
    PyObject_GenericSetAttr,                         /* tp_setattro */
    0,                                               /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE,        /* tp_flags */
    PyDoc_STR("object()\n--\n\nThe most base type"), /* tp_doc */
    0,                                               /* tp_traverse */
    0,                                               /* tp_clear */
    object_richcompare,                              /* tp_richcompare */
    0,                                               /* tp_weaklistoffset */
    0,                                               /* tp_iter */
    0,                                               /* tp_iternext */
    object_methods,                                  /* tp_methods */
    0,                                               /* tp_members */
    object_getsets,                                  /* tp_getset */
    0,                                               /* tp_base */
    0,                                               /* tp_dict */
    0,                                               /* tp_descr_get */
    0,                                               /* tp_descr_set */
    0,                                               /* tp_dictoffset */
    object_init,                                     /* tp_init */
    PyType_GenericAlloc,                             /* tp_alloc */
    object_new,                                      /* tp_new */
    PyObject_Del,                                    /* tp_free */
};

PyTypeObject PySuper_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "super", /* tp_name */
    sizeof(superobject),                            /* tp_basicsize */
    0,                                              /* tp_itemsize */
    /* methods */
    super_dealloc,                                                 /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    super_repr,                                                    /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    super_getattro,                                                /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    super_doc,                                                     /* tp_doc */
    super_traverse,                                                /* tp_traverse */
    0,                                                             /* tp_clear */
    0,                                                             /* tp_richcompare */
    0,                                                             /* tp_weaklistoffset */
    0,                                                             /* tp_iter */
    0,                                                             /* tp_iternext */
    0,                                                             /* tp_methods */
    super_members,                                                 /* tp_members */
    0,                                                             /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    super_descr_get,                                               /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    0,                                                             /* tp_dictoffset */
    super_init,                                                    /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    PyType_GenericNew,                                             /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};
// TODO: Add genobject.c

PyTypeObject PyFilter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "filter", /* tp_name */
    sizeof(filterobject),                            /* tp_basicsize */
    0,                                               /* tp_itemsize */
    /* methods */
    (destructor)filter_dealloc,                                    /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    0,                                                             /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    PyObject_GenericGetAttr,                                       /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    filter_doc,                                                    /* tp_doc */
    (traverseproc)filter_traverse,                                 /* tp_traverse */
    0,                                                             /* tp_clear */
    0,                                                             /* tp_richcompare */
    0,                                                             /* tp_weaklistoffset */
    PyObject_SelfIter,                                             /* tp_iter */
    (iternextfunc)filter_next,                                     /* tp_iternext */
    filter_methods,                                                /* tp_methods */
    0,                                                             /* tp_members */
    0,                                                             /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    0,                                                             /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    0,                                                             /* tp_dictoffset */
    0,                                                             /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    filter_new,                                                    /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PyMap_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "map", /* tp_name */
    sizeof(mapobject),                            /* tp_basicsize */
    0,                                            /* tp_itemsize */
    /* methods */
    (destructor)map_dealloc,                                       /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    0,                                                             /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    PyObject_GenericGetAttr,                                       /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    map_doc,                                                       /* tp_doc */
    (traverseproc)map_traverse,                                    /* tp_traverse */
    0,                                                             /* tp_clear */
    0,                                                             /* tp_richcompare */
    0,                                                             /* tp_weaklistoffset */
    PyObject_SelfIter,                                             /* tp_iter */
    (iternextfunc)map_next,                                        /* tp_iternext */
    map_methods,                                                   /* tp_methods */
    0,                                                             /* tp_members */
    0,                                                             /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    0,                                                             /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    0,                                                             /* tp_dictoffset */
    0,                                                             /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    map_new,                                                       /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PyZip_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "zip", /* tp_name */
    sizeof(zipobject),                            /* tp_basicsize */
    0,                                            /* tp_itemsize */
    /* methods */
    (destructor)zip_dealloc,                                       /* tp_dealloc */
    0,                                                             /* tp_print */
    0,                                                             /* tp_getattr */
    0,                                                             /* tp_setattr */
    0,                                                             /* tp_reserved */
    0,                                                             /* tp_repr */
    0,                                                             /* tp_as_number */
    0,                                                             /* tp_as_sequence */
    0,                                                             /* tp_as_mapping */
    0,                                                             /* tp_hash */
    0,                                                             /* tp_call */
    0,                                                             /* tp_str */
    PyObject_GenericGetAttr,                                       /* tp_getattro */
    0,                                                             /* tp_setattro */
    0,                                                             /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /* tp_flags */
    zip_doc,                                                       /* tp_doc */
    (traverseproc)zip_traverse,                                    /* tp_traverse */
    0,                                                             /* tp_clear */
    0,                                                             /* tp_richcompare */
    0,                                                             /* tp_weaklistoffset */
    PyObject_SelfIter,                                             /* tp_iter */
    (iternextfunc)zip_next,                                        /* tp_iternext */
    zip_methods,                                                   /* tp_methods */
    0,                                                             /* tp_members */
    0,                                                             /* tp_getset */
    0,                                                             /* tp_base */
    0,                                                             /* tp_dict */
    0,                                                             /* tp_descr_get */
    0,                                                             /* tp_descr_set */
    0,                                                             /* tp_dictoffset */
    0,                                                             /* tp_init */
    PyType_GenericAlloc,                                           /* tp_alloc */
    zip_new,                                                       /* tp_new */
    PyObject_GC_Del,                                               /* tp_free */
};

PyTypeObject PyStdPrinter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "stderrprinter", /* tp_name */
    sizeof(PyStdPrinter_Object),                            /* tp_basicsize */
    0,                                                      /* tp_itemsize */
    /* methods */
    0,                         /* tp_dealloc */
    0,                         /* tp_print */
    0,                         /* tp_getattr */
    0,                         /* tp_setattr */
    0,                         /* tp_reserved */
    (reprfunc)stdprinter_repr, /* tp_repr */
    0,                         /* tp_as_number */
    0,                         /* tp_as_sequence */
    0,                         /* tp_as_mapping */
    0,                         /* tp_hash */
    0,                         /* tp_call */
    0,                         /* tp_str */
    PyObject_GenericGetAttr,   /* tp_getattro */
    0,                         /* tp_setattro */
    0,                         /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT,        /* tp_flags */
    0,                         /* tp_doc */
    0,                         /* tp_traverse */
    0,                         /* tp_clear */
    0,                         /* tp_richcompare */
    0,                         /* tp_weaklistoffset */
    0,                         /* tp_iter */
    0,                         /* tp_iternext */
    stdprinter_methods,        /* tp_methods */
    0,                         /* tp_members */
    stdprinter_getsetlist,     /* tp_getset */
    0,                         /* tp_base */
    0,                         /* tp_dict */
    0,                         /* tp_descr_get */
    0,                         /* tp_descr_set */
    0,                         /* tp_dictoffset */
    stdprinter_init,           /* tp_init */
    PyType_GenericAlloc,       /* tp_alloc */
    stdprinter_new,            /* tp_new */
    PyObject_Del,              /* tp_free */
};

PyTypeObject PyFrame_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "frame",
    sizeof(PyFrameObject),
    sizeof(PyObject *),
    (destructor)frame_dealloc,               /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    (reprfunc)frame_repr,                    /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    PyObject_GenericSetAttr,                 /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)frame_traverse,            /* tp_traverse */
    (inquiry)frame_tp_clear,                 /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    0,                                       /* tp_iter */
    0,                                       /* tp_iternext */
    frame_methods,                           /* tp_methods */
    frame_memberlist,                        /* tp_members */
    frame_getsetlist,                        /* tp_getset */
    0,                                       /* tp_base */
    0,                                       /* tp_dict */
    0,                                       /* tp_init */
    0,                                       /* tp_new */
};

PyTypeObject _PyManagedBuffer_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "managedbuffer",
    sizeof(_PyManagedBufferObject),
    0,
    (destructor)mbuf_dealloc,                /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)mbuf_traverse,             /* tp_traverse */
    (inquiry)mbuf_clear                      /* tp_clear */
    0,                                       /* tp_init */
    0,                                       /* tp_new */
};

PyTypeObject PyMemoryView_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "memoryview", /* tp_name */
    offsetof(PyMemoryViewObject, ob_array),              /* tp_basicsize */
    sizeof(Py_ssize_t),                                  /* tp_itemsize */
    (destructor)memory_dealloc,                          /* tp_dealloc */
    0,                                                   /* tp_print */
    0,                                                   /* tp_getattr */
    0,                                                   /* tp_setattr */
    0,                                                   /* tp_reserved */
    (reprfunc)memory_repr,                               /* tp_repr */
    0,                                                   /* tp_as_number */
    &memory_as_sequence,                                 /* tp_as_sequence */
    &memory_as_mapping,                                  /* tp_as_mapping */
    (hashfunc)memory_hash,                               /* tp_hash */
    0,                                                   /* tp_call */
    0,                                                   /* tp_str */
    PyObject_GenericGetAttr,                             /* tp_getattro */
    0,                                                   /* tp_setattro */
    &memory_as_buffer,                                   /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC,             /* tp_flags */
    memory_doc,                                          /* tp_doc */
    (traverseproc)memory_traverse,                       /* tp_traverse */
    (inquiry)memory_clear,                               /* tp_clear */
    memory_richcompare,                                  /* tp_richcompare */
    offsetof(PyMemoryViewObject, weakreflist),           /* tp_weaklistoffset */
    0,                                                   /* tp_iter */
    0,                                                   /* tp_iternext */
    memory_methods,                                      /* tp_methods */
    0,                                                   /* tp_members */
    memory_getsetlist,                                   /* tp_getset */
    0,                                                   /* tp_base */
    0,                                                   /* tp_dict */
    0,                                                   /* tp_descr_get */
    0,                                                   /* tp_descr_set */
    0,                                                   /* tp_dictoffset */
    0,                                                   /* tp_init */
    0,                                                   /* tp_alloc */
    memory_new,                                          /* tp_new */
};

PyTypeObject _PyWeakref_RefType = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "weakref",
    sizeof(PyWeakReference),
    0,
    weakref_dealloc,                                               /*tp_dealloc*/
    0,                                                             /*tp_print*/
    0,                                                             /*tp_getattr*/
    0,                                                             /*tp_setattr*/
    0,                                                             /*tp_reserved*/
    (reprfunc)weakref_repr,                                        /*tp_repr*/
    0,                                                             /*tp_as_number*/
    0,                                                             /*tp_as_sequence*/
    0,                                                             /*tp_as_mapping*/
    (hashfunc)weakref_hash,                                        /*tp_hash*/
    (ternaryfunc)weakref_call,                                     /*tp_call*/
    0,                                                             /*tp_str*/
    0,                                                             /*tp_getattro*/
    0,                                                             /*tp_setattro*/
    0,                                                             /*tp_as_buffer*/
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC | Py_TPFLAGS_BASETYPE, /*tp_flags*/
    0,                                                             /*tp_doc*/
    (traverseproc)gc_traverse,                                     /*tp_traverse*/
    (inquiry)gc_clear,                                             /*tp_clear*/
    (richcmpfunc)weakref_richcompare,                              /*tp_richcompare*/
    0,                                                             /*tp_weaklistoffset*/
    0,                                                             /*tp_iter*/
    0,                                                             /*tp_iternext*/
    0,                                                             /*tp_methods*/
    weakref_members,                                               /*tp_members*/
    0,                                                             /*tp_getset*/
    0,                                                             /*tp_base*/
    0,                                                             /*tp_dict*/
    0,                                                             /*tp_descr_get*/
    0,                                                             /*tp_descr_set*/
    0,                                                             /*tp_dictoffset*/
    weakref___init__,                                              /*tp_init*/
    PyType_GenericAlloc,                                           /*tp_alloc*/
    weakref___new__,                                               /*tp_new*/
    PyObject_GC_Del,                                               /*tp_free*/
};

PyTypeObject _PyWeakref_ProxyType = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "weakproxy",
    sizeof(PyWeakReference),
    0,
    /* methods */
    (destructor)proxy_dealloc,               /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    (reprfunc)proxy_repr,                    /* tp_repr */
    &proxy_as_number,                        /* tp_as_number */
    &proxy_as_sequence,                      /* tp_as_sequence */
    &proxy_as_mapping,                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    proxy_str,                               /* tp_str */
    proxy_getattr,                           /* tp_getattro */
    (setattrofunc)proxy_setattr,             /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)gc_traverse,               /* tp_traverse */
    (inquiry)gc_clear,                       /* tp_clear */
    proxy_richcompare,                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    (getiterfunc)proxy_iter,                 /* tp_iter */
    (iternextfunc)proxy_iternext,            /* tp_iternext */
    proxy_methods,                           /* tp_methods */
    0,                                       /* tp_init */
    0,                                       /* tp_new */
};

PyTypeObject _PyWeakref_CallableProxyType = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "weakcallableproxy",
    sizeof(PyWeakReference),
    0,
    /* methods */
    (destructor)proxy_dealloc,               /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    (unaryfunc)proxy_repr,                   /* tp_repr */
    &proxy_as_number,                        /* tp_as_number */
    &proxy_as_sequence,                      /* tp_as_sequence */
    &proxy_as_mapping,                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    proxy_call,                              /* tp_call */
    proxy_str,                               /* tp_str */
    proxy_getattr,                           /* tp_getattro */
    (setattrofunc)proxy_setattr,             /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)gc_traverse,               /* tp_traverse */
    (inquiry)gc_clear,                       /* tp_clear */
    proxy_richcompare,                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    (getiterfunc)proxy_iter,                 /* tp_iter */
    (iternextfunc)proxy_iternext,            /* tp_iternext */
    0,                                       /* tp_init */
    0,                                       /* tp_new */
};

PyTypeObject PySTEntry_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "symtable entry",
    sizeof(PySTEntryObject),
    0,
    (destructor)ste_dealloc, /* tp_dealloc */
    0,                       /* tp_print */
    0,                       /* tp_getattr */
    0,                       /* tp_setattr */
    0,                       /* tp_reserved */
    (reprfunc)ste_repr,      /* tp_repr */
    0,                       /* tp_as_number */
    0,                       /* tp_as_sequence */
    0,                       /* tp_as_mapping */
    0,                       /* tp_hash */
    0,                       /* tp_call */
    0,                       /* tp_str */
    PyObject_GenericGetAttr, /* tp_getattro */
    0,                       /* tp_setattro */
    0,                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT,      /* tp_flags */
    0,                       /* tp_doc */
    0,                       /* tp_traverse */
    0,                       /* tp_clear */
    0,                       /* tp_richcompare */
    0,                       /* tp_weaklistoffset */
    0,                       /* tp_iter */
    0,                       /* tp_iternext */
    0,                       /* tp_methods */
    ste_memberlist,          /* tp_members */
    0,                       /* tp_getset */
    0,                       /* tp_base */
    0,                       /* tp_dict */
    0,                       /* tp_descr_get */
    0,                       /* tp_descr_set */
    0,                       /* tp_dictoffset */
    0,                       /* tp_init */
    0,                       /* tp_alloc */
    0,                       /* tp_new */
};

PyTypeObject PyTraceBack_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "traceback",
    sizeof(PyTracebackObject),
    0,
    (destructor)tb_dealloc,                  /*tp_dealloc*/
    0,                                       /*tp_print*/
    0,                                       /*tp_getattr*/
    0,                                       /*tp_setattr*/
    0,                                       /*tp_reserved*/
    0,                                       /*tp_repr*/
    0,                                       /*tp_as_number*/
    0,                                       /*tp_as_sequence*/
    0,                                       /*tp_as_mapping*/
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    tb_new__doc__,                           /* tp_doc */
    (traverseproc)tb_traverse,               /* tp_traverse */
    (inquiry)tb_clear,                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    0,                                       /* tp_iter */
    0,                                       /* tp_iternext */
    tb_methods,                              /* tp_methods */
    tb_memberlist,                           /* tp_members */
    tb_getsetters,                           /* tp_getset */
    0,                                       /* tp_base */
    0,                                       /* tp_dict */
    0,                                       /* tp_descr_get */
    0,                                       /* tp_descr_set */
    0,                                       /* tp_dictoffset */
    0,                                       /* tp_init */
    0,                                       /* tp_alloc */
    tb_new,                                  /* tp_new */
};
PyTypeObject PyUnicode_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "str", /* tp_name */
    sizeof(PyUnicodeObject),                      /* tp_size */
    0,                                            /* tp_itemsize */
    /* Slots */
    (destructor)unicode_dealloc,                                            /* tp_dealloc */
    0,                                                                      /* tp_print */
    0,                                                                      /* tp_getattr */
    0,                                                                      /* tp_setattr */
    0,                                                                      /* tp_reserved */
    unicode_repr,                                                           /* tp_repr */
    &unicode_as_number,                                                     /* tp_as_number */
    &unicode_as_sequence,                                                   /* tp_as_sequence */
    &unicode_as_mapping,                                                    /* tp_as_mapping */
    (hashfunc)unicode_hash,                                                 /* tp_hash*/
    0,                                                                      /* tp_call*/
    (reprfunc)unicode_str,                                                  /* tp_str */
    PyObject_GenericGetAttr,                                                /* tp_getattro */
    0,                                                                      /* tp_setattro */
    0,                                                                      /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_UNICODE_SUBCLASS, /* tp_flags */
    unicode_doc,                                                            /* tp_doc */
    0,                                                                      /* tp_traverse */
    0,                                                                      /* tp_clear */
    PyUnicode_RichCompare,                                                  /* tp_richcompare */
    0,                                                                      /* tp_weaklistoffset */
    unicode_iter,                                                           /* tp_iter */
    0,                                                                      /* tp_iternext */
    unicode_methods,                                                        /* tp_methods */
    0,                                                                      /* tp_members */
    0,                                                                      /* tp_getset */
    &PyBaseObject_Type,                                                     /* tp_base */
    0,                                                                      /* tp_dict */
    0,                                                                      /* tp_descr_get */
    0,                                                                      /* tp_descr_set */
    0,                                                                      /* tp_dictoffset */
    0,                                                                      /* tp_init */
    0,                                                                      /* tp_alloc */
    unicode_new,                                                            /* tp_new */
    PyObject_Del,                                                           /* tp_free */
};

PyTypeObject PyUnicodeIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "str_iterator", /* tp_name */
    sizeof(unicodeiterobject),                             /* tp_basicsize */
    0,                                                     /* tp_itemsize */
    /* methods */
    (destructor)unicodeiter_dealloc,         /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)unicodeiter_traverse,      /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)unicodeiter_next,          /* tp_iternext */
    unicodeiter_methods,                     /* tp_methods */
    0,                                       /* tp_init */
    0,                                       /* tp_new */
    0,
};

static PyTypeObject EncodingMapType = {
    PyVarObject_HEAD_INIT(NULL, 0) "EncodingMap", /*tp_name*/
    sizeof(struct encoding_map),                  /*tp_basicsize*/
    0,                                            /*tp_itemsize*/
    /* methods */
    encoding_map_dealloc, /*tp_dealloc*/
    0,                    /*tp_print*/
    0,                    /*tp_getattr*/
    0,                    /*tp_setattr*/
    0,                    /*tp_reserved*/
    0,                    /*tp_repr*/
    0,                    /*tp_as_number*/
    0,                    /*tp_as_sequence*/
    0,                    /*tp_as_mapping*/
    0,                    /*tp_hash*/
    0,                    /*tp_call*/
    0,                    /*tp_str*/
    0,                    /*tp_getattro*/
    0,                    /*tp_setattro*/
    0,                    /*tp_as_buffer*/
    Py_TPFLAGS_DEFAULT,   /*tp_flags*/
    0,                    /*tp_doc*/
    0,                    /*tp_traverse*/
    0,                    /*tp_clear*/
    0,                    /*tp_richcompare*/
    0,                    /*tp_weaklistoffset*/
    0,                    /*tp_iter*/
    0,                    /*tp_iternext*/
    encoding_map_methods, /*tp_methods*/
    0,                    /*tp_members*/
    0,                    /*tp_getset*/
    0,                    /*tp_base*/
    0,                    /*tp_dict*/
    0,                    /*tp_descr_get*/
    0,                    /*tp_descr_set*/
    0,                    /*tp_dictoffset*/
    0,                    /*tp_init*/
    0,                    /*tp_alloc*/
    0,                    /*tp_new*/
    0,                    /*tp_free*/
    0,                    /*tp_is_gc*/
};

PyTypeObject PyByteArray_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "bytearray",
    sizeof(PyByteArrayObject),
    0,
    (destructor)bytearray_dealloc,            /* tp_dealloc */
    0,                                        /* tp_print */
    0,                                        /* tp_getattr */
    0,                                        /* tp_setattr */
    0,                                        /* tp_reserved */
    (reprfunc)bytearray_repr,                 /* tp_repr */
    &bytearray_as_number,                     /* tp_as_number */
    &bytearray_as_sequence,                   /* tp_as_sequence */
    &bytearray_as_mapping,                    /* tp_as_mapping */
    0,                                        /* tp_hash */
    0,                                        /* tp_call */
    bytearray_str,                            /* tp_str */
    PyObject_GenericGetAttr,                  /* tp_getattro */
    0,                                        /* tp_setattro */
    &bytearray_as_buffer,                     /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE, /* tp_flags */
    bytearray_doc,                            /* tp_doc */
    0,                                        /* tp_traverse */
    0,                                        /* tp_clear */
    (richcmpfunc)bytearray_richcompare,       /* tp_richcompare */
    0,                                        /* tp_weaklistoffset */
    bytearray_iter,                           /* tp_iter */
    0,                                        /* tp_iternext */
    bytearray_methods,                        /* tp_methods */
    0,                                        /* tp_members */
    0,                                        /* tp_getset */
    0,                                        /* tp_base */
    0,                                        /* tp_dict */
    0,                                        /* tp_descr_get */
    0,                                        /* tp_descr_set */
    0,                                        /* tp_dictoffset */
    (initproc)bytearray_init,                 /* tp_init */
    PyType_GenericAlloc,                      /* tp_alloc */
    PyType_GenericNew,                        /* tp_new */
    PyObject_Del,                             /* tp_free */
};

PyTypeObject PyByteArrayIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "bytearray_iterator", /* tp_name */
    sizeof(bytesiterobject),                                     /* tp_basicsize */
    0,                                                           /* tp_itemsize */
    /* methods */
    (destructor)bytearrayiter_dealloc,       /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)bytearrayiter_traverse,    /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)bytearrayiter_next,        /* tp_iternext */
    bytearrayiter_methods,                   /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};

PyTypeObject PyBytes_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "bytes",
    PyBytesObject_SIZE,
    sizeof(char),
    bytes_dealloc,                                                        /* tp_dealloc */
    0,                                                                    /* tp_print */
    0,                                                                    /* tp_getattr */
    0,                                                                    /* tp_setattr */
    0,                                                                    /* tp_reserved */
    (reprfunc)bytes_repr,                                                 /* tp_repr */
    &bytes_as_number,                                                     /* tp_as_number */
    &bytes_as_sequence,                                                   /* tp_as_sequence */
    &bytes_as_mapping,                                                    /* tp_as_mapping */
    (hashfunc)bytes_hash,                                                 /* tp_hash */
    0,                                                                    /* tp_call */
    bytes_str,                                                            /* tp_str */
    PyObject_GenericGetAttr,                                              /* tp_getattro */
    0,                                                                    /* tp_setattro */
    &bytes_as_buffer,                                                     /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_BYTES_SUBCLASS, /* tp_flags */
    bytes_doc,                                                            /* tp_doc */
    0,                                                                    /* tp_traverse */
    0,                                                                    /* tp_clear */
    (richcmpfunc)bytes_richcompare,                                       /* tp_richcompare */
    0,                                                                    /* tp_weaklistoffset */
    bytes_iter,                                                           /* tp_iter */
    0,                                                                    /* tp_iternext */
    bytes_methods,                                                        /* tp_methods */
    0,                                                                    /* tp_members */
    0,                                                                    /* tp_getset */
    &PyBaseObject_Type,                                                   /* tp_base */
    0,                                                                    /* tp_dict */
    0,                                                                    /* tp_descr_get */
    0,                                                                    /* tp_descr_set */
    0,                                                                    /* tp_dictoffset */
    0,                                                                    /* tp_init */
    0,                                                                    /* tp_alloc */
    bytes_new,                                                            /* tp_new */
    PyObject_Del,                                                         /* tp_free */
};

PyTypeObject PyBytesIter_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "bytes_iterator", /* tp_name */
    sizeof(striterobject),                                   /* tp_basicsize */
    0,                                                       /* tp_itemsize */
    /* methods */
    (destructor)striter_dealloc,             /* tp_dealloc */
    0,                                       /* tp_print */
    0,                                       /* tp_getattr */
    0,                                       /* tp_setattr */
    0,                                       /* tp_reserved */
    0,                                       /* tp_repr */
    0,                                       /* tp_as_number */
    0,                                       /* tp_as_sequence */
    0,                                       /* tp_as_mapping */
    0,                                       /* tp_hash */
    0,                                       /* tp_call */
    0,                                       /* tp_str */
    PyObject_GenericGetAttr,                 /* tp_getattro */
    0,                                       /* tp_setattro */
    0,                                       /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_HAVE_GC, /* tp_flags */
    0,                                       /* tp_doc */
    (traverseproc)striter_traverse,          /* tp_traverse */
    0,                                       /* tp_clear */
    0,                                       /* tp_richcompare */
    0,                                       /* tp_weaklistoffset */
    PyObject_SelfIter,                       /* tp_iter */
    (iternextfunc)striter_next,              /* tp_iternext */
    striter_methods,                         /* tp_methods */
    0,
    0, /* tp_init */
    0, /* tp_new */
};
