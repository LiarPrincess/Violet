import sys
import os.path
import importlib.util


def import_file(file: str):
    '''
    Some of our modules have invalid names (for example: 'PyType+MemoryLayout') and cant be imported
    using standard Python methods.
    '''

    basename = os.path.basename(file)

    module_name = basename
    if module_name.endswith('.py'):
        module_name = module_name[:-3]

    for (existing_name, module) in sys.modules.items():
        if existing_name == module_name:
            return module

    # First 'path' is the directory that contains '__main__' file
    rootDir = sys.path[0]
    module_path = os.path.join(rootDir, file)

    spec = importlib.util.spec_from_file_location(module_name, module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    return module
