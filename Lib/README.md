# Lib

This directory is intended for Python modules (written in Python).

## Modules

- **`importlib.py` and `importlib_external.py`**

  Those modules responsible for… well… importing things. Original implementation can be found at [cpython/Lib/importlib](https://github.com/python/cpython/tree/master/Lib/importlib) (as `_bootstrap.py` and `_bootstrap_external.py`).

  Please note that we heavily modified both of those files (for example by removing comprehensions and formatted strings), but the class/function names stayed the same, so you can easily find the unmodified version.
