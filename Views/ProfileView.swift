import SwiftUI

struct ProfileView: View {
    @AppStorage("displayName") private var displayName = "User"
    @AppStorage("email") private var email = "user@example.com"

    @State private var showImagePicker = false
    @State private var profileImage: UIImage? = UIImage(systemName: "person.circle.fill") // Default icon
    @State private var scannedImages: [UIImage] = [] // Placeholder for uploaded images

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    }
                    Button("Change Profile Picture") {
                        showImagePicker = true
                    }
                    Text(displayName)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(email)
                        .foregroundColor(.gray)
                }
                .padding()

                Divider()

                // Scanned Image Gallery
                VStack(alignment: .leading) {
                    HStack {
                        Text("📸 Scanned Cats")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)

                    if scannedImages.isEmpty {
                        Text("No scans yet. Upload your first scanned cat!")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(scannedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 3)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: Binding(
                get: { nil },
                set: { newImage in
                    if let newImage = newImage {
                        scannedImages.append(newImage) // Store images locally for now
                    }
                }
            ), isCamera: false)
        }
    }
}

#Preview {
    ProfileView()
}
