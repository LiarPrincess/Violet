# cSpell:ignore smsl

# Setup ######################################################################

def _setup(sys_module, _imp_module):
    """Setup importlib by importing needed built-in modules and injecting them
    into the global namespace.

    As sys is needed for sys.modules access and _imp is needed to load built-in
    modules, those two modules must be explicitly passed in.

    """
    global _imp, sys
    _imp = _imp_module
    sys = sys_module

    # Set up the spec for existing builtin/frozen modules.
    module_type = type(sys)
    for name, module in sys.modules.items():
        if isinstance(module, module_type):
            if name in sys.builtin_module_names:
                loader = BuiltinImporter
            else:
                continue

            spec = _spec_from_module(module, loader)
            _init_module_attrs(spec, module)

    # Directly load built-in modules needed during bootstrap.
    self_module = sys.modules[__name__]
    for builtin_name in ['_warnings']:
        if builtin_name not in sys.modules:
            builtin_module = _builtin_from_name(builtin_name)
        else:
            builtin_module = sys.modules[builtin_name]
        setattr(self_module, builtin_name, builtin_module)


def _builtin_from_name(name):
    spec = BuiltinImporter.find_spec(name)
    if spec is None:
        raise ImportError('no built-in module named ' + name)

    return _load_unlocked(spec)

# Bootstrap-related code ######################################################


def _wrap(new, old):
    """Simple substitute for functools.update_wrapper."""
    for replace in ['__module__', '__name__', '__qualname__', '__doc__']:
        if hasattr(old, replace):
            setattr(new, replace, getattr(old, replace))
    new.__dict__.update(old.__dict__)


def _new_module(name):
    return type(sys)(name)

# Frame stripping magic ###############################################


def _call_with_frames_removed(f, *args, **kwds):
    """remove_importlib_frames in import.c will always remove sequences
    of importlib frames that end with a call to this function

    Use it instead of a normal call in places where including the importlib
    frames introduces unwanted noise into the traceback (e.g. when executing
    module code)
    """
    return f(*args, **kwds)


def _requires_builtin(fxn):
    """Decorator to verify the named module is built-in."""

    def _requires_builtin_wrapper(self, fullname):
        if fullname not in sys.builtin_module_names:
            raise ImportError(f'{fullname!r} is not a built-in module', name=fullname)
        return fxn(self, fullname)
    _wrap(_requires_builtin_wrapper, fxn)
    return _requires_builtin_wrapper

# Module specifications #######################################################


def _verbose_message(message, verbosity=1):
    """Print the message to stderr if -v/PYTHONVERBOSE is turned on."""
    if sys.flags.verbose >= verbosity:
        if not message.startswith(('#', 'import ')):
            message = '# ' + message

        print(message, file=sys.stderr)


class _installed_safely:

    def __init__(self, module):
        self._module = module
        self._spec = module.__spec__

    def __enter__(self):
        # This must be done before putting the module in sys.modules
        # (otherwise an optimization shortcut in import.c becomes wrong)
        self._spec._initializing = True
        sys.modules[self._spec.name] = self._module

    def __exit__(self, *args):
        try:
            spec = self._spec
            # This was changed because Violet does not support comprehension
            if any(map(lambda arg: arg is not None, args)):
                try:
                    del sys.modules[spec.name]
                except KeyError:
                    pass
            else:
                _verbose_message(f'import {spec.name!r} # {spec.loader!r}')
        finally:
            self._spec._initializing = False


