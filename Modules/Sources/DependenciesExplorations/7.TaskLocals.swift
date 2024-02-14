import Dependencies
import Foundation
import Observation

// MARK: - Protocol and Implementation

protocol TaskLocalsBasicProvider {
    func getString() -> String
}

struct FooTaskLocalsBasicProvider: TaskLocalsBasicProvider {
    func getString() -> String { "foo" }
}

// MARK: - Dependency Registration

private enum TaskLocalsBasicProviderDependencyKey: DependencyKey {
    static let liveValue: TaskLocalsBasicProvider = FooTaskLocalsBasicProvider()
}

extension DependencyValues {
    var taskLocalsBasicProvider: TaskLocalsBasicProvider {
        get { self[TaskLocalsBasicProviderDependencyKey.self] }
        set { self[TaskLocalsBasicProviderDependencyKey.self] = newValue }
    }
}

// MARK: - Usage

enum TaskLocals {

    @Observable
    class ChildViewModel {

        @ObservationIgnored
        @Dependency(\.taskLocalsBasicProvider) private var provider

        private(set) var state: [String] = []

        enum Action {
            case provide
        }

        func send(_ action: Action) {
            switch action {
            case .provide:
                state.append(provider.getString())
            }
        }
    }

    @Observable
    class ParentViewModel {

        enum State {
            case child(ChildViewModel)
        }

        private(set) var state: State?

        init(state: State? = nil) {
            self.state = state
        }

        enum Action {
            case childButttonTapped
        }

        func send(_ action: Action) {
            switch action {
            case .childButttonTapped:
                let child = withDependencies(from: self) { ChildViewModel() }
                state = .child(child)
            }
        }
    }
}
