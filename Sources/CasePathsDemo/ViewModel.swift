import Observation

@Observable
class ViewModel {

  // MARK: - Navigation

  enum Destination {
    case profile(Profile)
  }

  private(set) var destination: Destination? = .none

  // MARK: - Lifecycle

  init(destination: Destination? = nil) {
    self.destination = destination
  }

  // MARK: - Input

  enum Action {
    case navigate(to: Destination?)
  }

  func send(_ action: Action) {
    switch action {
    case .navigate(let destination):
      self.destination = destination
    }
  }
}
