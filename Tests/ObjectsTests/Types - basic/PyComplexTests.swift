import XCTest
import VioletCore
import VioletObjects

class PyComplexTests: PyTestCase {

  func test_description() {
    let py = self.createPy()

    let c0i0 = py.newComplex(real: 0.0, imag: 0.0)
    self.assertDescription(c0i0, "PyComplex(complex, real: 0.0, imag: 0.0)")

    let c0i7 = py.newComplex(real: 0.0, imag: 7.2)
    let c0i_7 = py.newComplex(real: 0.0, imag: -7.2)
    self.assertDescription(c0i7, "PyComplex(complex, real: 0.0, imag: 7.2)")
    self.assertDescription(c0i_7, "PyComplex(complex, real: 0.0, imag: -7.2)")

    let c7i0 = py.newComplex(real: 7.2, imag: 0.0)
    let c_7i0 = py.newComplex(real: -7.2, imag: 0.0)
    self.assertDescription(c7i0, "PyComplex(complex, real: 7.2, imag: 0.0)")
    self.assertDescription(c_7i0, "PyComplex(complex, real: -7.2, imag: 0.0)")

    let c7i13 = py.newComplex(real: 7.2, imag: 13.42)
    let c7i_13 = py.newComplex(real: 7.2, imag: -13.42)
    let c_7i13 = py.newComplex(real: -7.2, imag: 13.42)
    let c_7i_13 = py.newComplex(real: -7.2, imag: -13.42)
    self.assertDescription(c7i13, "PyComplex(complex, real: 7.2, imag: 13.42)")
    self.assertDescription(c7i_13, "PyComplex(complex, real: 7.2, imag: -13.42)")
    self.assertDescription(c_7i13, "PyComplex(complex, real: -7.2, imag: 13.42)")
    self.assertDescription(c_7i_13, "PyComplex(complex, real: -7.2, imag: -13.42)")
  }
}
