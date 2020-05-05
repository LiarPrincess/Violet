# import os

# VIOLET: We do not have 'os' module, but we implemented our own 'basename' in 'import_file'

from import_file import import_file, basename

import_file()

assert basename(__file__) == "builtin_file.py"
