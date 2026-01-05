//
//  NavigationRoute.swift
//  iosApp
//
//  Created by platinum on 27/12/2025.
//

import Foundation
import Shared

enum NavigationRoute: Hashable {
    case home
    case favorites
    case settings
    case wallpaperDetail(Wallpaper, (Wallpaper) -> Void)
    case videoDetail(Video, (Video) -> Void)
    case wallpaperList
    case videoList

    func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            hasher.combine(0)
        case .favorites:
            hasher.combine(1)
        case .settings:
            hasher.combine(2)
        case .wallpaperDetail(let w, _):
            hasher.combine("wallpaperDetail")
            hasher.combine(w.id)
        case .videoDetail(let video, _):
            hasher.combine(4)
            hasher.combine(video.id)
        case .wallpaperList:
            hasher.combine(5)
        case .videoList:
            hasher.combine(6)
        }
    }

    static func ==(lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home),
             (.favorites, .favorites),
             (.settings, .settings),
             (.wallpaperList, .wallpaperList),
             (.videoList, .videoList):
            return true

        case (.wallpaperDetail(let w1, _), .wallpaperDetail(let w2, _)):
            return w1.id == w2.id

        case (.videoDetail(let v1, _), .videoDetail(let v2, _)):
            return v1.id == v2.id

        default:
            return false
        }
    }
}
