import Foundation

struct User {
    var id: Int
}

func makeUser(id: Int) -> User {
    User(id: id)
}

func makeUser(id: Int) async throws -> User {
    let time = [250, 500].randomElement()!
    try await Task.sleep(for: .milliseconds(time))
    print("creating id: \(id)")
    return User(id: id)
}

enum BeyondBasics {

    // 1. Parallelism using queues
    // we want to create 2 users in parallel
    static func f1() {
        var users: [User] = []
        let later = { print(users) }

        DispatchQueue.global().async {
            let user = makeUser(id: 1)
            users.append(user)
            later()
        }

        DispatchQueue.global().async {
            let user = makeUser(id: 2)
            users.append(user)
            later()
        }

        DispatchQueue.global().async {
            later()
        }
    }

    // 2. Parallelism using concurrency
    // we want to create 2 users in parallel
    static func f2() async throws {
        async let user1 = await makeUser(id: 1)
        async let user2 = await makeUser(id: 2)

        // Creating ``async let`` variables does not execute anything.
        // Awaiting them is what triggers the work to start.

        let users = try await [user1, user2]
        print(users)

        // or you can "dispatch" the work in their own tasks
        // however, this execute the work even if the task aren't awaited

        let user3 = Task { try await makeUser(id: 3) }
        let user4 = Task { try await makeUser(id: 4) }

        let users2 = try await [user3.value, user4.value]
        print(users2)
    }

    // 3. Using a TaskGroup to create a lot of parallel tasks
    static func f3() async throws {
        let users = try await withThrowingTaskGroup(of: User.self) { group in
            for i in 0..<100 {
                group.addTask {
                    try await Task.sleep(for: .milliseconds(100))
                    return try await makeUser(id: i)
                }
            }

            // The 🔀 order of tasks is NOT guaranteed
            return try await group.reduce(into: []) { users, user in
                users.append(user)
            }
        }

        print(users)
    }
}
