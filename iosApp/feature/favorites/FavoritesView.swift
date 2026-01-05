import Shared
import SwiftUI

struct FavoritesView: View {
    @State private var viewModel = FavoritesViewModel()
    @EnvironmentObject var coordinator: NavigationCoordinator

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        content
        .onAppear {
            viewModel.startObserving()
        }
        .onDisappear {
            viewModel.stopObserving()
        }
    }

    // MARK: - Subviews
    private var content: some View {
        Group {
            if viewModel.isLoading {
                loadingSpinner
            } else if viewModel.favorites.isEmpty {
                emptyStateView
            } else {
                favoritesGrid
            }
        }
    }

    private var loadingSpinner: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.fill")
                .font(.system(size: 80))
                .foregroundStyle(.pink.opacity(0.3))

            Text("No favorites yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text(
                "Start adding wallpapers to your favorites\nby tapping the heart icon"
            )
                .font(.body)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var favoritesGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.favorites, id: \.id) { item in
                    MediaContentGridCell(
                        content: item,
                        onWallpaperNavigate: { wallpaper in
                            coordinator.navigateToWallpaperDetail(
                                wallpaper: wallpaper
                            ) { w in
                                viewModel.toggleFavorite(wallpaper: w)
                            }
                        },
                        onRemoveWallpaperFavorite: { wallpaper in
                            viewModel.toggleFavorite(wallpaper: wallpaper)
                        },
                        onVideoNavigate: { video in
                            coordinator.navigateToVideoDetail(video: video) {
                                w in
                                viewModel.toggleFavorite(video: w)
                            }
                        },
                        onRemoveVideoFavorite: { video in
                            viewModel.toggleFavorite(video: video)
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}

struct MediaContentGridCell: View {
    let content: MediaContent
    var onWallpaperNavigate: (Wallpaper) -> Void
    var onRemoveWallpaperFavorite: (Wallpaper) -> Void

    var onVideoNavigate: (Video) -> Void
    var onRemoveVideoFavorite: (Video) -> Void

    var body: some View {
        switch onEnum(of: content) {
        case .wallpaperContent(let content):
            WallpaperGridCell(
                wallpaper: content.wallpaper,
                onTap: { onWallpaperNavigate(content.wallpaper) },
                onFavoriteToggle: { onRemoveWallpaperFavorite(content.wallpaper) },
                )

        case .videoContent(let content):
            VideoGridCell(
                video: content.video,
                onTap: { onVideoNavigate(content.video) },
                onFavoriteToggle: { onRemoveVideoFavorite(content.video) },
                )
        }
    }
}
