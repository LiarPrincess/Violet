// This file contains CPython type definitions for string/bytes.

PyTypeObject PyUnicode_Type = {
    PyVarObject_HEAD_INIT(&PyType_Type, 0) "str", /* tp_name */
    sizeof(PyUnicodeObject),                      /* tp_size */
    0,                                            /* tp_itemsize */
    /* Slots */
    (destructor)unicode_dealloc, /* tp_dealloc */
    0,                           /* tp_print */
    0,                           /* tp_getattr */
    0,                           /* tp_setattr */
    0,                           /* tp_reserved */
    unicode_repr,                /* tp_repr */
    &unicode_as_number,          /* tp_as_number */
    &unicode_as_sequence,        /* tp_as_sequence */
    &unicode_as_mapping,         /* tp_as_mapping */
    (hashfunc)unicode_hash,      /* tp_hash*/
    0,                           /* tp_call*/
    (reprfunc)unicode_str,       /* tp_str */
    PyObject_GenericGetAttr,     /* tp_getattro */
    0,                           /* tp_setattro */
    0,                           /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE |
        Py_TPFLAGS_UNICODE_SUBCLASS, /* tp_flags */
    unicode_doc,                     /* tp_doc */
    0,                               /* tp_traverse */
    0,                               /* tp_clear */
    PyUnicode_RichCompare,           /* tp_richcompare */
    0,                               /* tp_weaklistoffset */
    unicode_iter,                    /* tp_iter */
    0,                               /* tp_iternext */
    unicode_methods,                 /* tp_methods */
    0,                               /* tp_members */
    0,                               /* tp_getset */
    &PyBaseObject_Type,              /* tp_base */
    0,                               /* tp_dict */
    0,                               /* tp_descr_get */
    0,                               /* tp_descr_set */
    0,                               /* tp_dictoffset */
    0,                               /* tp_init */
    0,                               /* tp_alloc */
    unicode_new,                     /* tp_new */
    PyObject_Del,                    /* tp_free */
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
};
