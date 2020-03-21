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
    for builtin_name in ('_thread', '_warnings', '_weakref'):
        builtin_module = None
        setattr(self_module, builtin_name, builtin_module)

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

# Loaders #####################################################################

class BuiltinImporter:

    """Meta path import for built-in modules.

    All methods are either class or static methods to avoid the need to
    instantiate the class.

    """
    pass

# Main ########################################################################

def _install(sys_module, _imp_module):
    """Install importers for builtin modules"""
    _setup(sys_module, _imp_module)

    sys.meta_path.append(BuiltinImporter)
