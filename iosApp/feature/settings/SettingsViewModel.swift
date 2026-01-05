import Foundation
import Shared
import Observation

@Observable
class SettingsViewModel {

    private let repository: SettingsRepository
    private var observationTask: Task<Void, Never>? = nil

    var themeMode: ThemeMode = .system
    var isLoading = false
    var errorMessage: String?

    init() {
        self.repository = iOSApp.dependencies.settingsRepository
        observeThemeMode()
    }

    deinit {
        observationTask?.cancel()
    }

    func updateThemeMode(_ mode: ThemeMode) {
        Task {
            do {
                try await repository.updateThemeMode(mode: mode)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func observeThemeMode() {
        self.isLoading = true

        observationTask?.cancel()

        observationTask = Task { @MainActor in
            for await mode in repository.observeThemeMode() {
                self.themeMode = mode
                self.isLoading = false
            }
        }
    }
}
