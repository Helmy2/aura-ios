import Shared
import SwiftUI

struct VideosView: View {
    @StateObject private var viewModel = VideosViewModel()
    @EnvironmentObject var coordinator: NavigationCoordinator

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { coordinator.pop() }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }

                Text("Videos")
                    .font(.headline)

                Spacer()
            }
            .padding()

            SearchBarView(
                text: $viewModel.searchQuery,
                isSearchActive: viewModel.isSearchMode,
                onSearch: { viewModel.onSearchTriggered() },
                onClear: { viewModel.onClearSearch() }
            )
                .padding(.horizontal)
                .padding(.vertical, 8)

            if viewModel.isLoading
                   && (viewModel.isSearchMode
                ? viewModel.searchVideos.isEmpty
                : viewModel.popularVideos.isEmpty) {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        let list =
                            viewModel.isSearchMode
                                ? viewModel.searchVideos : viewModel.popularVideos

                        ForEach(list, id: \.id) { video in
                            VideoGridCell(
                                video: video,
                                onTap: {
                                    coordinator.navigateToVideoDetail(
                                        video: video,
                                        onToggle: { v in
                                            viewModel.toggleFavorite(video: v)
                                        }
                                    )
                                },
                                onFavoriteToggle: {
                                    viewModel.toggleFavorite(video: video)
                                })
                            .onAppear {
                                if video == list.last {
                                    viewModel.loadNextPage()
                                }
                            }
                            }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    if viewModel.isPaginationLoading {
                        ProgressView()
                            .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadPopularVideos(reset: true)
        }
    }
}
