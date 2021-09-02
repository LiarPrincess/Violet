This file contains example ASTs for function arguments.

https://docs.python.org/3/tutorial/controlflow.html#more-on-defining-functions

# Definition

```
kwargs = '**' vfpdef [',']
args = '*' [vfpdef]

varargslist =
  arguments
  ','
  '/'
  [','
    [(
      arguments
      [','
        [
          args
          (',' argument )* [',' [kwargs]]

          | kwargs
        ]
      ]

      | args_kwonly_kwargs
    )]
  ]

| (vararglist_no_posonly)
```

# Examples

```
def foo():
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list): empty
      defaults (list): empty
      kw_defaults (list): empty
      kwarg: none
      kwonlyargs (list): empty
      vararg: none
```

--------------

```
def foo(a: int = 1):
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list)
        arg (node)
          annotation: none
          arg: a
      defaults (list)
        Num (node)
          n: 1
      kw_defaults (list): empty
      kwarg: none
      kwonlyargs (list): empty
      vararg: none
```

--------------

```
def foo(a, b = "def_b", c = "def_c"):
  pass

-- How do we know to which parameter apply default value?
-- We take it from the last?
FunctionDef (node)
  args (node)
    arguments (node)
      args (list)
        arg (node)
          annotation: none
          arg: a
        arg (node)
          annotation: none
          arg: b
        arg (node)
          annotation: none
          arg: c
      defaults (list)
        Str (node)
          s: def_b
        Str (node)
          s: def_c
      kw_defaults (list): empty
      kwarg: none
      kwonlyargs (list): empty
      vararg: none
```

--------------

```
def foo(a, b = "def_b", * abc):
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list)
        arg (node)
          annotation: none
          arg: a
        arg (node)
          annotation: none
          arg: b
      defaults (list)
        Str (node)
          s: def_b
      kw_defaults (list): empty
      kwarg: none
      kwonlyargs (list): empty
      vararg (node)
        arg (node)
          annotation: none
          arg: abc
```

--------------

```
def name(*a, b=1, c):
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list): empty
      defaults (list): empty
      kw_defaults (list)
        Num (node)
          n: 1
        NoneType (node)
      kwarg: none
      kwonlyargs (list)
        arg (node)
          annotation: none
          arg: b
        arg (node)
          annotation: none
          arg: c
      vararg (node)
        arg (node)
          annotation: none
          arg: a
```

--------------

```
def name(*a, b=1, c=2):
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list): empty
      defaults (list): empty
      kw_defaults (list)
        Num (node)
          n: 1
        Num (node)
          n: 2
      kwarg: none
      kwonlyargs (list)
        arg (node)
          annotation: none
          arg: b
        arg (node)
          annotation: none
          arg: c
      vararg (node)
        arg (node)
          annotation: none
          arg: a
```

--------------

```
def foo(a, b = "def_b", ** abc):
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list)
        arg (node)
          annotation: none
          arg: a
        arg (node)
          annotation: none
          arg: b
      defaults (list)
        Str (node)
          s: def_b
      kw_defaults (list): empty
      kwarg (node)
        arg (node)
          annotation: none
          arg: abc
      kwonlyargs (list): empty
      vararg: none
```

--------------

```
def foo(a, b = "def_b", *abc, ** deg):
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list)
        arg (node)
          annotation: none
          arg: a
        arg (node)
          annotation: none
          arg: b
      defaults (list)
        Str (node)
          s: def_b
      kw_defaults (list): empty
      kwarg (node)
        arg (node)
          annotation: none
          arg: deg
      kwonlyargs (list): empty
      vararg (node)
        arg (node)
          annotation: none
          arg: abc
```

--------------

```
def foo(a, b = "def_b", *abc, c, ** deg):
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list)
        arg (node)
          annotation: none
          arg: a
        arg (node)
          annotation: none
          arg: b
      defaults (list)
        Str (node)
          s: def_b
      kw_defaults (list)
        NoneType (node)
      kwarg (node)
        arg (node)
          annotation: none
          arg: deg
      kwonlyargs (list)
        arg (node)
          annotation: none
          arg: c
      vararg (node)
        arg (node)
          annotation: none
          arg: abc
```

--------------

```
def foo(a, b = "def_b", *abc, c = "def_c", **deg):
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list)
        arg (node)
          annotation: none
          arg: a
        arg (node)
          annotation: none
          arg: b
      defaults (list)
        Str (node)
          s: def_b
      kw_defaults (list)
        Str (node)
          s: def_c
      kwarg (node)
        arg (node)
          annotation: none
          arg: deg
      kwonlyargs (list)
        arg (node)
          annotation: none
          arg: c
      vararg (node)
        arg (node)
          annotation: none
          arg: abc
```

--------------

```
def foo(a, b = "def_b", *, c):
  pass

FunctionDef (node)
  args (node)
    arguments (node)
      args (list)
        arg (node)
          annotation: none
          arg: a
        arg (node)
          annotation: none
          arg: b
      defaults (list)
        Str (node)
          s: def_b
      kw_defaults (list)
        NoneType (node)
      kwarg: none
      kwonlyargs (list)
        arg (node)
          annotation: none
          arg: c
      vararg: none
```
