import XCTest
import Core

// swiftlint:disable number_separator

private let minsize = 8

extension Int: VioletHashable {
  public var hash: Int {
    return self
  }

  public func isEqual(to other: Int) -> Bool {
    return self == other
  }
}

class OrderedDictionary: XCTestCase {

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

  func test_empty() {
    var dict = self.createDictionary()

    dict.insert(key: 2010, value: "Tangled")
    XCTAssertFalse(dict.isEmpty)

    dict.insert(key: 2013, value: "Frozen")
    XCTAssertFalse(dict.isEmpty)

    _ = dict.remove(key: 2010)
    XCTAssertFalse(dict.isEmpty)

    _ = dict.remove(key: 2013)
    XCTAssertTrue(dict.isEmpty)
  }

  // MARK: - Subscript get

  func test_subscript_get_entryExists() {
    var dict = self.createDictionary()
    dict.insert(key: 2010, value: "Tangled")
    XCTAssertEqual(dict[2010], "Tangled")
  }

  func test_subscript_get_entryDoesNotExist() {
    var dict = self.createDictionary()
    dict.insert(key: 2010, value: "Tangled")
    XCTAssertNil(dict[2013])
  }

  func test_subscript_get_removed() {
    var dict = self.createDictionary()
    dict.insert(key: 2010, value: "Tangled")
    _ = dict.remove(key: 2010)

    XCTAssertNil(dict[2010])
  }

  // MARK: - Subscript set

  func test_subscript_set_entryExists() {
    var dict = self.createDictionary()
    dict.insert(key: 2010, value: "Tangled")

    dict[2010] = "Best movie ever"

    XCTAssertEqual(dict.count, 1)
    XCTAssertEqual(dict[2010], "Best movie ever")
  }

  func test_subscript_set_entryDoesNotExists() {
    var dict = self.createDictionary()
    dict.insert(key: 2010, value: "Tangled")

    dict[2013] = "Frozen"

    XCTAssertEqual(dict.count, 2)
    dict.insert(key: 2010, value: "Tangled")
    dict.insert(key: 2013, value: "Frozen")
  }

  // MARK: - Subscript delete

  func test_subscript_delete_entryExists() {
    var dict = self.createDictionary()
    dict.insert(key: 2010, value: "Tangled")

    dict[2010] = nil

    XCTAssertEqual(dict.count, 0)
    XCTAssertNil(dict[2010])
  }

  func test_subscript_delete_entryDoesNotExists() {
    var dict = self.createDictionary()
    dict.insert(key: 2010, value: "Tangled")

    dict[2013] = nil

    // Do we still have old entry?
    XCTAssertEqual(dict.count, 1)
    XCTAssertNotNil(dict[2010])
  }

  // MARK: - Clear

  func test_clear() {
    var dict = self.createDictionary()
    dict.insert(key: 2010, value: "Tangled")
    dict.insert(key: 2013, value: "Frozen")
    dict.insert(key: 2019, value: "Frozen II")

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
      dict.insert(key: year, value: title)
    }

    for (year, title) in self.movieData[0..<initialSlots] {
      XCTAssertEqual(dict[year], title, "\(year) - \(title)")
    }

    XCTAssertEqual(dict.count, initialSlots)
    XCTAssertEqual(dict.capacity, 8)

    // 1st resize will give us capacity 16 which means 10 slots
    let firstResize = 10
    for (year, title) in self.movieData[initialSlots..<firstResize] {
      dict.insert(key: year, value: title)
    }

    for (year, title) in self.movieData[0..<firstResize] {
      XCTAssertEqual(dict[year], title, "\(year) - \(title)")
    }

    XCTAssertEqual(dict.count, firstResize)
    XCTAssertEqual(dict.capacity, 16)

    // 2nd resize will give us capacity 32, so now we can store all of our movies
    for (year, title) in self.movieData[firstResize...] {
      dict.insert(key: year, value: title)
    }

    for (year, title) in self.movieData {
      XCTAssertEqual(dict[year], title, "\(year) - \(title)")
    }

    XCTAssertEqual(dict.count, self.movieData.count)
    XCTAssertEqual(dict.capacity, 32)
  }

  // MARK: - Expressible by dictionary literal

  func test_expressibleByDictionaryLiteral_empty() {
    let dict: Core.OrderedDictionary<Int, String> = [:]
    XCTAssertEqual(dict.isEmpty, true)
  }

  func test_expressibleByDictionaryLiteral() {
    let dict: Core.OrderedDictionary<Int, String> = [
      2013: "Frozen",
      2019: "Frozen II"
    ]

    XCTAssertEqual(dict.isEmpty, false)
    XCTAssertEqual(dict.count, 2)
    XCTAssertNotNil(dict[2013])
    XCTAssertNotNil(dict[2019])
  }

  // MARK: - Description

  func test_description() {
    var dict = self.createDictionary()
    XCTAssertEqual(dict.description, "[]")

    dict.insert(key: 2010, value: "Tangled")
    XCTAssertEqual(dict.description, "[2010: Tangled]")

    dict.insert(key: 2013, value: "Frozen")
    dict.insert(key: 2019, value: "Frozen II")
    XCTAssertEqual(dict.description, "[2010: Tangled, 2013: Frozen, 2019: Frozen II]")

    _ = dict.remove(key: 2013)
    XCTAssertEqual(dict.description, "[2010: Tangled, 2019: Frozen II]")

    _ = dict.remove(key: 2010)
    _ = dict.remove(key: 2019)
    XCTAssertEqual(dict.description, "[]")
  }

  // MARK: - Helpers

  private func createDictionary(size: Int? = nil) -> Core.OrderedDictionary<Int, String> {
    if let size = size {
      return Core.OrderedDictionary(size: size)
    } else {
      return Core.OrderedDictionary()
    }
  }
}
