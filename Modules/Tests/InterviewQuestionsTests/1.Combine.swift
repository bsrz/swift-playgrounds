@testable import InterviewQuestions
import Foundation
import Testing

struct Combine1Test {

    @Test
    func foo() async throws {
        let term = "Swift"
        let url = try #require(URL(string: "https://itunes.apple.com/search?entity=musicArtist&term=\(term)"))
        let (data, response) = try await URLSession.shared.data(from: url)

        let httpResponse = try #require(response as? HTTPURLResponse)

        #expect(httpResponse.statusCode == 200)

//        let string = String(decoding: data, as: UTF8.self)
//        print(string)

        let results = try JSONDecoder().decode(Results<Artist>.self, from: data)
        #expect(results.results.count > 0)

        print(Set(results.results.map(\.artistName)).sorted().joined(separator: "\n"))
    }

    @Test
    func succes() async throws {
        let service = ArtistService()

        service.searchForSwift()

        try await Task.sleep(for: .milliseconds(100))

        #expect(service.artists.count >= 0)
    }
}

