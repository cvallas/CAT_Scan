import SwiftUI

struct SidebarMenu: View {
    @Binding var isMenuOpen: Bool  // Controls menu state
    @State private var navigationSelection: String? = nil  // Holds selected navigation option

    var body: some View {
        NavigationStack {
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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 20)

                Divider()
                    .padding(.horizontal)

                // Navigation Buttons
                NavigationLink(destination: HomeView()) {
                    Label("Home", systemImage: "house")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: ProfileView()) {
                    Label("Profile", systemImage: "person")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(maxWidth: 250, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        }
    }
}
