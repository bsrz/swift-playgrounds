import Foundation

class AsyncMulticaster<T> {

    private var subscribers: [(T) async -> Void] = []
    private var continuation: AsyncStream<T>.Continuation?

    init() {
        let stream = AsyncStream<T> { continuation in
            self.continuation = continuation
        }

        // Auto-start
        Task { await publish(stream) }
    }

    func subscribe(_ subscriber: @escaping (T) async -> Void) {
        subscribers.append(subscriber)
    }

    private func publish(_ sequence: AsyncStream<T>) async {
        for await item in sequence {
            print("publishing item: \(item)")
            for subscriber in subscribers {
                await subscriber(item)
            }
        }
    }

    func send(_ value: T) {
        continuation?.yield(value)
    }

    func finish() {
        continuation?.finish()
    }
}
