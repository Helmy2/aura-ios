import Combine
import Foundation
import Shared

@MainActor
class VideosViewModel: ObservableObject {
    // MARK: - State
    @Published var popularVideos: [Video] = []
    @Published var searchVideos: [Video] = []
    @Published var isLoading: Bool = false
    @Published var isPaginationLoading: Bool = false
    @Published var errorMessage: String? = nil

    // Search State
    @Published var isSearchMode: Bool = false
    @Published var searchQuery: String = ""

    // Pagination State
    private var currentPage: Int = 1
    private var isEndReached: Bool = false

    // Dependencies
    private let repository: VideoRepository
    private let favoritesRepository: FavoritesRepository

    init() {
        self.repository = iOSApp.dependencies.videoRepository
        self.favoritesRepository = iOSApp.dependencies.favoritesRepository
    }

    // MARK: - Intents

    func loadPopularVideos(reset: Bool = false) {
        if reset {
            self.isLoading = true
            self.currentPage = 1
            self.popularVideos = []
            self.isEndReached = false
            self.isSearchMode = false
        } else {
            guard !isPaginationLoading && !isEndReached else {
                return
            }
            self.isPaginationLoading = true
        }

        performFetch(query: nil, page: currentPage, isSearch: false)
    }

    func onSearchTriggered() {
        guard !searchQuery.isEmpty else {
            return
        }
        self.isSearchMode = true
        self.isLoading = true
        self.currentPage = 1
        self.searchVideos = []
        self.isEndReached = false

        performFetch(query: searchQuery, page: 1, isSearch: true)
    }

    func onClearSearch() {
        self.isSearchMode = false
        self.searchQuery = ""
        self.isEndReached = false
    }

    func loadNextPage() {
        guard !isPaginationLoading && !isEndReached else {
            return
        }
        self.isPaginationLoading = true
        let nextPage = currentPage + 1

        if isSearchMode {
            performFetch(query: searchQuery, page: nextPage, isSearch: true)
        } else {
            performFetch(query: nil, page: nextPage, isSearch: false)
        }
    }

    // MARK: - Private Logic

    private func performFetch(query: String?, page: Int, isSearch: Bool) {
        Task {
            do {
                let result: [Video]
                if let query = query, isSearch {
                    result = try await repository.searchVideos(
                        query: query,
                        page: Int32(page)
                    )
                } else {
                    result = try await repository.getPopularVideos(
                        page: Int32(page)
                    )
                }

                if result.isEmpty {
                    self.isEndReached = true
                    self.isLoading = false
                    self.isPaginationLoading = false
                } else {
                    let uiResults = result

                    if isSearch {
                        if page == 1 {
                            self.searchVideos = uiResults
                        } else {
                            // Deduplicate
                            let existingIds = Set(
                                self.searchVideos.map {
                                    $0.id
                                }
                            )
                            let newUnique = uiResults.filter {
                                !existingIds.contains($0.id)
                            }
                            self.searchVideos.append(contentsOf: newUnique)
                        }
                    } else {
                        if page == 1 {
                            self.popularVideos = uiResults
                        } else {
                            let existingIds = Set(
                                self.popularVideos.map {
                                    $0.id
                                }
                            )
                            let newUnique = uiResults.filter {
                                !existingIds.contains($0.id)
                            }
                            self.popularVideos.append(contentsOf: newUnique)
                        }
                    }

                    self.currentPage = page
                    self.isLoading = false
                    self.isPaginationLoading = false
                }
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                self.isPaginationLoading = false
            }
        }
    }

    func toggleFavorite(video: Video) {
        Task {
            do {
                try await favoritesRepository.toggleFavorite(video: video)

                if let index = popularVideos.firstIndex(where: { $0.id == video.id }) {
                    let isFavorite = !popularVideos[index].isFavorite
                    popularVideos[index] = popularVideos[index].copy(isFavorite: isFavorite)
                }

                if let index = searchVideos.firstIndex(where: { $0.id == video.id }) {
                    let isFavorite = !searchVideos[index].isFavorite
                    searchVideos[index] = searchVideos[index].copy(isFavorite: isFavorite)
                }

            } catch {
                print("Failed to toggle favorite: \(error)")
            }
        }
    }
}