class ModuleSpec:
    """The specification for a module, used for loading.

    A module's spec is the source for information about the module.  For
    data associated with the module, including source, use the spec's
    loader.

    `name` is the absolute name of the module.
    `loader` is the loader to use when loading the module.
    `parent` is the name of the package the module is in.
    The parent is derived from the name.

    `is_package` determines if the module is considered a package or
    not.  On modules this is reflected by the `__path__` attribute.

    `origin` is the specific location used by the loader from which to
    load the module, if that information is available.  When filename is
    set, origin will match.

    `has_location` indicates that a spec's "origin" reflects a location.
    When this is True, `__file__` attribute of the module is set.

    `submodule_search_locations` is the sequence of path entries to
    search when importing submodules.  If set, is_package should be
    True--and False otherwise.

    Packages are simply modules that (may) have submodules.  If a spec
    has a non-None value in `submodule_search_locations`, the import
    system will consider modules loaded from the spec as packages.

    Only finders (see importlib.abc.MetaPathFinder and
    importlib.abc.PathEntryFinder) should modify ModuleSpec instances.

    """

    def __init__(self, name, loader, *, origin=None, loader_state=None,
                 is_package=None):
        self.name = name
        self.loader = loader
        self.origin = origin
        self.loader_state = loader_state
        self.submodule_search_locations = [] if is_package else None

        # file-location attributes
        self._set_fileattr = False

    def __repr__(self):
        args = [
            f'name={self.name!r}',
            f'loader={self.loader!r}'
        ]

        if self.origin is not None:
            args.append(f'origin={self.origin!r}')

        if self.submodule_search_locations is not None:
            args.append(f'submodule_search_locations={self.submodule_search_locations!r}')

        name = self.__class__.__name__
        args_string = ', '.join(args)
        return f'{name}({args_string})'

    def __eq__(self, other):
        smsl = self.submodule_search_locations
        try:
            return (self.name == other.name and
                    self.loader == other.loader and
                    self.origin == other.origin and
                    smsl == other.submodule_search_locations and
                    self.has_location == other.has_location)
        except AttributeError:
            return False

    @property
    def parent(self):
        """The name of the module's parent."""
        if self.submodule_search_locations is None:
            return self.name.rpartition('.')[0]
        else:
            return self.name

    @property
    def has_location(self):
        return self._set_fileattr

    @has_location.setter
    def has_location(self, value):
        self._set_fileattr = bool(value)


def _spec_from_module(module, loader=None, origin=None):
    # This function is meant for use in _setup().
    try:
        spec = module.__spec__
    except AttributeError:
        pass
    else:
        if spec is not None:
            return spec

    name = module.__name__
    if loader is None:
        try:
            loader = module.__loader__
        except AttributeError:
            # loader will stay None.
            pass

    try:
        location = module.__file__
    except AttributeError:
        location = None

    if origin is None:
        if location is None:
            try:
                origin = loader._ORIGIN
            except AttributeError:
                origin = None
        else:
            origin = location

    try:
        submodule_search_locations = list(module.__path__)
    except AttributeError:
        submodule_search_locations = None

    spec = ModuleSpec(name, loader, origin=origin)
    spec._set_fileattr = False if location is None else True
    spec.submodule_search_locations = submodule_search_locations
    return spec


def _init_module_attrs(spec, module, *, override=False):
    # The passed-in module may be not support attribute assignment,
    # in which case we simply don't set the attributes.

    # __name__
    if (override or getattr(module, '__name__', None) is None):
        try:
            module.__name__ = spec.name
        except AttributeError:
            pass

    # __loader__
    if override or getattr(module, '__loader__', None) is None:
        try:
            module.__loader__ = spec.loader
        except AttributeError:
            pass

    # __package__
    if override or getattr(module, '__package__', None) is None:
        try:
            module.__package__ = spec.parent
        except AttributeError:
            pass

    # __spec__
    try:
        module.__spec__ = spec
    except AttributeError:
        pass

    # __path__
    if override or getattr(module, '__path__', None) is None:
        if spec.submodule_search_locations is not None:
            try:
                module.__path__ = spec.submodule_search_locations
            except AttributeError:
                pass

    # __file__
    if spec.has_location:
        if override or getattr(module, '__file__', None) is None:
            try:
                module.__file__ = spec.origin
            except AttributeError:
                pass

    return module


def module_from_spec(spec):
    """Create a module based on the provided spec."""
    # Typically loaders will not implement create_module().
    module = None

    if hasattr(spec.loader, 'create_module'):
        # If create_module() returns `None` then it means default
        # module creation should be used.
        module = spec.loader.create_module(spec)
    elif hasattr(spec.loader, 'exec_module'):
        raise ImportError('loaders that define exec_module() must also define create_module()')

    if module is None:
        module = _new_module(spec.name)

    _init_module_attrs(spec, module)
    return module


