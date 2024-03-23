@testable import StructuredConcurrency
import XCTest

class BasicsTests: XCTestCase {

    func test1() {
        Basics.f1()
    }

    func test2() {
        Basics.f2()

        let exp = expectation(description: name)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1010)) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func test3() async throws {
        try await Basics.f3()
    }

    func test4() async throws {
        try await Basics.f4()
    }

    func test5() {
        Basics.f5()
    }

    func test6() async {
        let int = await Basics.f6()
        XCTAssertEqual(int, 42)
    }

    func test7() async throws {
        try await Basics.f7()
        try await Task.sleep(for: .seconds(1))
    }
}
