'''
See this mail thread:
https://mail.python.org/pipermail/python-dev/2003-April/034535.html

This is solved in CPython in:
Objects/typeobject.c -> 'hackcheck' function
'''


def reverse(self):
    return self[::-1]


try:
    str.reverse = reverse
    assert False
except TypeError:
    pass


try:
    str.__dict__['reverse'] = reverse
    assert False
except TypeError:
    pass

try:
    object.__setattr__(str, 'reverse', reverse)
    assert False
except TypeError:
    pass
