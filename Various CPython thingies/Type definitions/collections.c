// This file contains CPython type definitions for collections.

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
};
