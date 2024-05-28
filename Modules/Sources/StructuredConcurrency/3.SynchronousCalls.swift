import Foundation

struct Foo {
    var int: Int
    var string: String
}

enum SynchronousCalls {

    static func getFoo() async throws -> Foo {
        try await Task.sleep(for: .milliseconds(250))
        return Foo(int: 42, string: "hello")
    }

    // 1. 💥 You cannot call an async function from a synchronous function
    // func f1() -> Foo {
    //     Task { try await getFoo() }
    //     return ???
    // }

    // 2. 💥 You cannot use Semaphores
    // 💥 You cannot mutate captured 🎣 variables in concurrently executing code, the compiler will scream at you
    // func f2() -> Foo {
    //     let semaphore = DispatchSemaphore(value: 0)
    //
    //     var foos: [Foo] = []
    //
    //     Task {
    //         let foo = try await getFoo()
    //         foos.append(foo) // 💥 Mutation of captured var 'foos' in concurrently-executing code
    //         semaphore.signal()
    //     }
    //
    //     semaphore.wait()
    //     return foos.first!
    // }

    // 3. You must use completion closures
    static func f3(_ completion: @escaping (Foo) -> Void) {
        Task {
            let foo = try await getFoo()
            completion(foo)
        }
    }
}
