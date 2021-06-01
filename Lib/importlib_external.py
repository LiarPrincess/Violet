# cSpell:ignore smsl PYTHONCASEOK

SOURCE_SUFFIXES = ['.py']

# Bootstrap-related code ######################################################
_CASE_INSENSITIVE_PLATFORMS_STR_KEY = 'win',
_CASE_INSENSITIVE_PLATFORMS_BYTES_KEY = 'cygwin', 'darwin'
_CASE_INSENSITIVE_PLATFORMS = (_CASE_INSENSITIVE_PLATFORMS_BYTES_KEY
                               + _CASE_INSENSITIVE_PLATFORMS_STR_KEY)


def _make_relax_case():
    def _relax_case():
        """True if filenames must be checked case-insensitively."""
        return False
    return _relax_case


def _path_join(*path_parts):
    """Replacement for os.path.join()."""
    parts_to_join = []
    for part in path_parts:
        if part:
            parts_to_join.append(part.rstrip(path_separators))

    return path_sep.join(parts_to_join)


def _path_split(path):
    """Replacement for os.path.split()."""
    if len(path_separators) == 1:
        front, _, tail = path.rpartition(path_sep)
        return front, tail

    for x in reversed(path):
        if x in path_separators:
            front, tail = path.rsplit(x, maxsplit=1)
            return front, tail

    return '', path


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


def _path_isfile(path):
    """Replacement for os.path.isfile."""
    return _path_is_mode_type(path, 0o100000)


def _path_isdir(path):
    """Replacement for os.path.isdir."""
    if not path:
        path = _os.getcwd()

    return _path_is_mode_type(path, 0o040000)

# Finder/loader utility code ###############################################


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

# Module specifications #######################################################


_POPULATE = object()


def spec_from_file_location(name, location=None, *, loader=None,
                            submodule_search_locations=_POPULATE):
    """Return a module spec based on a file location.

    To indicate that the module is a package, set
    submodule_search_locations to a list of directory paths.  An
    empty list is sufficient, though its not otherwise useful to the
    import system.

    The loader must take a spec as its only __init__() arg.

    """
    if location is None:
        # The caller may simply want a partially populated location-
        # oriented spec.  So we set the location to a bogus value and
        # fill in as much as we can.
        location = '<unknown>'
        if hasattr(loader, 'get_filename'):
            # ExecutionLoader
            try:
                location = loader.get_filename(name)
            except ImportError:
                pass
    else:
        location = _os.fspath(location)

    # If the location is on the filesystem, but doesn't actually exist,
    # we could return None here, indicating that the location is not
    # valid.  However, we don't have a good way of testing since an
    # indirect location (e.g. a zip file or URL) will look like a
    # non-existent file relative to the filesystem.

    spec = _bootstrap.ModuleSpec(name, loader, origin=location)
    spec._set_fileattr = True

    # Pick a loader if one wasn't provided.
    if loader is None:
        for loader_class, suffixes in _get_supported_file_loaders():
            if location.endswith(tuple(suffixes)):
                loader = loader_class(name, location)
                spec.loader = loader
                break
        else:
            return None

    # Set submodule_search_paths appropriately.
    if submodule_search_locations is _POPULATE:
        # Check the loader.
        if hasattr(loader, 'is_package'):
            try:
                is_package = loader.is_package(name)
            except ImportError:
                pass
            else:
                if is_package:
                    spec.submodule_search_locations = []
    else:
        spec.submodule_search_locations = submodule_search_locations

    if spec.submodule_search_locations == []:
        if location:
            dirname = _path_split(location)[0]
            spec.submodule_search_locations.append(dirname)

    return spec

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
        # VIOLET: We do not have '_io.FileIO', so we will use 'builtins.open'
        with open(path, 'r') as file:
            return file.read()

    def source_to_code(self, data, path, *, _optimize=-1):
        """Return the code object compiled from source.

        The 'data' argument can be any object type that compile() supports.
        """
        return _bootstrap._call_with_frames_removed(compile, data, path, 'exec',
                                                    dont_inherit=True, optimize=_optimize)


