@testable import CasePathsDemo
import CasePaths
import XCTest

class LoadingStateTests: XCTestCase {
  func test0() throws {
    let randomizedValue = Int.random(in: 0...100)
    let state = LoadingState.loaded(.success(randomizedValue))

    guard case .loaded(let result) = state else { XCTFail() }
    XCTAssertEqual(try result.get(), randomizedValue)
  }

  func test1() throws {
    let randomizedValue = Int.random(in: 0...100)
    let state = LoadingState.loaded(.success(randomizedValue))

    let result = try XCTUnwrap(state, case: /LoadingState<Int>.loaded..Optional.some).get()
    XCTAssertEqual(randomizedValue, result)
  }

  func test2() throws {
    let state = LoadingState.loaded(.success(42))

    var int: Int?
    switch state {
    case .loaded(.success(let value)):
      int = value
    default:
      break
    }

    let result = try XCTUnwrap(int)
    XCTAssertEqual(result, 42)
  }

  func test3() throws {
    let state = LoadingState.loaded(.success(42))
    let result = try XCTUnwrap((/LoadingState<Int>.loaded).extract(from: state)?.get())
    XCTAssertEqual(result, 42)
  }
}
