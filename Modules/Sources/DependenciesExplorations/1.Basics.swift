import Foundation
import Observation

enum Basics {

    struct BasicState: Equatable {
        var id: UUID
        var updated: Date
    }

    @Observable
    class BasicViewModel {

        private(set) var state: BasicState

        init() {
            self.state = BasicState(
                id: UUID(),
                updated: Date()
            )
        }

        enum Action {
            case resetId
            case update
        }

        func send(_ action: Action) {
            switch action {
            case .resetId:
                state.id = UUID()

            case .update:
                state.updated = Date()
            }
        }
    }
}
