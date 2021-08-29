# Sourcery annotations

We use [Sourcery](https://github.com/krzysztofzablocki/Sourcery) to annotate Swift code that is exposed in Python.

## Types

Swift class representing Python type is marked with `pytype` annotation. Additional annotations can be used to set type flags.

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public class PyInt: PyObject {
  // …
}
```

## Methods

Swift method representing Python method is marked with one of the `pymethod`, `pystaticmethod` or `pyclassmethod` annotations:

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public class PyInt: PyObject {

  // sourcery: pymethod = __add__
  public func add(_ other: PyObject) -> PyResult<PyObject> {
    // …
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyIntNew(type: PyType,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyInt> {
    // …
  }
}
```

## Properties

Swift method representing Python property getter is marked with `pyproperty` annotation. Additional `setter = <method-name>` may be also adde, `del` is not supported, because it is not used.

```Swift
// sourcery: pytype = type, isDefault, hasGC, isBaseType, typeSubclass
public class PyType: PyObject {

  // sourcery: pyproperty = __name__, setter = setName
  public func getName() -> PyString {
    // …
  }

  public func setName(_ value: PyObject?) -> PyResult<Void> {
    // …
  }
}
```
