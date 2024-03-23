@testable import StructuredConcurrency
import XCTest

class ContinuationBasicsTests: XCTestCase {

    func test1() {
        let exp = expectation(description: name)
        let sut = ContinuationBasics()
        sut.f1 { result in
            defer { exp.fulfill() }

            switch result {
            case .success(let messages):
                XCTAssertEqual(messages.count, 16)

            case .failure:
                XCTFail()
            }
        }

        wait(for: [exp])
    }

    func test2() async throws {
        let sut = ContinuationBasics()
        let messages = try await sut.f2()
        XCTAssertEqual(messages.count, 16)
    }
}
