import Shared
import SwiftUI

@main
struct iOSApp: App {
    @StateObject private var coordinator = NavigationCoordinator()
    @State private var settingsViewModel: SettingsViewModel
    static let dependencies: DependenciesHelper = DependenciesHelper()

    init() {
        KoinHelperKt.doInitKoin()
        settingsViewModel = SettingsViewModel()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
                .preferredColorScheme(
                    getColorScheme(for: settingsViewModel.themeMode)
                )
        }
    }

    private func getColorScheme(for mode: ThemeMode) -> ColorScheme? {
        switch mode {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            HomeNavigationStack()
                .environmentObject(coordinator)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(NavigationCoordinator.Tab.home)

            FavoritesNavigationStack()
                .environmentObject(coordinator)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(NavigationCoordinator.Tab.favorites)

            SettingNavigationStack()
                .environmentObject(coordinator)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(NavigationCoordinator.Tab.settings)
        }
    }
}

// MARK: - Navigation Stacks

struct HomeNavigationStack: View {
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView()
                .navigationDestination(for: NavigationRoute.self) { route in
                    switch route {
                    case .wallpaperList:
                        WallpaperListView()
                    case .videoList:
                        VideosView()
                    case .wallpaperDetail(let wallpaper, let onToggle):
                        WallpaperDetailView(
                            wallpaper: wallpaper,
                            onFavoriteToggle: onToggle
                        )
                    case .videoDetail(let video, let onToggle):
                        VideoDetailView(
                            video: video,
                            onFavoriteToggle: onToggle
                        )
                    default: EmptyView()
                    }
                }
        }
    }
}

struct FavoritesNavigationStack: View {
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            FavoritesView()
                .navigationDestination(for: NavigationRoute.self) { route in
                    switch route {
                    case .wallpaperDetail(let wallpaper, let onToggle):
                        WallpaperDetailView(
                            wallpaper: wallpaper,
                            onFavoriteToggle: onToggle
                        )
                    case .videoDetail(let video, let onToggle):
                        VideoDetailView(
                            video: video,
                            onFavoriteToggle: onToggle
                        )
                            .toolbar(.hidden, for: .navigationBar)
                    default: EmptyView()
                    }
                }
        }
    }
}

struct SettingNavigationStack: View {
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            SettingsView()
        }
    }
}

struct VideosNavigationStack: View {
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VideosView()
                .navigationDestination(for: NavigationRoute.self) { route in
                    switch route {
                    case .videoDetail(let video, let onToggle):
                        VideoDetailView(
                            video: video,
                            onFavoriteToggle: onToggle
                        )
                            .toolbar(.hidden, for: .navigationBar)
                    default: EmptyView()
                    }
                }
        }
    }
}
