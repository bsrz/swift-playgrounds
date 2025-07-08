import SwiftUI
import Combine
import Foundation

enum iTunes {

    struct Response: Codable {
        let resultCount: Int
        let results: [Artist]
    }

    struct Artist: Codable, Identifiable {
        var id: Int { artistId }
        let artistId: Int
        let artistName: String
        let primaryGenreName: String?
        let artistLinkUrl: String?
    }

    protocol ArtistService {
        func searchArtists(query: String) -> AnyPublisher<Response, Error>
    }

    class LiveArtistService: ArtistService {

        private let baseURL = "https://itunes.apple.com/search"
        private let session = URLSession.shared

        func searchArtists(query: String) -> AnyPublisher<Response, Error> {
            guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return Just(Response(resultCount: 0, results: []))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }

            var components = URLComponents(string: baseURL)!
            components.queryItems = [
                URLQueryItem(name: "term", value: query),
                URLQueryItem(name: "entity", value: "musicArtist"),
                URLQueryItem(name: "limit", value: "50")
            ]

            guard let url = components.url else {
                return Fail(error: URLError(.badURL))
                    .eraseToAnyPublisher()
            }

            return session.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: Response.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }

    class ArtistSearchViewModel: ObservableObject {

        @Published var searchText = ""
        @Published var artists: [Artist] = []
        @Published var isLoading = false
        @Published var errorMessage: String?

        private let service: ArtistService
        private var cancellables = Set<AnyCancellable>()

        init(service: ArtistService = LiveArtistService()) {
            self.service = service
            setupSearchDebouncing()
        }

        private func setupSearchDebouncing() {
            $searchText
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] searchTerm in
                    self?.searchArtists(query: searchTerm)
                }
                .store(in: &cancellables)
        }

        private func searchArtists(query: String) {
            guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                artists = []
                return
            }

            isLoading = true
            errorMessage = nil

            service.searchArtists(query: query)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = "Search failed: \(error.localizedDescription)"
                            self?.artists = []
                        }
                    },
                    receiveValue: { [weak self] response in
                        self?.artists = response.results
                    }
                )
                .store(in: &cancellables)
        }
    }

    struct ArtistSearchView: View {

        @StateObject private var viewModel = ArtistSearchViewModel()

        var body: some View {
            NavigationView {
                VStack {
                    searchBar
                    contentView
                    Spacer()
                }
                .navigationTitle("iTunes Artist Search")
            }
        }

        private var searchBar: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("Search for artists...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            .padding(.horizontal)
        }

        @ViewBuilder
        private var contentView: some View {
            if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else if viewModel.artists.isEmpty && !viewModel.searchText.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                artistsList
            }
        }

        private var artistsList: some View {
            List(viewModel.artists) { artist in
                ArtistRowView(artist: artist)
            }
            .listStyle(PlainListStyle())
        }

        private var emptyStateView: some View {
            VStack(spacing: 16) {
                Image(systemName: "music.note")
                    .font(.system(size: 50))
                    .foregroundColor(.secondary)

                Text("No artists found")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text("Try searching for a different artist name")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }

        private func errorView(message: String) -> some View {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 50))
                    .foregroundColor(.red)

                Text("Error")
                    .font(.headline)
                    .foregroundColor(.red)

                Text(message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }

    struct ArtistRowView: View {

        let artist: Artist

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(artist.artistName)
                    .font(.headline)
                    .lineLimit(1)

                if let genre = artist.primaryGenreName {
                    Text(genre)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    iTunes.ArtistSearchView()
}
