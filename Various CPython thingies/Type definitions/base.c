// This file contains CPython type definitions from Violet 'basic' directory.

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