def _load_backward_compatible(spec):
    # (issue19713) Once BuiltinImporter and ExtensionFileLoader
    # have exec_module() implemented, we can add a deprecation
    # warning here.
    spec.loader.load_module(spec.name)

    # The module must be in sys.modules at this point!
    module = sys.modules[spec.name]
    if getattr(module, '__loader__', None) is None:
        try:
            module.__loader__ = spec.loader
        except AttributeError:
            pass

    if getattr(module, '__package__', None) is None:
        try:
            # Since module.__path__ may not line up with
            # spec.submodule_search_paths, we can't necessarily rely
            # on spec.parent here.
            module.__package__ = module.__name__
            if not hasattr(module, '__path__'):
                module.__package__ = spec.name.rpartition('.')[0]
        except AttributeError:
            pass

    if getattr(module, '__spec__', None) is None:
        try:
            module.__spec__ = spec
        except AttributeError:
            pass

    return module


def _load_unlocked(spec):
    # A helper for direct use by the import system.
    if spec.loader is not None:
        # not a namespace package
        if not hasattr(spec.loader, 'exec_module'):
            return _load_backward_compatible(spec)

    module = module_from_spec(spec)
    with _installed_safely(module):
        if spec.loader is None:
            if spec.submodule_search_locations is None:
                raise ImportError('missing loader', name=spec.name)
            # A namespace package so do nothing.
        else:
            spec.loader.exec_module(module)

    # We don't ensure that the import-related module attributes get
    # set in the sys.modules replacement case.  Such modules are on
    # their own.
    return sys.modules[spec.name]

# Loaders #####################################################################


class BuiltinImporter:

    """Meta path import for built-in modules.

    All methods are either class or static methods to avoid the need to
    instantiate the class.

    """

    @classmethod
    def find_spec(cls, fullname, path=None, target=None):
        if path is not None:
            return None

        if _imp.is_builtin(fullname):
            return spec_from_loader(fullname, cls, origin='built-in')
        else:
            return None

    @classmethod
    def create_module(self, spec):
        """Create a built-in module"""
        if spec.name not in sys.builtin_module_names:
            raise ImportError(f'{spec.name!r} is not a built-in module', name=spec.name)
        return _call_with_frames_removed(_imp.create_builtin, spec)

    @classmethod
    def exec_module(self, module):
        """Exec a built-in module"""
        _call_with_frames_removed(_imp.exec_builtin, module)


def spec_from_loader(name, loader, *, origin=None, is_package=None):
    """Return a module spec based on various loader methods."""
    if hasattr(loader, 'get_filename'):
        if _bootstrap_external is None:
            raise NotImplementedError
        spec_from_file_location = _bootstrap_external.spec_from_file_location

        if is_package is None:
            return spec_from_file_location(name, loader=loader)

        search = [] if is_package else None
        return spec_from_file_location(name, loader=loader,
                                       submodule_search_locations=search)

    if is_package is None:
        if hasattr(loader, 'is_package'):
            try:
                is_package = loader.is_package(name)
            except ImportError:
                is_package = None  # aka, undefined
        else:
            # the default
            is_package = False

    return ModuleSpec(name, loader, origin=origin, is_package=is_package)

# Import itself ###############################################################


def import_module(name, package=None):
    """Import a module.

    The 'package' argument is required when performing a relative import. It
    specifies the package to use as the anchor point from which to resolve the
    relative import to an absolute import.

    """
    level = 0
    if name.startswith('.'):
        if not package:
            msg = f"the 'package' argument is required to perform a relative import for {name!r}"
            raise TypeError(msg)

        for character in name:
            if character != '.':
                break
            level += 1

    return _gcd_import(name[level:], package, level)


def _resolve_name(name, package, level):
    """Resolve a relative module name to an absolute one."""
    bits = package.rsplit('.', level - 1)
    if len(bits) < level:
        raise ValueError('attempted relative import beyond top-level package')

    base = bits[0]
    return f'{base}.{name}' if name else base


