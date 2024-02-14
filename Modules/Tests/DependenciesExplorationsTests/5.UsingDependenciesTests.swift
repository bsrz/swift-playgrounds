@testable import DependenciesExplorations
import Dependencies
import XCTest

class UsingDependenciesTests: XCTestCase {

    func testViewModel_whenInstantiated_createsInitialState() {
        let id = UUID()
        let updated = Date()
        let state = UsingDependencies.BasicState(
            id: id,
            updated: updated
        )

        // No dependencies are used
        // Nothing needs to be provided
        let sut = UsingDependencies.BasicViewModel(state: state)

        XCTAssertEqual(sut.state.id, id)
        XCTAssertEqual(sut.state.updated, updated)
    }

    func testViewModel_whenSentResetIdAction_updatesStateWithNewId() {
        let id = UUID()
        let updated = Date()
        let state = UsingDependencies.BasicState(
            id: id,
            updated: updated
        )
        let sut = withDependencies {
            $0.uuid = .incrementing // Only uuid is supplied, the only expected dependency
        } operation: {
            UsingDependencies.BasicViewModel(state: state)
        }

        sut.send(.resetId)

        XCTAssertNotEqual(state, sut.state)
        XCTAssertEqual(sut.state.id, UUID(0))
    }

    func testViewModel_whenSentUpdateAction_updatesStateWithNewDate() {
        let id = UUID()
        let updated = Date()
        let state = UsingDependencies.BasicState(
            id: id,
            updated: updated
        )
        let sut = withDependencies {
            $0.date = DateGenerator { Date(timeIntervalSince1970: 0) }
        } operation: {
            UsingDependencies.BasicViewModel(state: state)
        }

        sut.send(.update)

        XCTAssertNotEqual(state, sut.state)
        XCTAssertEqual(sut.state.updated, Date(timeIntervalSince1970: 0))
    }
}
