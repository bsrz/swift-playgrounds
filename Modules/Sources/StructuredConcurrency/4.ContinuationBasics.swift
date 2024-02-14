import Foundation

struct Message: Decodable, Identifiable {
    let id: Int
    let from: String
    let message: String
}

struct ContinuationBasics {

    let url = URL(string: "https://hws.dev/user-messages.json")!

    // 1. Completion closure version of the method
    func f1(_ completion: @escaping (Result<[Message], Error>) -> Void) {
        URLSession.shared
            .dataTask(with: url) { data, response, error in
                if let error {
                    return completion(.failure(error))
                }
                
                guard let data else { return completion(.success([])) }

                do {
                    let messages = try JSONDecoder().decode([Message].self, from: data)
                    completion(.success(messages))
                } catch {
                    completion(.failure(error))
                }
            }
            .resume()
    }

    // 2. Making use of continuations to convert the closure-based version to modern concurrency
    func f2() async throws -> [Message] {
        try await withCheckedThrowingContinuation { continuation in
            f1 { result in
                switch result {
                case .success(let messages):
                    continuation.resume(returning: messages)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
