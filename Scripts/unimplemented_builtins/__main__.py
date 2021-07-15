import enum
from typing import List, NamedTuple, Set

from get_python_type import PythonType, PythonEntry, get_python_type
from get_implemented_types import ImplementedType, get_implemented_types


# ============
# === Diff ===
# ============


DIFF_IGNORED = [
    # Those things are implemented on 'object' and then propagated downstream.
    # We have them on 'object' and we don't need them on every possible subclass.
    '__init_subclass__', '__subclasshook__',
    # Pickle
    '__reduce__', '__reduce_ex__',
    # Pickle (probably)
    '__getnewargs__',
    # Iterator methods
    '__setstate__',
    # CPython implementation detail
    '__sizeof__',
]


class SetDiff(NamedTuple):
    ok: List[str]
    missing: List[PythonEntry]
    extra: List[str]


def diff_sets(implemented: Set[str], expected: Set[PythonEntry]) -> SetDiff:
    ok: List[str] = []
    extra: List[PythonEntry] = []

    for i in implemented:
        if i in DIFF_IGNORED:
            continue

        is_expected = i in expected
        if is_expected:
            ok.append(i)
        else:
            extra.append(i)

    missing: List[PythonEntry] = []
    for e in expected:
        if e in DIFF_IGNORED:
            continue

        is_implemented = e in implemented
        if not is_implemented:
            missing.append(e)

    result = SetDiff(ok, missing, extra)
    return result


class Diff(NamedTuple):
    missing: List[PythonEntry]
    extra: List[str]


def diff_types(implemented: ImplementedType, expected: PythonType) -> Diff:
    implemented_names = set()
    implemented_names.update(implemented.property_names)
    implemented_names.update(implemented.method_names)
    implemented_names.update(implemented.static_function_names)
    implemented_names.update(implemented.class_function_names)

    if implemented.has__doc__:
        implemented_names.add('__doc__')

    names_diff = diff_sets(implemented_names, expected.names)

    names_diff.missing.sort()
    names_diff.extra.sort()
    result = Diff(names_diff.missing, names_diff.extra)
    return result


# ============
# === Main ===
# ============

if __name__ == '__main__':
    implemented_types = get_implemented_types()

    for implemented_type in implemented_types:
        name = implemented_type.name
        if name == 'cell':
            # 'cell' is not available in Python (it is only in CPython).
            # So we will skip it.
            continue

        python_type = get_python_type(name)
        diff = diff_types(implemented_type, python_type)

        no_missing = len(diff.missing) == 0
        no_extra = len(diff.extra) == 0
        if no_missing and no_extra:
            continue

        print(name)
        if diff.missing:
            print('  Missing:')
            for n in diff.missing:
                print(f'    {n.name}')

        if diff.extra:
            print('  This should not be here:')
            for n in diff.extra:
                print(f'    {n}')

        print()