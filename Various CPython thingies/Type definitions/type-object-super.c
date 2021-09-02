// This file contains CPython type definitions for type, object and super.

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
