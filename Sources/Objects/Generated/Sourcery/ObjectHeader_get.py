import os.path

from Sourcery.ObjectHeader import ObjectHeader, ObjectHeaderField

def get_object_header() -> ObjectHeader:
    dir_path = os.path.dirname(__file__)
    input_file = os.path.join(dir_path, 'dump.txt')

    result = ObjectHeader()

    with open(input_file, 'r') as reader:
        for line in reader:
            line = line.strip()

            if not line or line.startswith('#'):
                continue

            split = line.split('|')
            assert len(split) >= 1

            line_type = split[0]
            if line_type == 'ObjectHeaderField':
                assert len(split) == 3

                field_name = split[1]
                field_type = split[2]

                field = ObjectHeaderField(field_name, field_type)
                result.fields.append(field)

    return result
