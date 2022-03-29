import sys
import os
import os.path
import importlib.util


def get_types():
    module_name = 'get_types'
    module_path = os.path.join('Sourcery', 'TypeInfo_get.py')
    module = load_file_from_objects_generated(module_name, module_path)
    return module.get_types()


def get_static_methods():
    module_name = 'Static_methods'
    module_path = os.path.join('Helpers', 'StaticMethod.py')
    module = load_file_from_objects_generated(module_name, module_path)
    return module.ALL_STATIC_METHODS


def load_file_from_objects_generated(module_name: str, relative_path: str):
    repository_root_path = get_repository_root_path()

    generated_dir_path = os.path.join(repository_root_path, 'Sources', 'Objects', 'Generated')
    if generated_dir_path not in sys.path:
        sys.path.append(generated_dir_path)

    module_path = os.path.join(generated_dir_path, relative_path)

    spec = importlib.util.spec_from_file_location(module_name, module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    return module


def get_repository_root_path(marker: str = 'Sources') -> str:
    # 'this_file' is something like:
    # /THINGS/Violet/Scripts/unimplemented_builtins/__main__.py
    this_file = __file__

    current_dir = os.path.dirname(this_file)
    current_dir = os.path.abspath(current_dir)

    while True:
        if current_dir == '/':
            raise ValueError(f"Unable to find repository root with marker '{marker}'")

        child_nodes = os.listdir(current_dir)
        for node in child_nodes:
            if node == marker:
                return current_dir

        current_dir = os.path.dirname(current_dir)
