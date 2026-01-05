import Foundation
import Observation
import Shared

@Observable
class FavoritesViewModel {

    // MARK: - State
    var favorites: [MediaContent] = []
    var isLoading: Bool = true
    var errorMessage: String? = nil

    private let wallpaperRepository: WallpaperRepository
    private let favoritesRepository: FavoritesRepository
    private let videoRepository: VideoRepository

    private var observationTask: Task<Void, Never>? = nil

    init() {
        self.wallpaperRepository = iOSApp.dependencies.wallpaperRepository
        self.favoritesRepository = iOSApp.dependencies.favoritesRepository
        self.videoRepository = iOSApp.dependencies.videoRepository
    }

    // MARK: - Lifecycle

    func startObserving() {
        stopObserving()

        isLoading = true

        observationTask = Task { @MainActor in
            for await items in favoritesRepository.observeFavorites() {
                self.favorites = items
                self.isLoading = false
            }
        }
    }

    func stopObserving() {
        observationTask?.cancel()
        observationTask = nil
    }

    // MARK: - Intents

    func toggleFavorite(video: Video) {
        Task {
            do {
                try await favoritesRepository.toggleFavorite(video: video)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func toggleFavorite(wallpaper: Wallpaper) {
        Task {
            do {
                try await favoritesRepository.toggleFavorite(wallpaper: wallpaper)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
