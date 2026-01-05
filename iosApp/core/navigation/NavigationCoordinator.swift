import Observation
import Shared
import SwiftUI

@MainActor
class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: Tab = .home

    enum Tab {
        case home
        case favorites
        case settings
    }

    func navigateToWallpaperList() {
        path.append(NavigationRoute.wallpaperList)
    }

    func navigateToVideoList() {
        path.append(NavigationRoute.videoList)
    }

    func navigateToWallpaperDetail(wallpaper: Wallpaper, onToggle: @escaping (Wallpaper) -> Void) {
        path.append(NavigationRoute.wallpaperDetail(wallpaper, onToggle))
    }

    func navigateToVideoDetail(video: Video, onToggle: @escaping (Video) -> Void) {
        path.append(NavigationRoute.videoDetail(video, onToggle))
    }

    // Pop to root
    func popToRoot() {
        path.removeLast(path.count)
    }

    // Pop one level
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    // Switch tab
    func switchToTab(_ tab: Tab) {
        selectedTab = tab
        popToRoot()
    }
}
