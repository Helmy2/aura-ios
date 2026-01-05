import SwiftUI
import Shared

struct VideoGridCell: View {
    let video: Video
    var onTap: (() -> Void)
    var onFavoriteToggle: (() -> Void)

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Button(action: onTap) {
                AsyncImage(url: URL(string: video.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.2)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    case .failure:
                        Color.red.opacity(0.2)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 220)
                .cornerRadius(12)
                .clipped()
            }

            HStack {
                Text(video.user.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .shadow(radius: 2)

                Spacer()

                Button(action: onFavoriteToggle) {
                    Image(
                        systemName: video.isFavorite
                            ? "heart.fill" : "heart"
                    )
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(video.isFavorite ? .red : .white)
                        .shadow(radius: 2)
                }
            }
            .padding(10)
            .background(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

            VStack {
                Text(formatDuration(Int(video.duration)))
                    .font(.caption)
                    .bold()
                    .padding(6)
                    .background(.black.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .padding(8)
                Spacer()

            }

        }
    }

    func formatDuration(_ seconds: Int) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        return String(format: "%d:%02d", min, sec)
    }
}
