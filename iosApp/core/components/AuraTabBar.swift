import SwiftUI

struct AuraTabBar: View {
    @Binding var selectedTab: NavigationCoordinator.Tab

    var body: some View {
        HStack {
            Spacer()

            TabBarButton(
                icon: "house.fill",
                label: "Home",
                isSelected: selectedTab == .home,
                action: { selectedTab = .home }
            )

            Spacer()

            TabBarButton(
                icon: "heart.fill",
                label: "Favorites",
                isSelected: selectedTab == .favorites,
                action: { selectedTab = .favorites }
            )

            Spacer()

            TabBarButton(
                icon: "gearshape.fill",
                label: "Settings",
                isSelected: selectedTab == .settings,
                action: { selectedTab = .settings }
            )

            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 2)
        .safeAreaPadding(.bottom)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .background(
            VStack {
                Divider().background(Color.gray.opacity(0.3))
                Spacer()
            }
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    @State private var animateTrigger = false

    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .symbolEffect(.bounce, value: animateTrigger)

                Text(label)
                    .font(.caption2)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .foregroundColor(isSelected ? .primary : .secondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .onChange(of: isSelected) { oldValue, newValue in
            if newValue {
                animateTrigger.toggle()
            }
        }
    }
}
