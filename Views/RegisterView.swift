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
        ZStack {
            Color.theme.background // your full-screen color
                .ignoresSafeArea() // this makes it full screen
            VStack(spacing: 30) {
                
                Text("Create Account")
                    .font(.custom("MilkywayDEMO", size: 45))
                    .fontWeight(.bold)
                
                TextField("Username", text: $username)
                    .font(.custom("MilkywayDEMO", size: 20))
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $password)
                    .font(.custom("MilkywayDEMO", size: 20))
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .font(.custom("MilkywayDEMO", size: 20))
                    .textFieldStyle(.roundedBorder)
                
                Button("Register") {
                    
                    register()
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.accentColor)
                .font(.custom("MilkywayDEMO", size: 20))
                .foregroundColor(.white)
                .cornerRadius(10)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                    
                }
                
            }
            .padding()
            .background(Color.theme.background.ignoresSafeArea())
            
        }
        .background(Color.theme.background.ignoresSafeArea())
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
