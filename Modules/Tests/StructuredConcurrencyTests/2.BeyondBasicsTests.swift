@testable import StructuredConcurrency
import XCTest

class BeyondBasicsTests: XCTestCase {

    func test1() {
        BeyondBasics.f1()
    }

    func test2() async throws {
        try await BeyondBasics.f2()

        try await Task.sleep(for: .seconds(2))
    }

    func test3() async throws {
        try await BeyondBasics.f3()
    }
}
