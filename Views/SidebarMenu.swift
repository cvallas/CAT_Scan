import SwiftUI

struct SidebarMenu: View {
    @Binding var isMenuOpen: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.green)
                    }
                    .padding()
                }

                Text("Menu")
                    .font(.custom("MilkywayDEMO", size: 32))
                    .foregroundColor(.green)
                    .padding(.horizontal)

                NavigationLink(destination: HomeView()) {
                    Text("Home")
                        .font(.custom("MilkywayDEMO", size: 24))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }

                NavigationLink(destination: ProfileView()) {
                    Text("Profile")
                        .font(.custom("MilkywayDEMO", size: 24))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 50)
            .frame(maxWidth: 280, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
