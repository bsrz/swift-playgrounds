protocol InsideStateBoolProvider {
    func getBool() -> Bool
}

struct TrueInsideStateBoolProvider: InsideStateBoolProvider {
    func getBool() -> Bool { true }
}

struct InsideState {
    struct State {
        var int: Int
        var string: String
    }

    class ViewModel {

        private(set) var state: State

        init(provider: InsideStateBoolProvider) {
            // Prevents any kind of injection by hiding the use of the dependency in the state
            // We must stop adding behaviour on state.
            self.state = State(int: 42, bool: provider.getBool())
        }
    }

    // This is the only way...
    class StateInjectedViewModel {

        private(set) var state: State

        init(state: State) {
            self.state = state
        }
    }

    @Dependency(\.insideStateBoolProvider) private var insideStateBoolProvider

    func factory() {
        let state = State(int: 42, bool: insideStateBoolProvider.getBool())
        let viewModel = StateInjectedViewModel(state: state)
    }
}

extension InsideState.State {
    init(int: Int, bool: Bool) {
        self.int = int
        self.string = bool ? "true" : "false"
    }
}

import Dependencies

private enum InsideStateBoolProviderDependencyKey: DependencyKey {
    static let liveValue: InsideStateBoolProvider = TrueInsideStateBoolProvider()
}

extension DependencyValues {
    var insideStateBoolProvider: InsideStateBoolProvider {
        get { self[InsideStateBoolProviderDependencyKey.self] }
        set { self[InsideStateBoolProviderDependencyKey.self] = newValue }
    }
}
