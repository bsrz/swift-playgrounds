@testable import DependenciesExplorations
import XCTest

class UnexpectedAccessTests: XCTestCase {

    // MARK: - Dependencies

    var dateCount = 0.0
    private func makeDate() -> Date {
        defer { dateCount += 1 }
        return Date(timeIntervalSince1970: dateCount)
    }

    var uuidCount = 0
    private func makeUUID() -> UUID {
        defer { uuidCount += 1 }
        let four = "\(uuidCount)\(uuidCount)\(uuidCount)\(uuidCount)"
        let twoFour = "\(four)\(four)"
        let threeFour = "\(four)\(four)\(four)"
        return UUID(uuidString: "\(twoFour)-\(four)-\(four)-\(four)-\(threeFour)")!
    }

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        dateCount = 0
        uuidCount = 0
    }

    // MARK: - Tests

    func testViewModel_whenInstantiated_createsInitialState() {
        let sut = UnexpectedAccess.BasicViewModel(makeDate: makeDate, makeUUID: makeUUID)

        XCTAssertEqual(sut.state.id.uuidString, "00000000-0000-0000-0000-000000000000")
        XCTAssertEqual(sut.state.updated, Date(timeIntervalSince1970: 0))
    }

    func testViewModel_whenSentResetIdAction_updatesStateWithNewId() {
        let sut = UnexpectedAccess.BasicViewModel(makeDate: Date.init, makeUUID: makeUUID)
        let previous = sut.state

        sut.send(.resetId)

        XCTAssertNotEqual(previous, sut.state)
        XCTAssertEqual(sut.state.id.uuidString, "11111111-1111-1111-1111-111111111111")
    }

    func testViewModel_whenSentUpdateAction_updatesStateWithNewDate() {
        let sut = UnexpectedAccess.BasicViewModel(makeDate: makeDate, makeUUID: UUID.init)
        let previous = sut.state

        sut.send(.update)

        XCTAssertNotEqual(previous, sut.state)
        XCTAssertEqual(sut.state.updated, Date(timeIntervalSince1970: 1))
    }
}
