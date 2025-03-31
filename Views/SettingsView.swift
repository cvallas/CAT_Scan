import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("themeDarkMode") private var themeDarkMode = false
    @AppStorage("imageQuality") private var imageQuality = 1
    @State private var showResetAlert = false

    var body: some View {
        Form {
            Section(header: Text("Preferences").font(.headline)) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                
                Toggle("Dark Mode", isOn: $themeDarkMode)
                
                Stepper(value: $imageQuality, in: 1...5) {
                    Text("Image Quality: \(imageQuality)")
                }
            }

            Section(header: Text("Account").font(.headline)) {
                NavigationLink(destination: ProfileView()) {
                    Label("View Profile", systemImage: "person.crop.circle")
                }
            }

            Section(header: Text("App").font(.headline)) {
                Button(role: .destructive, action: {
                    showResetAlert = true
                }) {
                    Label("Reset Settings", systemImage: "arrow.counterclockwise")
                }
                .alert("Reset Settings?", isPresented: $showResetAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Reset", role: .destructive) {
                        resetSettings()
                    }
                } message: {
                    Text("This will restore all settings to their defaults.")
                }
            }
        }
        .navigationTitle("Settings")
    }

    /// Resets all settings to default values
    private func resetSettings() {
        notificationsEnabled = true
        themeDarkMode = false
        imageQuality = 1
    }
}

#Preview {
    SettingsView()
}
