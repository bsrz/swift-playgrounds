import Foundation

protocol Delegate: AnyObject {
    func didFail(with error: Error)
    func didSucceed(int: Int)
}

enum ManagerError: Error {
    case unexpected
}

class Manager {

    weak var delegate: Delegate?

    func start() {
        switch [true, false].randomElement()! {
        case true:
            Thread.sleep(forTimeInterval: 1)
            delegate?.didSucceed(int: [1, 2, 3].randomElement() ?? 0)

        case false:
            Thread.sleep(forTimeInterval: 1)
            delegate?.didFail(with: ManagerError.unexpected)
        }
    }
}

class BeyondContinuations {

    let manager = Manager()

    // We save the continuation for when the delegate conformance will be called
    private var continuation: CheckedContinuation<Int, Error>?

    init() {
        manager.delegate = self
    }

    func start() async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation // save for later
            self.manager.start()
        }
    }
}

// We make use of the continuation in the delegate calls
extension BeyondContinuations: Delegate {
    func didFail(with error: Error) {
        continuation?.resume(throwing: error) // resumes the suspected task at line 41
    }
    func didSucceed(int: Int) {
        continuation?.resume(returning: int) // resumes the suspected task at line 41
    }
}
