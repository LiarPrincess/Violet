import os

# Imports in the correct order
SORTED_IMPORTS = [
    'import XCTest',
    'import Foundation',
    'import ArgumentParser',
    'import SwiftSyntax',

    'import LibAriel',
    'import BigInt',
    'import FileSystem',
    'import UnicodeData',
    'import VioletCore',
    'import VioletLexer',
    'import VioletParser',
    'import VioletBytecode',
    'import VioletCompiler',
    'import VioletObjects',
    'import VioletVM',

    '@testable import LibAriel',
    '@testable import BigInt',
    '@testable import FileSystem',
    '@testable import UnicodeData',
    '@testable import VioletCore',
    '@testable import VioletLexer',
    '@testable import VioletParser',
    '@testable import VioletBytecode',
    '@testable import VioletCompiler',
    '@testable import VioletObjects',
    '@testable import VioletVM',

    'import Rapunzel',
    '@testable import Rapunzel',

    'import Ariel',
    '@testable import Ariel',
]


def get_repository_root():
    current_file = os.path.abspath(__file__)
    current_dir = os.path.dirname(current_file)

    # We are looking for a directory that contains 'Sources'
    candidate_dir = current_dir
    while candidate_dir:
        for entry in os.listdir(candidate_dir):
            if entry == 'Sources':
                return candidate_dir

        # Go up 1 level
        candidate_dir = os.path.dirname(candidate_dir)

    assert False, f"Unable to find repository root (started at '{current_dir})"


def list_files_rec(root_dir, extension='swift'):
    result = []

    for entry in os.listdir(root_dir):
        if entry == '.DS_Store':
            continue

        entry_path = os.path.join(root_dir, entry)

        if os.path.isfile(entry_path):
            if entry_path.endswith(extension):
                result.append(entry_path)
        elif os.path.isdir(entry_path):
            sub_result = list_files_rec(entry_path)
            result.extend(sub_result)
        else:
            assert False

    return result


def is_import_line(line: str):
    return line.startswith('import') or line.startswith('@testable import')


def read_import_lines(f):
    result = []

    while True:
        line_start = f.tell()
        line = f.readline()

        if not line:  # EOF
            return result

        if not is_import_line(line):
            f.seek(line_start)  # Go back to the beginning of the line
            return result

        result.append(line)


def get_import_line_index(line: str):
    line_strip = line.strip()

    for index, candidate in enumerate(SORTED_IMPORTS):
        if line_strip.startswith(candidate):
            return index

    assert False, f"\n\nWild '{line_strip}' appears! 'sort_swift_imports' is ineffective!"


def sort_import_lines(file, lines):
    result = [None] * len(SORTED_IMPORTS)
    for line in lines:
        index = get_import_line_index(line)

        if result[index]:
            assert False, f"Duplicate '{line}' in '{file}'"
        else:
            result[index] = line

    return filter(lambda line: line, result)


if __name__ == '__main__':
    root_dir = get_repository_root()
    swift_files = []

    sources_dir = os.path.join(root_dir, 'Sources')
    swift_files.extend(list_files_rec(sources_dir))

    tests_dir = os.path.join(root_dir, 'Tests')
    swift_files.extend(list_files_rec(tests_dir))

    for file in swift_files:
        fixed_content = None

        with open(file) as f:
            import_lines = read_import_lines(f)
            sorted_import_lines = sort_import_lines(file, import_lines)

            if import_lines != sorted_import_lines:
                fixed_content = ''
                for line in sorted_import_lines:
                    fixed_content += line

                fixed_content += f.read()

        if fixed_content:
            with open(file, 'w') as f:
                f.write(fixed_content)
