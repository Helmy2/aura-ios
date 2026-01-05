import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("Aura")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(.top, 40)

            Text("Discover visual perfection")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)


            Button(action: { coordinator.navigateToWallpaperList() }) {
                MenuCard(title: "Wallpapers", icon: "photo.on.rectangle.angled", color: .purple)
            }

            Button(action: { coordinator.navigateToVideoList() }) {
                MenuCard(title: "Videos", icon: "play.rectangle.fill", color: .blue)
            }

            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
}

struct MenuCard: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(color.opacity(0.8))
                .clipShape(Circle())

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
