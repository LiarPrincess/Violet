import sys
import os
import os.path
import importlib.util
from typing import List, Set, NamedTuple


def get_repository_root_path(marker: str = 'Sources') -> str:
    # 'this_file' is something like:
    # /THINGS/Violet/Scripts/unimplemented_builtins/__main__.py
    this_file = __file__

    current_dir = os.path.dirname(this_file)
    while True:
        if current_dir == '/':
            raise ValueError(f"Unable to find repository root with marker '{marker}'")

        child_nodes = os.listdir(current_dir)
        for node in child_nodes:
            if node == marker:
                return current_dir

        current_dir = os.path.dirname(current_dir)


def get_types_from_objects_generated():
    repository_root_path = get_repository_root_path()

    generated_dir_path = os.path.join(repository_root_path, 'Sources', 'Objects', 'Generated')
    sys.path.append(generated_dir_path)

    module_name = 'get_types'
    module_path = os.path.join(generated_dir_path, 'Sourcery', 'TypeInfo_get.py')

    spec = importlib.util.spec_from_file_location(module_name, module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    result = module.get_types()
    return result


def get_python_names(values) -> Set[str]:
    result = set()
    for v in values:
        result.add(v.python_name)

    return result


class ImplementedType(NamedTuple):
    name: str
    has__doc__: bool
    property_names: Set[str]
    method_names: Set[str]
    static_function_names: Set[str]
    class_function_names: Set[str]


def get_implemented_types() -> List[ImplementedType]:
    result = []
    sourcery_types = get_types_from_objects_generated()

    for t in sourcery_types:
        name = t.python_type_name
        has__doc__ = t.swift_static_doc_property is not None

        property_names = get_python_names(t.python_properties)
        if '__doc__' in property_names:
            has__doc__ = True
            property_names.remove('__doc__')

        method_names = get_python_names(t.python_methods)
        static_function_names = get_python_names(t.python_static_functions)
        class_function_names = get_python_names(t.python_class_functions)

        i = ImplementedType(name, has__doc__, property_names, method_names, static_function_names, class_function_names)
        result.append(i)

    return result
