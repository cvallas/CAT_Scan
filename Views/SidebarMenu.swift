import SwiftUI

struct SidebarMenu: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("📁 Menu")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)

            Divider()

            NavigationLink(destination: HomeView()) {
                Label("Home", systemImage: "house")
                    .padding()
            }

            NavigationLink(destination: Text("Settings Page")) {
                Label("Settings", systemImage: "gear")
                    .padding()
            }

            NavigationLink(destination: Text("Profile Page")) {
                Label("Profile", systemImage: "person")
                    .padding()
            }

            Spacer()
        }
        .frame(maxWidth: 250, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}
