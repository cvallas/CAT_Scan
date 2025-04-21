import SwiftUI

struct SidebarMenu: View {
    @Binding var isMenuOpen: Bool  // Controls menu state
    @State private var navigationSelection: String? = nil  // Holds selected navigation option

    var body: some View {
        NavigationStack {
            ZStack{
                Color.theme.background // your full-screen color
                    .ignoresSafeArea() // this makes it full screen
                
                VStack(alignment: .leading, spacing: 20) {
                    // Close Button
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isMenuOpen = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                                .padding()
                                
                        }
                    }
                    
                    Text("📁 Menu")
                        .font(.custom("MilkywayDEMO", size: 20))
                        .foregroundColor(.white)    
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                       
                    
                    Divider()
                        .padding(.horizontal)
                        
                    
                    // Navigation Buttons
                    NavigationLink(destination: HomeView()) {
                        Label("Home", systemImage: "house")
                            .font(.custom("MilkywayDEMO", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.theme.accent)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                            .font(.custom("MilkywayDEMO", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.theme.accent)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: ProfileView()) {
                        Label("Profile", systemImage: "person")
                            .font(.custom("MilkywayDEMO", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.theme.accent)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    
                    Spacer()
                }
                .frame(maxWidth: 250, maxHeight: .infinity, alignment: .topLeading)
             //   .background(Color.theme.accent)
                .background(Color.theme.accent2)
              //  .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
            }
        }
        
        }
    
}
#Preview {
    SidebarMenu(isMenuOpen: .constant(true)) // or .constant(false)
}

