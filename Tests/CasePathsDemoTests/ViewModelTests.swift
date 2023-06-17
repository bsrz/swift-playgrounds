@testable import CasePathsDemo
import CasePaths
import XCTest

class ViewModelTests: XCTestCase {
  func testViewModel_whenInstantiated_thenInitialValueIsNil() {
    let sut = ViewModel()
    XCTAssertNil(sut.destination)
  }

  func testViewModel_givenInitialized_whenSentProfileAction_thenUpdatesDestinationWithProfile_usingTraditionalAssertion() {
    let profile = Profile(name: name)
    let sut = ViewModel()
    sut.send(.navigate(to: .profile(profile)))

    guard case .profile(let result) = sut.destination else { return XCTFail() }

    XCTAssertEqual(result, profile)
  }

  func testViewModel_givenInitialized_whenSentProfileAction_thenUpdatesDestinationWithProfile_usingCasePaths() throws {
    let profile = Profile(name: name)
    let sut = ViewModel()
    sut.send(.navigate(to: .profile(profile)))

    let result = try XCTUnwrap(sut.destination, case: /ViewModel.Destination.profile)
    XCTAssertEqual(result, profile)
  }
}
