// This file contains CPython type definitions for objects related to code
// (functions, module, property etc.).

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
    (destructor)cm_dealloc, /* tp_dealloc */
    0,                      /* tp_print */
    0,                      /* tp_getattr */
    0,                      /* tp_setattr */
    0,                      /* tp_reserved */
    0,                      /* tp_repr */
    0,                      /* tp_as_number */
    0,                      /* tp_as_sequence */
    0,                      /* tp_as_mapping */
    0,                      /* tp_hash */
    0,                      /* tp_call */
    0,                      /* tp_str */
    0,                      /* tp_getattro */
    0,                      /* tp_setattro */
    0,                      /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC,
    classmethod_doc,                /* tp_doc */
    (traverseproc)cm_traverse,      /* tp_traverse */
    (inquiry)cm_clear,              /* tp_clear */
    0,                              /* tp_richcompare */
    0,                              /* tp_weaklistoffset */
    0,                              /* tp_iter */
    0,                              /* tp_iternext */
    0,                              /* tp_methods */
    cm_memberlist,                  /* tp_members */
    cm_getsetlist,                  /* tp_getset */
    0,                              /* tp_base */
    0,                              /* tp_dict */
    cm_descr_get,                   /* tp_descr_get */
    0,                              /* tp_descr_set */
    offsetof(classmethod, cm_dict), /* tp_dictoffset */
    cm_init,                        /* tp_init */
    PyType_GenericAlloc,            /* tp_alloc */
    PyType_GenericNew,              /* tp_new */
    PyObject_GC_Del,                /* tp_free */
};

PyTypeObject PyStaticMethod_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "staticmethod",
    sizeof(staticmethod),
    0,
    (destructor)sm_dealloc, /* tp_dealloc */
    0,                      /* tp_print */
    0,                      /* tp_getattr */
    0,                      /* tp_setattr */
    0,                      /* tp_reserved */
    0,                      /* tp_repr */
    0,                      /* tp_as_number */
    0,                      /* tp_as_sequence */
    0,                      /* tp_as_mapping */
    0,                      /* tp_hash */
    0,                      /* tp_call */
    0,                      /* tp_str */
    0,                      /* tp_getattro */
    0,                      /* tp_setattro */
    0,                      /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC,
    staticmethod_doc,                /* tp_doc */
    (traverseproc)sm_traverse,       /* tp_traverse */
    (inquiry)sm_clear,               /* tp_clear */
    0,                               /* tp_richcompare */
    0,                               /* tp_weaklistoffset */
    0,                               /* tp_iter */
    0,                               /* tp_iternext */
    0,                               /* tp_methods */
    sm_memberlist,                   /* tp_members */
    sm_getsetlist,                   /* tp_getset */
    0,                               /* tp_base */
    0,                               /* tp_dict */
    sm_descr_get,                    /* tp_descr_get */
    0,                               /* tp_descr_set */
    offsetof(staticmethod, sm_dict), /* tp_dictoffset */
    sm_init,                         /* tp_init */
    PyType_GenericAlloc,             /* tp_alloc */
    PyType_GenericNew,               /* tp_new */
    PyObject_GC_Del,                 /* tp_free */
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
