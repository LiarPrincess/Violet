import XCTest
import VioletCore
@testable import VioletObjects

// swiftlint:disable number_separator
// swiftlint:disable file_length
// swiftformat:disable numberFormatting

private let minsize = 8

extension Int: PyHashable {
  public var hash: Int {
    return self
  }

  public func isEqual(to other: Int) -> PyResult<Bool> {
    return .value(self == other)
  }
}

class OrderedDictionaryTests: XCTestCase {

  // MARK: - Init

  func test_init_withoutArgs() {
    let dict = self.createDictionary()
    XCTAssertEqual(dict.count, 0)
    XCTAssertEqual(dict.capacity, minsize)
  }

  func test_init_withSize() {
    let dict = self.createDictionary(size: 27)
    XCTAssertEqual(dict.count, 0)
    XCTAssertEqual(dict.capacity, 32) // next power of 2
  }

  func test_init_withSize_lessThanMin() {
    let dict = self.createDictionary(size: 2)
    XCTAssertEqual(dict.count, 0)
    XCTAssertEqual(dict.capacity, minsize)
  }

  // MARK: - Empty

  func test_isEmpty() {
    var dict = self.createDictionary()

    self.insert(&dict, key: 2010, value: "Tangled")
    XCTAssertFalse(dict.isEmpty)

    self.insert(&dict, key: 2013, value: "Frozen")
    XCTAssertFalse(dict.isEmpty)

    _ = dict.remove(key: 2010)
    XCTAssertFalse(dict.isEmpty)

    _ = dict.remove(key: 2013)
    XCTAssertTrue(dict.isEmpty)
  }

  // MARK: - Get

  func test_get_existing() {
    var dict = self.createDictionary()
    self.insert(&dict, key: 2010, value: "Tangled")
    XCTAssertEqual(self.get(dict, key: 2010), "Tangled")
  }

  func test_get_notExisting() {
    var dict = self.createDictionary()
    self.insert(&dict, key: 2010, value: "Tangled")
    XCTAssertNil(self.get(dict, key: 2013))
  }

  func test_get_removed() {
    var dict = self.createDictionary()
    self.insert(&dict, key: 2010, value: "Tangled")
    _ = dict.remove(key: 2010)

    XCTAssertNil(self.get(dict, key: 2010))
  }

  // MARK: - Set

  func test_set() {
    var dict = self.createDictionary()

    self.insert(&dict, key: 2010, value: "Tangled")
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(dict, key: 2010), "Tangled")

