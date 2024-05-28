import Combine

extension Publisher {
    func asyncMap<T>(_ transform: @escaping (Output) async -> T) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }

    func throwingAsyncMap<T>(_ transform: @escaping (Output) async throws -> T) -> Publishers.FlatMap<Future<T, Error>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}

enum DataStoreError: Error {
    case unexpected
}

class CombineDataStore {

    func fetch() -> AnyPublisher<Int, DataStoreError> {
        switch [true, false].randomElement()! {
        case true:
            return Just(42)
                .setFailureType(to: DataStoreError.self)
                .eraseToAnyPublisher()

        case false:
            return Fail(error: .unexpected)
                .eraseToAnyPublisher()
        }
    }
}

func mapToString(int: Int) async throws -> String {
    try await Task.sleep(for: .seconds(1))
    return "int value is: \(int)"
}
