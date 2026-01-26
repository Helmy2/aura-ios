import Shared
import SwiftUI

struct WallpaperGridCell: View {
    let wallpaper: Wallpaper
    let onTap: () -> Void
    var onFavoriteToggle: (() -> Void)

    var body: some View {
        ZStack(alignment: .bottom) {

            Button(action: onTap) {
                AsyncImage(url: URL(string: wallpaper.smallImageUrl)) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.2)
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    case .failure:
                        Color.red.opacity(0.2)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 220)
                .cornerRadius(20)
                .clipped()
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(wallpaper.photographer)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .shadow(radius: 2)
                }

                Spacer()

                Button(action: onFavoriteToggle) {
                    Image(
                        systemName: wallpaper.isFavorite
                            ? "heart.fill" : "heart"
                    ).font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(wallpaper.isFavorite ? .red : .white)
                        .shadow(radius: 2)
                }
            }
            .padding(10)
            .liquidGlass()
        }
    }
}
