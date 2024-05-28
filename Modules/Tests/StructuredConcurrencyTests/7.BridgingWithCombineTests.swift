@testable import StructuredConcurrency
import Combine
import XCTest

class BridgingWithCombineTests: XCTestCase {

    func test0() {
        let store = CombineDataStore()

        let exp = expectation(description: name)
        let sub = store.fetch()
            .sink { completion in
                defer { exp.fulfill() }
                XCTAssertTrue(completion == .finished)
            } receiveValue: { int in
                XCTAssertEqual(int, 42)
            }

        wait(for: [exp], timeout: 10)
        sub.cancel()
    }

    func test1() async throws {
        let store = CombineDataStore()

        let exp = expectation(description: name)
        let sub = store.fetch()
            .mapError { $0 as Error }
            .throwingAsyncMap { int in
                try await mapToString(int: int)
            }
            .sink { completion in
                defer { exp.fulfill() }
                if case .failure = completion {
                    XCTFail()
                }
            } receiveValue: { string in
                XCTAssertEqual(string, "int value is: 42")
            }

        await fulfillment(of: [exp])
        sub.cancel()
    }
}