class _NamespacePath:
    """Represents a namespace package's path.  It uses the module name
    to find its parent module, and from there it looks up the parent's
    __path__.  When this changes, the module's own path is recomputed,
    using path_finder.  For top-level modules, the parent module's path
    is sys.path."""

    def __init__(self, name, path, path_finder):
        self._name = name
        self._path = path
        self._last_parent_path = tuple(self._get_parent_path())
        self._path_finder = path_finder

    def _find_parent_path_names(self):
        """Returns a tuple of (parent-module-name, parent-path-attr-name)"""
        parent, dot, me = self._name.rpartition('.')

        if dot == '':
            # This is a top-level module. sys.path contains the parent path.
            return 'sys', 'path'

        # Not a top-level module. parent-module.__path__ contains the
        #  parent path.
        return parent, '__path__'

    def _get_parent_path(self):
        parent_module_name, path_attr_name = self._find_parent_path_names()
        return getattr(sys.modules[parent_module_name], path_attr_name)

    def _recalculate(self):
        # If the parent's path has changed, recalculate _path
        parent_path = tuple(self._get_parent_path())  # Make a copy

        if parent_path != self._last_parent_path:
            spec = self._path_finder(self._name, parent_path)
            # Note that no changes are made if a loader is returned, but we
            #  do remember the new parent path
            if spec is not None and spec.loader is None:
                if spec.submodule_search_locations:
                    self._path = spec.submodule_search_locations
            self._last_parent_path = parent_path     # Save the copy

        return self._path

    def __iter__(self):
        return iter(self._recalculate())

    def __setitem__(self, index, path):
        self._path[index] = path

    def __len__(self):
        return len(self._recalculate())

    def __repr__(self):
        return f'_NamespacePath({self._path!r})'

    def __contains__(self, item):
        return item in self._recalculate()

    def append(self, item):
        self._path.append(item)

# Finders #####################################################################


