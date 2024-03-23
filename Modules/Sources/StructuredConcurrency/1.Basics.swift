import Foundation

enum Basics {

    // 1. Synchronous Function
    // all of the work happens in 🔀 order of execution
    // all of the work happens on the same 🧵 thread/queue
    static func f1() {
        print("f1")
    }

    // 2. Asynchronous Function
    // all of the work DOES NOT ⛔️ happens in 🔀 order of execution
    // all of the work DOES NOT ⛔️ happens on the same 🧵 thread/queue
    static func f2() {
        print("before f2")
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            print("during f2")
        }
        print("after f2")
    }

    // 3. Asynchronous Function
    // all of the work DOES ✅ happens in 🔀 order of execution
    // all of the work DOES NOT ⛔️ happens on the same 🧵 thread/queue
    static func f3() async throws {
        print("before f3")
        try await Task.sleep(for: .seconds(1))
        print("after f3")
    }

    // 4. A more concrete example
    // all of the work DOES ✅ happens in 🔀 order of execution
    // all of the work DOES NOT ⛔️ happens on the same 🧵 thread/queue
    static func f4() async throws {
        print("0. thread: \(Thread.current)")
        let url = URL(string: "https://hws.dev/news-1.json")!
        print("1. before network call")
        let (data, _) = try await URLSession.shared.data(from: url)
        print("2. thread: \(Thread.current)")
        print("3. after network call")
        print("4. Downloaded \(data.count) bytes")
    }

    // 5 Bridging the gap between async and sync functions
    // You can only call async functions from async context
    // Task provides async contexts
    static func f5() {
        // try await f4() 💥 will not compile
        // more or less equivalent to DispatchQueue.global().async { }
        // basically fire and forget
        Task { try await f4() }
    }

    // 6. Briding the gap between completion-based synchronous functions and asynchronous functions
    // Continuations provide a way to continue the task at a later time.
    // You can capture the continuation if needed.
    // e.g. once the completion closure is called
    static func f6() async -> Int {
        func withCompletion(_ completion: @escaping (Int) -> Void) {
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
                completion(42)
            }
        }

        let int = await withCheckedContinuation { continuation in
            withCompletion { int in
                continuation.resume(returning: int)
            }
        }

        return int
    }

    static func f7() async throws {
        try await Task.sleep(for: .seconds(1))
        print("do async work: \(Thread.current)")

        try await Task.sleep(for: .seconds(1))
        print("do more async work: \(Thread.current)")

        // finally, run the result on the main thread
        await MainActor.run {
            print("yay you're on the main thread: \(Thread.current)")
        }

        try await Task.sleep(for: .seconds(1))
        print("more work after main thread: \(Thread.current)")

        // or fire and forget
        Task { @MainActor in
            print("yup, still on the main thread: \(Thread.current)")
        }
    }
}
