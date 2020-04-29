def basename(path: str):
  try:
    slash_index = path.rindex('/')
    name_start_index = slash_index + 1
    return path[name_start_index:]
  except ValueError:
    return path

def import_file():
	assert basename(__file__) == "import_file.py"
