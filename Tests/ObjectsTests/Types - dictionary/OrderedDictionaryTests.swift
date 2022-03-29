import XCTest
import VioletCore
@testable import VioletObjects

// swiftlint:disable number_separator
// swiftformat:disable numberFormatting

private let minsize = 8

class OrderedDictionaryTests: PyTestCase {

  private typealias Value = String
  private typealias OrderedDictionary = VioletObjects.OrderedDictionary<Value>

  // MARK: - Init

  func test_init_withoutArgs() {
    let dict = self.create()
    XCTAssertEqual(dict.count, 0)
    XCTAssertEqual(dict.capacity, minsize)
  }

  func test_init_withSize() {
    let dict = self.create(size: 27)
    XCTAssertEqual(dict.count, 0)
    XCTAssertEqual(dict.capacity, 32) // next power of 2
  }

  func test_init_withSize_lessThanMin() {
    let dict = self.create(size: 2)
    XCTAssertEqual(dict.count, 0)
    XCTAssertEqual(dict.capacity, minsize)
  }

  // MARK: - Empty

  func test_isEmpty() {
    let py = self.createPy()
    var dict = self.create()

    let tangledYear = py.newInt(2010)
    self.insert(py, &dict, key: tangledYear, value: "Tangled")
    XCTAssertFalse(dict.isEmpty)

    let frozenYear = py.newInt(2013)
    self.insert(py, &dict, key: frozenYear, value: "Frozen")
    XCTAssertFalse(dict.isEmpty)

    _ = self.remove(py, &dict, key: tangledYear)
    XCTAssertFalse(dict.isEmpty)

    _ = self.remove(py, &dict, key: frozenYear)
    XCTAssertTrue(dict.isEmpty)
  }

  // MARK: - Get

  func test_get_existing() {
    let py = self.createPy()
    var dict = self.create()

    let tangledYear = py.newInt(2010)
    self.insert(py, &dict, key: tangledYear, value: "Tangled")
    XCTAssertEqual(self.get(py, dict, key: tangledYear), "Tangled")
  }

  func test_get_notExisting() {
    let py = self.createPy()
    var dict = self.create()

    let tangledYear = py.newInt(2010)
    self.insert(py, &dict, key: tangledYear, value: "Tangled")

    let frozenYear = py.newInt(2013)
    XCTAssertNil(self.get(py, dict, key: frozenYear))
  }

  func test_get_removed() {
    let py = self.createPy()
    var dict = self.create()

    let tangledYear = py.newInt(2010)

    self.insert(py, &dict, key: tangledYear, value: "Tangled")
    XCTAssertEqual(self.get(py, dict, key: tangledYear), "Tangled")

    _ = self.remove(py, &dict, key: tangledYear)
    XCTAssertNil(self.get(py, dict, key: tangledYear))
  }

  // MARK: - Set

  func test_set() {
    let py = self.createPy()
    var dict = self.create()

    let tangledYear = py.newInt(2010)
    self.insert(py, &dict, key: tangledYear, value: "Tangled")
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(py, dict, key: tangledYear), "Tangled")

