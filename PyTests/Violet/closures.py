def f():
  d = { }
  def insert(key, value):
    d[key] = value

  insert('frozen', 'elsa')
  assert d['frozen'] == 'elsa'

f()
