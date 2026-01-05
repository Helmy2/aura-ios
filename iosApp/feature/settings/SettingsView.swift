import Shared
import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        List {
            Section {
                Picker("Theme", selection: Binding(
                    get: { viewModel.themeMode },
                    set: { viewModel.updateThemeMode($0) }
                )) {
                    Text("System Default").tag(ThemeMode.system)
                    Text("Light").tag(ThemeMode.light)
                    Text("Dark").tag(ThemeMode.dark)
                }
                .pickerStyle(.menu)
            } header: {
                Text("Appearance")
            } footer: {
                Text("Choose how Aura looks on your device.")
            }
        }
        .navigationTitle("Settings")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}
