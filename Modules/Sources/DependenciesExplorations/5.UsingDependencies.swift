import Dependencies
import Foundation
import Observation

enum UsingDependencies {

    struct BasicState: Equatable {
        var id: UUID
        var updated: Date
    }

    @Observable
    class BasicViewModel {

        @ObservationIgnored
        @Dependency(\.date) private var date

        @ObservationIgnored
        @Dependency(\.uuid) private var uuid

        private(set) var state: BasicState

        init(state: BasicState) { // No more hidden/implicit dependencies
            self.state = state
        }

        enum Action {
            case resetId
            case update
        }

        func send(_ action: Action) {
            switch action {
            case .resetId:
                state.id = uuid()

            case .update:
                state.updated = date()
            }
        }
    }
}
