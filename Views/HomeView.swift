import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isCamera = false
    @State private var isMenuOpen = false

    @State private var prediction: String?
    @State private var confidence: Double?

    let classifier = CatBreedClassifierHelper()

    var body: some View {
        NavigationStack {
            ZStack {
                 
                    

                VStack(spacing: 20) {
                    Text("🐱 CATScan")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                         

                    
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
                                .fill(Color.white.opacity(0.4))
                                .frame(width: 300, height: 300)
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("No Image Selected")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                    }

                    // Upload + Take Buttons
                    HStack {
                        Button(action: {
                            isCamera = false
                            isShowingImagePicker = true
                        }) {
                            Label("Upload Photo", systemImage: "photo")
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(red: 0.4, green: 0.8, blue: 0.8)) // Seafoam green
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            isCamera = true
                            isShowingImagePicker = true
                        }) {
                            Label("Take Photo", systemImage: "camera")
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(red: 0.4, green: 0.7, blue: 1.0)) // Light blue
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // Detect Breed Button
                    if selectedImage != nil {
                        Button(action: {
                            if let image = selectedImage {
                                classifier?.predict(image: image) { result, score in
                                    DispatchQueue.main.async {
                                        self.prediction = result
                                        self.confidence = score
                                    }
                                }
                            }
                        }) {
                            Label("Detect Breed", systemImage: "pawprint")
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .transition(.opacity)
                    }

                    // Prediction Result
                    if let prediction = prediction, let confidence = confidence {
                        VStack(spacing: 6) {
                            Text("Prediction: \(prediction)")
                                .font(.headline)
                            Text(String(format: "Confidence: %.2f%%", confidence * 100))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)
                    } else if selectedImage != nil {
                        Text("❌ No cat breed could be detected.")
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.top)
                    }

                    Spacer()
                }
                .padding()
                .blur(radius: isMenuOpen ? 5 : 0)

                if isMenuOpen {
                    SidebarMenu(isMenuOpen: $isMenuOpen)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                }
            }
            .navigationTitle("Home")
            .navigationBarItems(leading: Button(action: {
                withAnimation {
                    isMenuOpen.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .padding()
            })
            .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                self.prediction = nil
                self.confidence = nil
            }) {
                ImagePicker(selectedImage: $selectedImage, isCamera: isCamera)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 100 {
                            withAnimation {
                                isMenuOpen = false
                            }
                        }
                    }
            )
        }
    }
}

#Preview {
    HomeView()
}
