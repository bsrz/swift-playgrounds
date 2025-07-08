import Combine
import Foundation

/*:
 # Combine Memory Management & Error Handling

 ## Scenario

 You have a networking service that fetches user data.
 The candidate should identify memory leaks and improve error handling.
 */

import Combine
import Foundation

struct Artist: Codable {
    let wrapperType: String
    let artistType: String
    let artistName: String
    let artistLinkUrl: String
    let artistId: Int
    let primaryGenreName: String?
    let primaryGenreId: Int?
}

struct Results<T: Codable>: Codable {
    var results: [T]
}

class ArtistService: ObservableObject {
    @Published var artists: [Artist] = []
    @Published var isLoading = false

    private let networkClient = ArtistNetworkClient()

    func searchForSwift() {
        isLoading = true

        networkClient.searchMusicArtists(for: "Swift")
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                // What's wrong here? How would you handle errors?
            }, receiveValue: { results in
                self.artists = results.results
            })
        // What's missing here that prevents the request from executing?
    }
}

class ArtistNetworkClient {
    func searchMusicArtists(for term: String) -> AnyPublisher<Results<Artist>, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "https://itunes.apple.com/search?entity=musicArtist&term=\(term)")!)
            .map(\.data)
            .decode(type: Results<Artist>.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
