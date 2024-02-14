import Foundation
import Observation

enum Hierarchy {

    struct BasicState: Equatable {
        var id: UUID
        var updated: Date
    }

    struct BasicStateUseCase1 {
        func makeState(id: UUID, updated: Date) -> BasicState {
            BasicState(
                id: id,
                updated: updated
            )
        }
    }

    struct BasicStateUseCase2 {
        var makeDate: () -> Date
        var makeUUID: () -> UUID

        func makeState() -> BasicState {
            BasicState(
                id: makeUUID(),
                updated: makeDate()
            )
        }
    }

    @Observable
    class BasicViewModel1 {

        private(set) var state: BasicState

        private let useCase: BasicStateUseCase1
        private let makeUUID: () -> UUID
        private let makeDate: () -> Date

        init(useCase: BasicStateUseCase1, makeUUID: @escaping () -> UUID, makeDate: @escaping () -> Date) {
            self.makeDate = makeDate
            self.makeUUID = makeUUID
            self.useCase = useCase
            self.state = useCase.makeState(
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
                state = useCase.makeState(
                    id: makeUUID(),
                    updated: state.updated
                )

            case .update:
                state = useCase.makeState(
                    id: state.id,
                    updated: makeDate()
                )
            }
        }
    }

    @Observable
    class BasicViewModel2 {

        private(set) var state: BasicState

        private let useCase: BasicStateUseCase2

        init(useCase: BasicStateUseCase2) {
            self.useCase = useCase
            self.state = useCase.makeState()
        }

        enum Action {
            case resetId
            case update
        }

        func send(_ action: Action) {
            switch action {
            case .resetId:
                state.id = useCase.makeState().id

            case .update:
                state.updated = useCase.makeState().updated
            }
        }
    }
}
