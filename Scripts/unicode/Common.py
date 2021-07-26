UNIDATA_VERSION = "11.0.0"


def generated_warning(file_path: str) -> str:
    file_path_scripts_index = file_path.index('/Scripts')
    if file_path_scripts_index != -1:
        file_path = file_path[file_path_scripts_index:]

    header = f'''
// Automatically generated from: {file_path}
// Use 'make unicode' in repository root to regenerate.
// DO NOT EDIT!
'''

    comment_marker = '// '
    max_line_len = max(map(lambda line: len(line), header.splitlines()))
    equal_count = max_line_len - len(comment_marker)
    separator = comment_marker + '=' * equal_count

    return separator + header + separator
