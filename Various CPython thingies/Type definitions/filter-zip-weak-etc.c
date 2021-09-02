// This file contains CPython type definitions for filter, zip etc.
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

PyTypeObject
    _PyWeakref_RefType = {
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

PyTypeObject
    _PyWeakref_ProxyType = {
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
};

PyTypeObject
    _PyWeakref_CallableProxyType = {
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
