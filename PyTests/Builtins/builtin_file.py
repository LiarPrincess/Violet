from import_file import import_file, basename

import_file()

assert basename(__file__) == "builtin_file.py"
