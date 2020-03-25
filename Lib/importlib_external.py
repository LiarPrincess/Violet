SOURCE_SUFFIXES = ['.py']

# Bootstrap-related code ######################################################

def _make_relax_case():
    def _relax_case():
        """True if filenames must be checked case-insensitively."""
        return False
    return _relax_case

def _check_name(method):
    """Decorator to verify that the module being requested matches the one the
    loader can handle.

    The first argument (self) must define _name which the second argument is
    compared against. If the comparison fails then ImportError is raised.

    """
    def _check_name_wrapper(self, name=None, *args, **kwargs):
        if name is None:
            name = self.name
        elif self.name != name:
            raise ImportError(f'loader for {self.name} cannot handle {name}', name=name)

        return method(self, name, *args, **kwargs)

    try:
        _wrap = _bootstrap._wrap
    except NameError:
        # XXX yuck
        def _wrap(new, old):
            for replace in ['__module__', '__name__', '__qualname__', '__doc__']:
                if hasattr(old, replace):
                    setattr(new, replace, getattr(old, replace))
            new.__dict__.update(old.__dict__)

    _wrap(_check_name_wrapper, method)
    return _check_name_wrapper

def _path_stat(path):
    """Stat the path.

    Made a separate function to make it easier to override in experiments
    (e.g. cache stat results).

    """
    return _os.stat(path)

def _path_is_mode_type(path, mode):
    """Test whether the path is the specified mode type."""
    try:
        stat_info = _path_stat(path)
    except OSError:
        return False
    return (stat_info.st_mode & 0o170000) == mode

def _path_isdir(path):
    """Replacement for os.path.isdir."""
    if not path:
        path = _os.getcwd()

    return _path_is_mode_type(path, 0o040000)

# Loaders #####################################################################

class SourceFileLoader:
    """Base file loader class which implements the loader protocol methods that
    require file system usage."""

    def __init__(self, fullname, path):
        """Cache the module name and the path to the file found by the
        finder."""
        self.name = fullname
        self.path = path

    def create_module(self, spec):
        """Use default semantics for module creation."""

    def exec_module(self, module):
        """Execute the module."""
        code = self.get_code(module.__name__)
        if code is None:
            raise ImportError(f'cannot load module {module.__name__!r} when get_code() returns None')

        _bootstrap._call_with_frames_removed(exec, code, module.__dict__)

    def get_code(self, fullname):
        """Concrete implementation of InspectLoader.get_code.

        Reading of bytecode requires path_stats to be implemented. To write
        bytecode, set_data must also be implemented.

        """
        source_path = self.get_filename(fullname)
        source_bytes = self.get_data(source_path)

        code_object = self.source_to_code(source_bytes, source_path)
        _bootstrap._verbose_message(f'code object from {source_path}')

        return code_object

    @_check_name
    def get_filename(self, fullname):
        """Return the path to the source file as found by the finder."""
        return self.path

    def get_data(self, path):
        """Return the data from path as raw bytes."""
        with _io.FileIO(path, 'r') as file:
            return file.read()

    def source_to_code(self, data, path, *, _optimize=-1):
        """Return the code object compiled from source.

        The 'data' argument can be any object type that compile() supports.
        """
        return _bootstrap._call_with_frames_removed(compile, data, path, 'exec',
                                        dont_inherit=True, optimize=_optimize)

# Finders #####################################################################

class PathFinder:

    """Meta path finder for sys.path and package __path__ attributes."""

    pass

class FileFinder:

    """File-based finder.

    Interactions with the file system are cached for performance, being
    refreshed when the directory the finder is handling has been modified.

    """

    def __init__(self, path, *loader_details):
        """Initialize with the path to search on and a variable number of
        2-tuples containing the loader and the file suffixes the loader
        recognizes."""
        loaders = []
        for loader, suffixes in loader_details:
          # Manual loop since Violet does not support comprehensions
          for suffix in suffixes:
            loaders.append((suffix, loader))

        self._loaders = loaders
        # Base (directory) path
        self.path = path or '.'
        self._path_mtime = -1
        self._path_cache = set()
        self._relaxed_path_cache = set()

    @classmethod
    def path_hook(cls, *loader_details):
        """A class method which returns a closure to use on sys.path_hook
        which will return an instance using the specified loaders and the path
        called on the closure.

        If the path called on the closure is not a directory, ImportError is
        raised.

        """
        def path_hook_for_FileFinder(path):
            """Path hook for importlib.machinery.FileFinder."""
            if not _path_isdir(path):
                raise ImportError('only directories are supported', path=path)

            return cls(path, *loader_details)

        return path_hook_for_FileFinder

# Import setup ###############################################################

def _get_supported_file_loaders():
    """Returns a list of file-based module loaders.

    Each item is a tuple (loader, suffixes).
    """
    source = SourceFileLoader, SOURCE_SUFFIXES
    return [source]

def _setup(_bootstrap_module):
    """Setup the path-based importers for importlib by importing needed
    built-in modules and injecting them into the global namespace.

    Other components are extracted from the core bootstrap module.

    """
    global sys, _imp, _bootstrap
    _bootstrap = _bootstrap_module
    sys = _bootstrap.sys
    _imp = _bootstrap._imp

    # Directly load built-in modules needed during bootstrap.
    self_module = sys.modules[__name__]
    for builtin_name in ('_os', '_warnings', 'builtins'):
        if builtin_name not in sys.modules:
            builtin_module = _bootstrap._builtin_from_name(builtin_name)
        else:
            builtin_module = sys.modules[builtin_name]
        setattr(self_module, builtin_name, builtin_module)

    # Directly load the os module (needed during bootstrap).
    if sys.platform == 'darwin' or sys.platform == 'linux':
      path_sep = '/'
      path_separators = ['/']
    elif sys.platform == 'win32':
      path_sep = '\\'
      path_separators = ['\\', '/']
    else:
      raise ImportError('importlib requires darwin, linux or win32')

    # 'os_module' was set before
    setattr(self_module, 'path_sep', path_sep)
    setattr(self_module, 'path_separators', ''.join(path_separators))

    # Constants
    setattr(self_module, '_relax_case', _make_relax_case())

def _install(_bootstrap_module):
    """Install the path-based import components."""
    _setup(_bootstrap_module)
    supported_loaders = _get_supported_file_loaders()

    sys.path_hooks.extend([FileFinder.path_hook(*supported_loaders)])
    sys.meta_path.append(PathFinder)
