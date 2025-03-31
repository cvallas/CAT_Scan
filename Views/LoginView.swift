import SwiftUI

struct LoginView: View {
    @AppStorage("storedUsername") private var storedUsername: String = ""
    @AppStorage("storedPassword") private var storedPassword: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 30) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                Button("Login") {
                    login()
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                // ✅ Updated NavigationLink
                NavigationLink("Don't have an account? Register", value: "register")
                    .padding(.top, 10)
            }
            .padding()
            // ✅ Define where the link should navigate
            .navigationDestination(for: String.self) { value in
                if value == "register" {
                    RegisterView()
                }
            }
        }
    }

    private func login() {
        if username == storedUsername && password == storedPassword {
            isLoggedIn = true
        } else {
            errorMessage = "Invalid credentials."
            showError = true
        }
    }
}
