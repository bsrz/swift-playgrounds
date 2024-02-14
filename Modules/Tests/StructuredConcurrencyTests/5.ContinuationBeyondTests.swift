@testable import StructuredConcurrency
import XCTest

class ContinuationBeyondTests: XCTestCase {

    func test1() async throws {
        let sut = BeyondContinuations()
        let int = try await sut.start()
        XCTAssertEqual(int, 1)
    }
}
