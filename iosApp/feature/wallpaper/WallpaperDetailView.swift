import Shared
import SwiftUI

struct WallpaperDetailView: View {
    let wallpaper: Wallpaper
    var onFavoriteToggle: ((Wallpaper) -> Void)?

    @State private var isFavorite: Bool
    @State private var isDownloading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @Environment(\.presentationMode) var presentationMode

    init(wallpaper: Wallpaper, onFavoriteToggle: ((Wallpaper) -> Void)? = nil) {
        self.wallpaper = wallpaper
        self.onFavoriteToggle = onFavoriteToggle
        _isFavorite = State(initialValue: wallpaper.isFavorite)
    }

    var body: some View {
        ZStack {
            Color(hex: wallpaper.averageColor).ignoresSafeArea()
            AsyncImage(url: URL(string: wallpaper.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView().tint(.white)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)

                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            // Top Controls
            VStack {
                Spacer()

                // Bottom Info
                HStack {
                    Text("Photo by \(wallpaper.photographer)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .toolbar(.hidden, for: .bottomBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleFav) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavorite ? .red : .gray)
                }

            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: downloadWallpaper) {
                    if isDownloading {
                        ProgressView()
                    } else {
                        Image(systemName: "arrow.down.to.line")
                            .font(.title2)
                    }
                }
            }
        }
        .alert(isPresented: $showToast) {
            Alert(title: Text(toastMessage))
        }
    }

    private func toggleFav() {
        isFavorite.toggle()
        onFavoriteToggle?(wallpaper)
    }

    private func downloadWallpaper() {
        isDownloading = true
        Task {
            guard let url = URL(string: wallpaper.imageUrl),
                let (data, _) = try? await URLSession.shared.data(from: url),
                let image = UIImage(data: data)
            else {
                isDownloading = false
                return
            }

            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

            await MainActor.run {
                isDownloading = false
                toastMessage = "Saved to Photos"
                showToast = true
            }
        }
    }
}
