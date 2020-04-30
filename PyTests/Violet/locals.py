def sing(elsa):
  l = locals()
  assert l['elsa'] == 'let_it_go'
  elsa = 'into_the_unknown'
  assert l['elsa'] == 'let_it_go'

  # Shouldn't the 2nd line be 'into_the_unknown'?
  # Well yes...
  # (All this is CPython internal implementation leaking)

sing('let_it_go')