    let frozenYear = py.newInt(2013)
    self.insert(py, &dict, key: frozenYear, value: "Frozen")
    XCTAssertEqual(dict.count, 2)
    XCTAssertEqual(self.get(py, dict, key: tangledYear), "Tangled")
    XCTAssertEqual(self.get(py, dict, key: frozenYear), "Frozen")
  }

  func test_set_update() {
    let py = self.createPy()
    var dict = self.create()

    let tangledYear = py.newInt(2010)

    self.insert(py, &dict, key: tangledYear, value: "Tangled")
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(py, dict, key: tangledYear), "Tangled")

    self.insert(py, &dict, key: tangledYear, value: "Best movie ever")
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(py, dict, key: tangledYear), "Best movie ever")
  }

  // MARK: - Delete

  func test_delete_existing() {
    let py = self.createPy()
    var dict = self.create()

    let tangledYear = py.newInt(2010)

    self.insert(py, &dict, key: tangledYear, value: "Tangled")
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(py, dict, key: tangledYear), "Tangled")

    XCTAssertEqual(self.remove(py, &dict, key: tangledYear), "Tangled")
    XCTAssertEqual(dict.count, 0)
    XCTAssertNil(self.get(py, dict, key: tangledYear))
  }

  func test_delete_notExisting() {
    let py = self.createPy()
    var dict = self.create()

    let tangledYear = py.newInt(2010)
    self.insert(py, &dict, key: tangledYear, value: "Tangled")

    let frozenYear = py.newInt(2013)
    XCTAssertNil(self.remove(py, &dict, key: frozenYear))

    // Do we still have old entry?
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(py, dict, key: tangledYear), "Tangled")
  }

  // MARK: - Clear

  func test_clear() {
    let py = self.createPy()
    var dict = self.create()

    let tangledYear = py.newInt(2010)
    self.insert(py, &dict, key: tangledYear, value: "Tangled")

    let frozenYear = py.newInt(2013)
    self.insert(py, &dict, key: frozenYear, value: "Frozen")

    let frozen2Year = py.newInt(2019)
    self.insert(py, &dict, key: frozen2Year, value: "Frozen II")

    XCTAssertFalse(dict.isEmpty)
    XCTAssertEqual(dict.count, 3)

    dict.clear()

    XCTAssertTrue(dict.isEmpty)
    XCTAssertEqual(dict.count, 0)
  }

  // MARK: - Resize

  private static let movieData: [(Int, String)] = [
    // It is important that years are unique (they are our keys!)
    (1991, "Beauty and the Beast"),
    (1997, "Hercules"),
    (1998, "Mulan"),
    (1999, "Tarzan"),
    (2000, "Fantasia 2000"),
    (2007, "Ratatouille"),
    (2009, "The Princess and the Frog"),
    (2010, "Tangled"),
    (2011, "Winnie the Pooh"),
    (2012, "Wreck-It Ralph"),
    (2013, "Frozen"),
    (2014, "Big Hero 6"),
    (2015, "Inside Out"),
    (2018, "Ralph Breaks the Internet"),
    (2019, "Frozen II")
  ]

  func test_resize() {
    let py = self.createPy()
    var dict = self.create()

    XCTAssertEqual(dict.count, 0)
    XCTAssertEqual(dict.capacity, 8)

    let movies = Self.movieData.map { year, title in
      return (py.newInt(year), title)
    }

    // Before resize - we start with capacity 8 which gives us 5 slots
    let initialSlots = 5
    for (year, title) in movies[0..<initialSlots] {
      self.insert(py, &dict, key: year, value: title)
    }

    for (year, title) in movies[0..<initialSlots] {
      XCTAssertEqual(self.get(py, dict, key: year), title)
    }

    XCTAssertEqual(dict.count, initialSlots)
    XCTAssertEqual(dict.capacity, 8)

    // 1st resize will give us capacity 16 which means 10 slots
    let firstResize = 10
    for (year, title) in movies[initialSlots..<firstResize] {
      self.insert(py, &dict, key: year, value: title)
    }

    for (year, title) in movies[0..<firstResize] {
      XCTAssertEqual(self.get(py, dict, key: year), title)
    }

    XCTAssertEqual(dict.count, firstResize)
    XCTAssertEqual(dict.capacity, 16)

    // 2nd resize will give us capacity 32, so now we can store all of our movies
    for (year, title) in movies[firstResize...] {
      self.insert(py, &dict, key: year, value: title)
    }

    for (year, title) in movies {
      XCTAssertEqual(self.get(py, dict, key: year), title)
    }

    XCTAssertEqual(dict.count, movies.count)
    XCTAssertEqual(dict.capacity, 32)
  }

   // MARK: - Description

  func test_description() {
    let py = self.createPy()
    var dict = self.create()

    XCTAssertEqual(dict.description, "OrderedDictionary()")

    let tangledYear = py.newInt(2010)
    let tangledElement = "Key(PyInt(int, value: 2010)): Tangled"
    self.insert(py, &dict, key: tangledYear, value: "Tangled")
    XCTAssertEqual(dict.description, "OrderedDictionary(\(tangledElement))")

    let frozenYear = py.newInt(2013)
    let frozenElement = "Key(PyInt(int, value: 2013)): Frozen"
    self.insert(py, &dict, key: frozenYear, value: "Frozen")

    let frozen2Year = py.newInt(2019)
    let frozen2Element = "Key(PyInt(int, value: 2019)): Frozen II"
    self.insert(py, &dict, key: frozen2Year, value: "Frozen II")

    XCTAssertEqual(
      dict.description,
      "OrderedDictionary(\(tangledElement), \(frozenElement), \(frozen2Element))"
    )

    _ = self.remove(py, &dict, key: frozenYear)
    XCTAssertEqual(
      dict.description,
      "OrderedDictionary(\(tangledElement), \(frozen2Element))"
    )

    _ = self.remove(py, &dict, key: tangledYear)
    _ = self.remove(py, &dict, key: frozen2Year)
    XCTAssertEqual(dict.description, "OrderedDictionary()")
  }

  // MARK: - Index calculation

  func test_indexCalculation_eventually_triesAllIndices() {
    let size = 32
    let hash = -5_073_420_405_599_346_384
    var index = OrderedDictionary.IndexCalculation(hash: hash, dictionarySize: size)

    let maxTries = 100
    var usedIndices = [Bool](repeating: false, count: size)
    var usedIndicesCount = 0

    for _ in 0..<maxTries {
      let i = index.value
      if !usedIndices[i] {
        usedIndices[i] = true
        usedIndicesCount += 1
      }

      let hasAllIndices = usedIndicesCount == size
      if hasAllIndices {
        return
      }

      index.calculateNext()
    }

    let missing = usedIndices.enumerated().filter { !$0.element }.map { $0.offset }
    XCTAssert(false, "Missing: \(missing)")
  }

  // MARK: - Helpers

  private func create(size: Int? = nil) -> OrderedDictionary {
    if let size = size {
      return OrderedDictionary(count: size)
    } else {
      return OrderedDictionary()
    }
  }

  private func get<T: PyObjectMixin>(_ py: Py,
                                     _ dict: OrderedDictionary,
                                     key: T,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> Value? {
    guard let dictKey = self.createKey(py, object: key) else {
      return nil
    }

    switch dict.get(py, key: dictKey) {
    case .value(let o):
      return o
    case .notFound:
      return nil
    case .error(let e):
      let reason = self.toString(py, error: e)
      XCTFail(reason, file: file, line: line)
      return nil
    }
  }

  private func insert<T: PyObjectMixin>(_ py: Py,
                                        _ dict: inout OrderedDictionary,
                                        key: T,
                                        value: Value,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    guard let dictKey = self.createKey(py, object: key) else {
      return
    }

    switch dict.insert(py, key: dictKey, value: value) {
    case .inserted,
        .updated:
      break
    case .error(let e):
      XCTAssertNotNil(e, file: file, line: line)
    }
  }

  private func remove<T: PyObjectMixin>(_ py: Py,
                                        _ dict: inout OrderedDictionary,
                                        key: T,
                                        file: StaticString = #file,
                                        line: UInt = #line) -> Value? {
    guard let dictKey = self.createKey(py, object: key) else {
      return nil
    }

    switch dict.remove(py, key: dictKey) {
    case .value(let o):
      return o
    case .notFound:
      return nil
    case .error(let e):
      XCTAssertNotNil(e, file: file, line: line)
      return nil
    }
  }

  private func createKey<T: PyObjectMixin>(_ py: Py,
                                           object generic: T,
                                           file: StaticString = #file,
                                           line: UInt = #line) -> OrderedDictionary.Key? {
    let object = generic.asObject

    switch py.hash(object: object) {
    case let .value(hash):
      return OrderedDictionary.Key(hash: hash, object: object)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail(reason, file: file, line: line)
      return nil
    }
  }
}
