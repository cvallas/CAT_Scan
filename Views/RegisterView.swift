import SwiftUI

struct RegisterView: View {
    @AppStorage("storedUsername") private var storedUsername: String = ""
    @AppStorage("storedPassword") private var storedPassword: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack(spacing: 30) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)

            Button("Register") {
                register()
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    private func register() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            showError = true
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showError = true
            return
        }

        storedUsername = username
        storedPassword = password
        isLoggedIn = true
    }
}

#Preview {
    RegisterView()
}
