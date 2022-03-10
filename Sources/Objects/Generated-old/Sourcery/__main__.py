import sys
import os.path

# This is for testing
# It will run 'get_types' (with validation)

if __name__ == '__main__':
    current_dir_path = os.path.abspath(os.path.dirname(__file__))
    parent_dir_path = os.path.dirname(current_dir_path)
    sys.path.append(current_dir_path)
    sys.path.append(parent_dir_path)

    from Sourcery.get_types import get_types

    types = get_types()
    print('Finished')
