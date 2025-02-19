import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isCamera = false // Determines if camera or library is selected

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // App Title
                Text("🐱 CATScan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                // Display selected image or placeholder
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 300, height: 300)
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No Image Selected")
                                .foregroundColor(.gray)
                        }
                    }
                }

                // Buttons for selecting images
                HStack {
                    Button(action: {
                        isCamera = false
                        isShowingImagePicker = true
                    }) {
                        Label("Upload Photo", systemImage: "photo")
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        isCamera = true
                        isShowingImagePicker = true
                    }) {
                        Label("Take Photo", systemImage: "camera")
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .buttonStyle(.borderless) // Prevents button styling issues in sheets

                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, isCamera: isCamera)
            }
        }
    }
}

#Preview {
    HomeView()
}
