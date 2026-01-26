import SwiftUI
import Shared

struct WallpaperListView: View {
    @State private var viewModel = WallpaperListViewModel()
    @EnvironmentObject var coordinator: NavigationCoordinator

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(
                text: $viewModel.searchQuery,
                isSearchActive: viewModel.isSearchMode,
                onSearch: { viewModel.onSearchTriggered() },
                onClear: { viewModel.onClearSearch() }
            )
                .padding(.horizontal)
                .padding(.bottom, 8)

            if viewModel.isLoading && (viewModel.isSearchMode ? viewModel.searchWallpapers.isEmpty : viewModel.wallpapers.isEmpty) {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        let list = viewModel.isSearchMode ? viewModel.searchWallpapers : viewModel.wallpapers

                        ForEach(list, id: \.id) { wallpaper in
                            WallpaperGridCell(
                                wallpaper: wallpaper,
                                onTap: {
                                    coordinator.navigateToWallpaperDetail(wallpaper: wallpaper) { w in
                                        viewModel.toggleFavorite(wallpaper: w)
                                    }
                                },
                                onFavoriteToggle: { viewModel.toggleFavorite(wallpaper: wallpaper) }
                            )
                                .onAppear {
                                    if wallpaper == list.last {
                                        viewModel.loadNextPage()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    if viewModel.isPaginationLoading {
                        ProgressView().padding()
                    }
                }
            }
        }
        .navigationTitle("Wallpapers")
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            if viewModel.wallpapers.isEmpty && !viewModel.isLoading {
                viewModel.loadCuratedWallpapers(reset: true)
            }
        }
    }
}