def _find_spec(name, path, target=None):
    """Find a module's spec."""
    meta_path = sys.meta_path
    if meta_path is None:
        # PyImport_Cleanup() is running or has been called.
        raise ImportError("sys.meta_path is None, Python is likely shutting down")

    if not meta_path:
        _warnings.warn('sys.meta_path is empty', ImportWarning)

    # We check sys.modules here for the reload case.  While a passed-in
    # target will usually indicate a reload there is no guarantee, whereas
    # sys.modules provides one.
    is_reload = name in sys.modules
    for finder in meta_path:
        try:
            find_spec = finder.find_spec
        except AttributeError:
            continue
        else:
            spec = find_spec(name, path, target)

        if spec is not None:
            # The parent import may have already imported this module.
            if not is_reload and name in sys.modules:
                module = sys.modules[name]
                try:
                    __spec__ = module.__spec__
                except AttributeError:
                    # We use the found spec since that is the one that
                    # we would have used if the parent module hadn't
                    # beaten us to the punch.
                    return spec
                else:
                    if __spec__ is None:
                        return spec
                    else:
                        return __spec__
            else:
                return spec
    else:
        return None


def _sanity_check(name, package, level):
    """Verify arguments are "sane"."""
    if not isinstance(name, str):
        raise TypeError(f'module name must be str, not {type(name)}')

    if level < 0:
        raise ValueError('level must be >= 0')

    if level > 0:
        if not isinstance(package, str):
            raise TypeError('__package__ not set to a string')
        elif not package:
            raise ImportError('attempted relative import with no known parent package')

    if not name and level == 0:
        raise ValueError('Empty module name')


def _find_and_load_unlocked(name, import_):
    path = None
    parent = name.rpartition('.')[0]

    if parent:
        if parent not in sys.modules:
            _call_with_frames_removed(import_, parent)

        # Crazy side-effects!
        if name in sys.modules:
            return sys.modules[name]

        parent_module = sys.modules[parent]
        try:
            path = parent_module.__path__
        except AttributeError:
            msg = f"No module named '{name!r}'; {parent!r} is not a package"
            raise ModuleNotFoundError(msg, name=name) from None

    spec = _find_spec(name, path)
    if spec is None:
        raise ModuleNotFoundError(f"No module named '{name}'", name=name)
    else:
        module = _load_unlocked(spec)

    if parent:
        # Set the module as an attribute on its parent.
        parent_module = sys.modules[parent]
        setattr(parent_module, name.rpartition('.')[2], module)

    return module


_NEEDS_LOADING = object()


def _find_and_load(name, import_):
    """Find and load the module."""
    module = sys.modules.get(name, _NEEDS_LOADING)
    if module is _NEEDS_LOADING:
        return _find_and_load_unlocked(name, import_)

    if module is None:
        message = (f'import of {name} halted; None in sys.modules')
        raise ModuleNotFoundError(message, name=name)

    return module


def _gcd_import(name, package=None, level=0):
    """Import and return the module based on its name, the package the call is
    being made from, and the level adjustment.

    This function represents the greatest common denominator of functionality
    between import_module and __import__. This includes setting __package__ if
    the loader did not.

    """
    _sanity_check(name, package, level)
    if level > 0:
        name = _resolve_name(name, package, level)
    return _find_and_load(name, _gcd_import)


def _handle_fromlist(module, fromlist, import_, *, recursive=False):
    """Figure out what __import__ should return.

    The import_ parameter is a callable which takes the name of module to
    import. It is required to decouple the function from assuming importlib's
    import implementation is desired.

    """
    # The hell that is fromlist ...
    # If a package was imported, try to import stuff from fromlist.
    if hasattr(module, '__path__'):
        for x in fromlist:
            if not isinstance(x, str):
                if recursive:
                    where = module.__name__ + '.__all__'
                else:
                    where = "``from list''"
                raise TypeError(f"Item in {where} must be str, not {type(x).__name__}")

            elif x == '*':
                if not recursive and hasattr(module, '__all__'):
                    _handle_fromlist(module, module.__all__, import_, recursive=True)

            elif not hasattr(module, x):
                from_name = f'{module.__name__}.{x}'
                try:
                    _call_with_frames_removed(import_, from_name)
                except ModuleNotFoundError as exc:
                    # Backwards-compatibility dictates we ignore failed
                    # imports triggered by fromlist for modules that don't exist.
                    if (exc.name == from_name and sys.modules.get(from_name, _NEEDS_LOADING) is not None):
                        continue
                    raise

    return module

# Main ########################################################################


def _install(sys_module, _imp_module):
    """Install importers for builtin modules"""
    _setup(sys_module, _imp_module)

    sys.meta_path.append(BuiltinImporter)
