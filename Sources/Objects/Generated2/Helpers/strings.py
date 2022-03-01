def generated_warning(file_path: str) -> str:
    header = f'''
// Automatically generated from: {file_path}
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
'''

    comment_marker = '// '
    max_line_len = max(map(lambda line: len(line), header.splitlines()))
    equal_count = max_line_len - len(comment_marker)
    separator = comment_marker + '=' * equal_count

    return separator + header + separator


where_to_find_errors_in_cpython = '''\
// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/library/exceptions.html
// https://docs.python.org/3.7/c-api/exceptions.html\
'''
