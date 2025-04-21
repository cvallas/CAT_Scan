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
            ZStack {
                Color.theme.background // your full-screen color
                    .ignoresSafeArea() // this makes it full screen
                
                VStack(spacing: 30) {
                    Text("Login")
                        .font(.custom("MilkywayDEMO", size: 50))
                        .fontWeight(.bold)
                    
                    TextField("Username", text: $username)
                        .font(.custom("MilkywayDEMO", size: 20))
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Password", text: $password)
                        .font(.custom("MilkywayDEMO", size: 20))
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Login") {
                        
                        login()
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
                    
                    // ✅ Updated NavigationLink
                    NavigationLink("Don't have an account? Register", value: "register")
                        .font(.custom("MilkywayDEMO", size: 20))
                        .padding(.top, 10)
                }
                .padding()
                .background(Color.theme.background)
                // ✅ Define where the link should navigate
                .navigationDestination(for: String.self) { value in
                    if value == "register" {
                        RegisterView()
                    }
                }
                .background(Color.theme.background)
            }
            
        }
        .background(Color.theme.background)
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
#Preview {
    
    LoginView()
}

