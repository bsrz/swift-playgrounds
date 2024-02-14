@testable import DependenciesExplorations
import XCTest

class BasicsTests: XCTestCase {

    func testViewModel_whenSentResetIdAction_updatesStateWithNewId() {
        let sut = Basics.BasicViewModel()
        let previous = sut.state
        
        sut.send(.resetId)

        XCTAssertNotEqual(previous, sut.state)
    }

    func testViewModel_whenSentUpdateAction_updatesStateWithNewDate() {
        let sut = Basics.BasicViewModel()
        let previous = sut.state

        sut.send(.update)

        XCTAssertNotEqual(previous, sut.state)
    }
}
