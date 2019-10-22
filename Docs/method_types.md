```py
class C:
  def m(self): pass

str.join
def f(): pass
```

# Class
  common: <method '__getitem__' of 'list' objects>
  custom: <method 'join' of 'str' objects>
  user:   <function C.m at 0x10a6c2268>
  property: <slot wrapper '__len__' of 'str' objects>

# Object
  common: MethodWrapperType | <method-wrapper '__len__' of str object at 0x10a3f7c70>
  custom: BuiltinMethodType | <built-in method join of str object at 0x10a3f7c70>
  user:   MethodType        | <bound method C.m of <__main__.C object at 0x10a6be710>>
  property: <method wrapper '__len__' of 'str' objects>

# Function
  common: BuiltinFunctionType | <built-in function len>
  user:   FunctionType        | <function f at 0x10a6c20d0>