    self.insert(&dict, key: 2013, value: "Frozen")
    XCTAssertEqual(dict.count, 2)
    XCTAssertEqual(self.get(dict, key: 2010), "Tangled")
    XCTAssertEqual(self.get(dict, key: 2013), "Frozen")
  }

  func test_set_update() {
    var dict = self.createDictionary()

    self.insert(&dict, key: 2010, value: "Tangled")
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(dict, key: 2010), "Tangled")

    self.insert(&dict, key: 2010, value: "Best movie ever")
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(dict, key: 2010), "Best movie ever")
  }

  // MARK: - Delete

  func test_delete_existing() {
    var dict = self.createDictionary()

    self.insert(&dict, key: 2010, value: "Tangled")
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(dict, key: 2010), "Tangled")

    XCTAssertEqual(self.remove(&dict, key: 2010), "Tangled")
    XCTAssertEqual(dict.count, 0)
    XCTAssertNil(self.get(dict, key: 2010))
  }

  func test_delete_notExisting() {
    var dict = self.createDictionary()
    self.insert(&dict, key: 2010, value: "Tangled")

    XCTAssertNil(self.remove(&dict, key: 2013))

    // Do we still have old entry?
    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(self.get(dict, key: 2010), "Tangled")
  }

  // MARK: - Clear

  func test_clear() {
    var dict = self.createDictionary()
    self.insert(&dict, key: 2010, value: "Tangled")
    self.insert(&dict, key: 2013, value: "Frozen")
    self.insert(&dict, key: 2019, value: "Frozen II")

    XCTAssertFalse(dict.isEmpty)
    XCTAssertEqual(dict.count, 3)

    dict.clear()

    XCTAssertTrue(dict.isEmpty)
    XCTAssertEqual(dict.count, 0)
  }

  // MARK: - Resize

  private var movieData: [(Int, String)] = [
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
    var dict = self.createDictionary()
    XCTAssertEqual(dict.count, 0)
    XCTAssertEqual(dict.capacity, 8)

    // Before resize - we start with capacity 8 which gives us 5 slots
    let initialSlots = 5
    for (year, title) in self.movieData[0..<initialSlots] {
      self.insert(&dict, key: year, value: title)
    }

    for (year, title) in self.movieData[0..<initialSlots] {
      XCTAssertEqual(self.get(dict, key: year), title)
    }

    XCTAssertEqual(dict.count, initialSlots)
    XCTAssertEqual(dict.capacity, 8)

    // 1st resize will give us capacity 16 which means 10 slots
    let firstResize = 10
    for (year, title) in self.movieData[initialSlots..<firstResize] {
      self.insert(&dict, key: year, value: title)
    }

    for (year, title) in self.movieData[0..<firstResize] {
      XCTAssertEqual(self.get(dict, key: year), title)
    }

    XCTAssertEqual(dict.count, firstResize)
    XCTAssertEqual(dict.capacity, 16)

    // 2nd resize will give us capacity 32, so now we can store all of our movies
    for (year, title) in self.movieData[firstResize...] {
      self.insert(&dict, key: year, value: title)
    }

    for (year, title) in self.movieData {
      XCTAssertEqual(self.get(dict, key: year), title)
    }

    XCTAssertEqual(dict.count, self.movieData.count)
    XCTAssertEqual(dict.capacity, 32)
  }

   // MARK: - Description

  func test_description() {
    var dict = self.createDictionary()
    XCTAssertEqual(dict.description, "OrderedDictionary()")

    self.insert(&dict, key: 2010, value: "Tangled")
    XCTAssertEqual(dict.description, "OrderedDictionary(2010: Tangled)")

    self.insert(&dict, key: 2013, value: "Frozen")
    self.insert(&dict, key: 2019, value: "Frozen II")
    XCTAssertEqual(
      dict.description,
      "OrderedDictionary(2010: Tangled, 2013: Frozen, 2019: Frozen II)"
    )

    _ = dict.remove(key: 2013)
    XCTAssertEqual(
      dict.description,
      "OrderedDictionary(2010: Tangled, 2019: Frozen II)"
    )

    _ = dict.remove(key: 2010)
    _ = dict.remove(key: 2019)
    XCTAssertEqual(dict.description, "OrderedDictionary()")
  }

  // MARK: - Index calculation

  func test_indexCalculation_eventually_triesAllIndices() {
    typealias Dict = OrderedDictionary<Int, String>

    let size = 32
    let hash = -5_073_420_405_599_346_384
    var index = Dict.IndexCalculation(hash: hash, dictionarySize: size)

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

  private func get(_ dict: OrderedDictionary<Int, String>,
                   key: Int,
                   file: StaticString = #file,
                   line: UInt = #line) -> String? {
    switch dict.get(key: key) {
    case .value(let o):
      return o
    case .notFound:
      return nil
    case .error(let e):
      XCTAssertNotNil(e, file: file, line: line)
      return nil
    }
  }

  private func insert(_ dict: inout OrderedDictionary<Int, String>,
                      key: Int,
                      value: String,
                      file: StaticString = #file,
                      line: UInt = #line) {
    switch dict.insert(key: key, value: value) {
    case .inserted,
         .updated:
      break
    case .error(let e):
      XCTAssertNotNil(e, file: file, line: line)
    }
  }

  private func remove(_ dict: inout OrderedDictionary<Int, String>,
                      key: Int,
                      file: StaticString = #file,
                      line: UInt = #line) -> String? {
    switch dict.remove(key: key) {
    case .value(let o):
      return o
    case .notFound:
      return nil
    case .error(let e):
      XCTAssertNotNil(e, file: file, line: line)
      return nil
    }
  }

  private func createDictionary(size: Int? = nil) -> OrderedDictionary<Int, String> {
    if let size = size {
      return OrderedDictionary(count: size)
    } else {
      return OrderedDictionary()
    }
  }
}
