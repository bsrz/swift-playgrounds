import Foundation
import Observation

enum Control {

    struct BasicState: Equatable {
        var id: UUID
        var updated: Date
    }

    @Observable
    class BasicViewModel {

        private(set) var state: BasicState

        let makeDate: () -> Date
        let makeUUID: () -> UUID

        init(makeDate: @escaping () -> Date, makeUUID: @escaping () -> UUID) {
            self.makeDate = makeDate
            self.makeUUID = makeUUID
            self.state = BasicState(
                id: makeUUID(),
                updated: makeDate()
            )
        }

        enum Action {
            case resetId
            case update
        }

        func send(_ action: Action) {
            switch action {
            case .resetId:
                state.id = makeUUID()

            case .update:
                state.updated = makeDate()
            }
        }
    }
}
