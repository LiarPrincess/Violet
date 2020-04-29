def calculate_depth(e):
  result = 0
  tb = e.__traceback__

  while tb != None:
    result += 1
    tb = tb.tb_next

  return result

# ===========
# == Depth ==
# ===========

def elsa():
  raise BaseException('inside_elsa')

def frozen():
  elsa()

try:
  frozen()
except BaseException as e:
  assert calculate_depth(e) == 3

# ==========
# == Loop ==
# ==========

e = BaseException('elsa')
for i in range(0, 5):
  try:
    raise e
  except BaseException as ee:
    pass

assert calculate_depth(e) == 5
