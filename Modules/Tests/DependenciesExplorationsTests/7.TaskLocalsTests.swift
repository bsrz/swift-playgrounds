@testable import DependenciesExplorations
import Dependencies
import XCTest

class TaskLocalsTests: XCTestCase {

    func testViewModel_whenInstantiated_stateIsNil() {
        let sut = TaskLocals.ParentViewModel()

        XCTAssertNil(sut.state)
    }

    func testViewModel_whenChildButtonTapped_stateIsChildWithEmptyState() {
        let sut = TaskLocals.ParentViewModel()
        sut.send(.childButttonTapped)

        switch sut.state {
        case .child(let viewModel):
            XCTAssertEqual(viewModel.state, [])

        default:
            XCTFail("Unexpected state")
        }
    }

    func test1() {
        let sut = withDependencies {
            $0.taskLocalsBasicProvider = TestTaskLocalsBasicProvider()
        } operation: {
            TaskLocals.ParentViewModel()
        }

        sut.send(.childButttonTapped)

        switch sut.state {
        case .child(let child):
            child.send(.provide)
            XCTAssertEqual(child.state, ["test"])

        default:
            XCTFail("Unexpected state")
        }
    }
}

struct TestTaskLocalsBasicProvider: TaskLocalsBasicProvider {
    func getString() -> String { "test" }
}
