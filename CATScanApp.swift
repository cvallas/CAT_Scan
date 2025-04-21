import SwiftUI

@main
struct CATScanApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var colorScheme: ColorScheme? = nil

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                let homeView = HomeView()
                if let scheme = colorScheme {
                    homeView.environment(\.colorScheme, .light)
                } else {
                    homeView
                }
            } else {
                let loginView = LoginView()
                if let scheme = colorScheme {
                    loginView.environment(\.colorScheme, .light)
                } else {
                    loginView
                }
            }
        }
    }
}

