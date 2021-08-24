try:
    exec('''\
for i in range(0, 10):
xxx
  ''')
except IndentationError:
    pass
