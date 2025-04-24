import SwiftUI

@main
struct CATScanApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView() // show animated intro first
                .preferredColorScheme(.dark) // 🔒 Always use dark mode

        }
    }
}
