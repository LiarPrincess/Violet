// This file contains CPython type definitions for errors.

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
