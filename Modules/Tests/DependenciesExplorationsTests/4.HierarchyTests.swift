@testable import DependenciesExplorations
import XCTest

class HierarchyTests: XCTestCase {

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
        let useCase1 = Hierarchy.BasicStateUseCase1()
        _ = Hierarchy.BasicViewModel1(
            useCase: useCase1,
            makeUUID: makeUUID,
            makeDate: makeDate
        )

        let useCase2 = Hierarchy.BasicStateUseCase2(makeDate: makeDate, makeUUID: makeUUID)
        _ = Hierarchy.BasicViewModel2(useCase: useCase2)
    }

    func testViewModel_whenSentResetIdAction_updatesStateWithNewId() {
        let useCase1 = Hierarchy.BasicStateUseCase1()
        _ = Hierarchy.BasicViewModel1(
            useCase: useCase1,
            makeUUID: makeUUID,
            makeDate: makeDate // has to be supplied, not used
        )

        let useCase2 = Hierarchy.BasicStateUseCase2(
            makeDate: makeDate, // has to be supplied, not used
            makeUUID: makeUUID
        )
        _ = Hierarchy.BasicViewModel2(useCase: useCase2)
    }
}
