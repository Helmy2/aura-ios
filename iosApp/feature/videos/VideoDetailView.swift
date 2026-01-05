import AVKit
import Photos
import Shared
import SwiftUI

struct VideoDetailView: View {
    let video: Video
    var onFavoriteToggle: ((Video) -> Void)?
    
    @State private var player: AVPlayer?
    @State private var isDownloading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isFavorite: Bool
    
    @Environment(\.presentationMode) var presentationMode

    init(video: Video, onFavoriteToggle: ((Video) -> Void)? = nil) {
        self.video = video
        self.onFavoriteToggle = onFavoriteToggle
        _isFavorite = State(initialValue: video.isFavorite)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                // Top Bar
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }

                    Spacer()

                    // NEW: Favorite Button
                    Button(action: toggleFav) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFavorite ? .red : .white)
                            .padding(10)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }

                    // Download Button
                    Button(action: downloadVideo) {
                        if isDownloading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "arrow.down.to.line")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                    }
                    .disabled(isDownloading)
                }
                .padding()
                .zIndex(10)

                Spacer()

                // ... Video Player & Bottom Info (Same as before) ...
                if let player = player {
                    VideoPlayer(player: player)
                        .onAppear {
                            player.play()
                        }
                } else {
                    ProgressView()
                        .tint(.white)
                }

                Spacer()

                // Bottom Info
                HStack {
                    Text("Video by \(video.user.name)")
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
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
        .alert(isPresented: $showToast) {
            Alert(title: Text(toastMessage))
        }
        .navigationBarHidden(true)
    }

    private func toggleFav() {
        isFavorite.toggle()
        onFavoriteToggle?(video)
    }

    private func setupPlayer() {
        guard let url = URL(string: video.videoUrl) else {
            return
        }
        let item = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: item)
    }

    private func downloadVideo() {
        guard let url = URL(string: video.videoUrl) else {
            return
        }
        isDownloading = true

        // 1. Create a destination URL with a proper extension (mp4)
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        let destinationURL = documentsURL.appendingPathComponent(
            "downloaded_video_\(video.id).mp4"
        )

        // Remove existing file if present
        try? fileManager.removeItem(at: destinationURL)

        // 2. Download
        let task = URLSession.shared.downloadTask(with: url) {
            tempLocalUrl,
            response,
            error in
            guard let tempLocalUrl = tempLocalUrl, error == nil else {
                DispatchQueue.main.async {
                    self.isDownloading = false
                    self.toastMessage =
                        "Download failed: \(error?.localizedDescription ?? "Unknown error")"
                    self.showToast = true
                }
                return
            }

            do {
                // 3. Move temp file to the destination with .mp4 extension
                try fileManager.moveItem(at: tempLocalUrl, to: destinationURL)

                // 4. Save to Photos
                self.saveToPhotos(localUrl: destinationURL)
            } catch {
                DispatchQueue.main.async {
                    self.isDownloading = false
                    self.toastMessage =
                        "File error: \(error.localizedDescription)"
                    self.showToast = true
                }
            }
        }
        task.resume()
    }

    private func saveToPhotos(localUrl: URL) {
        PHPhotoLibrary.shared().performChanges({
            // Request creation of asset from the valid local file
            PHAssetChangeRequest.creationRequestForAssetFromVideo(
                atFileURL: localUrl
            )
        }) { success, error in
            DispatchQueue.main.async {
                self.isDownloading = false
                if success {
                    self.toastMessage = "Saved to Photos"
                } else {
                    // Log the specific error code to help debug
                    self.toastMessage =
                        "Save failed: \(error?.localizedDescription ?? "Unknown")"
                    print("Photos Error: \(String(describing: error))")
                }
                self.showToast = true

                // 5. Cleanup the file in Documents directory
                try? FileManager.default.removeItem(at: localUrl)
            }
        }
    }

}
