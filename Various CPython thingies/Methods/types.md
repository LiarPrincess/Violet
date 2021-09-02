```py
class C:
  def m(self): pass

str.join
def f(): pass
```

# Function

- builtin (`len`)
  - type: builtin_function_or_method
  - print: `<built-in function len>`
- user defined (`f`)
  - type: function
  - print: `<function f at 0x10a6c20d0>`

# Class

- builtin method
  - unbound (`str.join`)
    - type: method_descriptor
    - print: `<method 'join' of 'str' objects>`
  - bound (`''.join`)
    - type: builtin_function_or_method
    - print: `<built-in method join of str object at 0x1077293b0>`
- user defined method
  - unbound (`C.m`)
    - type: function
    - print: <function C.m at 0x10784b830>
  - bound (`c.m`)
    - type: method
    - print: `<bound method C.m of <__main__.C object at 0x10784d810>>`
- builtin property
  - type: wrapper_descriptor
  - print: `<slot wrapper '__len__' of 'str' objects>`
