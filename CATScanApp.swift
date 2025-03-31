import SwiftUI

@main
struct CATScanApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}
