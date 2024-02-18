@testable import DependenciesExplorations
import Dependencies
import XCTest

class SideEffectsTests: XCTestCase {

    var sut: SideEffects.BasicViewModel!

    override func setUp() {
        super.setUp()

        let id = UUID()
        let updated = Date()
        let state = SideEffects.BasicState(
            id: id,
            updated: updated
        )
        sut = SideEffects.BasicViewModel(state: state)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewModel_sideEffect() {
        let id = UUID()
        let updated = Date()
        let state = SideEffects.BasicState(
            id: id,
            updated: updated
        )
        sut = SideEffects.BasicViewModel(state: state)
    }

    // 1. Using setUp and tearDown forces us to provide all dependencies, even the ones that aren't needed
    // 2. Resetting the SUT in side the test causes bad side effects and unexpected behaviour, making tests non-deterministic
    // 3. Either
    //  a) all tests need all dependencies and we can use setUp/tearDown
    //  b) don't use setUp/tearDown and only use the test function;
    //     this will become much easier as we complete the transition to Dependencies since you won't have to create all the dependencies
}
