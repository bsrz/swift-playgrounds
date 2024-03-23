@testable import StructuredConcurrency
import XCTest

class ContinuationPublishingTests: XCTestCase {

    func test0() {
        let multicaster = AsyncMulticaster<Int>()

        multicaster.subscribe { int in
            print("1. receiving: \(int)")
        }

        multicaster.subscribe { int in
            print("2. receiving: \(int)")
        }

        multicaster.send(1)
        multicaster.send(2)
        multicaster.send(3)
    }
}
