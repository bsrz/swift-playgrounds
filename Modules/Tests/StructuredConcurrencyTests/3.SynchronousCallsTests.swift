@testable import StructuredConcurrency
import XCTest

class SynchronousCallsTests: XCTestCase {

    func test3() {
        let exp = expectation(description: name)

        SynchronousCalls.f3 { foo in
            print("foo: \(foo)")
            exp.fulfill()
        }

        wait(for: [exp])
    }
}