class PathFinder:

    """Meta path finder for sys.path and package __path__ attributes."""

    @classmethod
    def _path_hooks(cls, path):
        """Search sys.path_hooks for a finder for 'path'."""
        if sys.path_hooks is not None and not sys.path_hooks:
            _warnings.warn('sys.path_hooks is empty', ImportWarning)

        for hook in sys.path_hooks:
            try:
                return hook(path)
            except ImportError:
                continue
        else:
            return None

    @classmethod
    def _path_importer_cache(cls, path):
        """Get the finder for the path entry from sys.path_importer_cache.

        If the path entry is not in the cache, find the appropriate finder
        and cache it. If no finder is available, store None.

        """
        if path == '':
            try:
                path = _os.getcwd()
            except FileNotFoundError:
                # Don't cache the failure as the cwd can easily change to
                # a valid directory later on.
                return None

        try:
            finder = sys.path_importer_cache[path]
        except KeyError:
            finder = cls._path_hooks(path)
            sys.path_importer_cache[path] = finder

        return finder

    @classmethod
    def _get_spec(cls, fullname, path, target=None):
        """Find the loader or namespace_path for this module/package name."""
        # If this ends up being a namespace package, namespace_path is
        #  the list of paths that will become its __path__
        namespace_path = []
        for entry in path:
            if not isinstance(entry, (str, bytes)):
                continue

            finder = cls._path_importer_cache(entry)
            if finder is not None:
                if hasattr(finder, 'find_spec'):
                    spec = finder.find_spec(fullname, target)

                if spec is None:
                    continue

                if spec.loader is not None:
                    return spec

                portions = spec.submodule_search_locations
                if portions is None:
                    raise ImportError('spec missing loader')

                # This is possibly part of a namespace package.
                #  Remember these path entries (if any) for when we
                #  create a namespace package, and continue iterating
                #  on path.
                namespace_path.extend(portions)
        else:
            spec = _bootstrap.ModuleSpec(fullname, None)
            spec.submodule_search_locations = namespace_path
            return spec

    @classmethod
    def find_spec(cls, fullname, path=None, target=None):
        """Try to find a spec for 'fullname' on sys.path or 'path'.

        The search is based on sys.path_hooks and sys.path_importer_cache.
        """

        if path is None:
            path = sys.path

        spec = cls._get_spec(fullname, path, target)

        if spec is None:
            return None
        elif spec.loader is None:
            namespace_path = spec.submodule_search_locations
            if namespace_path:
                # We found at least one namespace path.
                # Return a spec which can create the namespace package.
                spec.origin = None
                spec.submodule_search_locations = _NamespacePath(fullname, namespace_path, cls._get_spec)
                return spec
            else:
                return None
        else:
            return spec


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
            # VIOLET: Manual loop since we do not support comprehensions
            for suffix in suffixes:
                loaders.append((suffix, loader))

        self._loaders = loaders
        # Base (directory) path
        self.path = path or '.'
        self._path_mtime = -1
        self._path_cache = set()
        self._relaxed_path_cache = set()

    def _get_spec(self, loader_class, fullname, path, smsl, target):
        loader = loader_class(fullname, path)
        return spec_from_file_location(fullname, path, loader=loader,
                                       submodule_search_locations=smsl)

    def find_spec(self, fullname, target=None):
        """Try to find a spec for the specified module.

        Returns the matching spec, or None if not found.
        """
        is_namespace = False
        tail_module = fullname.rpartition('.')[2]

        try:
            mtime = _path_stat(self.path or _os.getcwd()).st_mtime
        except OSError:
            mtime = -1

        if mtime != self._path_mtime:
            self._fill_cache()
            self._path_mtime = mtime

        # tail_module keeps the original casing, for __file__ and friends
        if _relax_case():
            cache = self._relaxed_path_cache
            cache_module = tail_module.lower()
        else:
            cache = self._path_cache
            cache_module = tail_module

        # Check if the module is the name of a directory (and thus a package).
        if cache_module in cache:
            base_path = _path_join(self.path, tail_module)
            for suffix, loader_class in self._loaders:
                init_filename = '__init__' + suffix
                full_path = _path_join(base_path, init_filename)
                if _path_isfile(full_path):
                    return self._get_spec(loader_class, fullname, full_path, [base_path], target)
            else:
                # If a namespace package, return the path if we don't
                #  find a module in the next section.
                is_namespace = _path_isdir(base_path)

        # Check for a file w/ a proper suffix exists.
        for suffix, loader_class in self._loaders:
            full_path = _path_join(self.path, tail_module + suffix)
            _bootstrap._verbose_message(f'trying {full_path}', verbosity=2)
            if cache_module + suffix in cache:
                if _path_isfile(full_path):
                    return self._get_spec(loader_class, fullname, full_path, None, target)

        if is_namespace:
            _bootstrap._verbose_message(f'possible namespace for {base_path}')
            spec = _bootstrap.ModuleSpec(fullname, None)
            spec.submodule_search_locations = [base_path]
            return spec

        return None

    def _fill_cache(self):
        """Fill the cache of potential modules and packages for this directory."""
        path = self.path
        try:
            contents = _os.listdir(path or _os.getcwd())
        except (FileNotFoundError, PermissionError, NotADirectoryError):
            # Directory has either been removed, turned into a file, or made
            # unreadable.
            contents = []

        # We store two cached versions, to handle runtime changes of the
        # PYTHONCASEOK environment variable.
        if not sys.platform.startswith('win'):
            self._path_cache = set(contents)
        else:
            # Windows users can import modules with case-insensitive file
            # suffixes (for legacy reasons). Make the suffix lowercase here
            # so it's done once instead of for every import. This is safe as
            # the specified suffixes to check against are always specified in a
            # case-sensitive manner.
            lower_suffix_contents = set()
            for item in contents:
                name, dot, suffix = item.partition('.')
                if dot:
                    new_name = f'{name}.{suffix.lower()}'
                else:
                    new_name = name
                lower_suffix_contents.add(new_name)
            self._path_cache = lower_suffix_contents

        if sys.platform.startswith(_CASE_INSENSITIVE_PLATFORMS):
            self._relaxed_path_cache = set(map(lambda fn: fn.lower(), contents))

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

    def __repr__(self):
        return f'FileFinder({self.path!r})'

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

    # VIOLET: Inject this module as '_bootstrap_external' in 'importlib'.
    # CPython does this in in 'importlib._install_external_importers'
    # But since we don't support forzen modules we have to do it here:
    _bootstrap._bootstrap_external = self_module


def _install(_bootstrap_module):
    """Install the path-based import components."""
    _setup(_bootstrap_module)
    supported_loaders = _get_supported_file_loaders()

    sys.path_hooks.extend([FileFinder.path_hook(*supported_loaders)])
    sys.meta_path.append(PathFinder)
