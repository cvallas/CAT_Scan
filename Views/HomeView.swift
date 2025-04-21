import SwiftUI
import PhotosUI

struct HomeView: View {
    @Environment(\.colorScheme) var systemScheme
    @AppStorage("isDarkMode") private var isDarkMode = false

    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isCamera = false
    @State private var isMenuOpen = false

    @State private var prediction: String?
    @State private var confidence: Double?
    @State private var isLoading = false

    let classifier = CatBreedClassifierHelper()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    // Title
                    HStack(spacing: 10) {
                        Spacer()
                        Text("CATscan")
                            .font(.custom("MilkywayDEMO", size: 80))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top, 50)

                    // Image Display or Placeholder
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
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 300, height: 300)
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 50))
                                    .foregroundColor(.black)
                                Text("No Image Selected")
                                    .font(.custom("MilkywayDEMO", size: 20))
                                    .foregroundColor(.black)
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
                                .font(.custom("MilkywayDEMO", size: 20))
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.theme.accent)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            isCamera = true
                            isShowingImagePicker = true
                        }) {
                            Label("Take Photo", systemImage: "camera")
                                .font(.custom("MilkywayDEMO", size: 20))
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.theme.accent)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // Detect + Clear Buttons
                    if selectedImage != nil {
                        HStack {
                            Button(action: {
                                isLoading = true
                                if let image = selectedImage {
                                    classifier?.predict(image: image) { result, score in
                                        DispatchQueue.main.async {
                                            self.prediction = result
                                            self.confidence = score
                                            self.isLoading = false
                                        }
                                    }
                                }
                            }) {
                                Label("Detect Breed", systemImage: "pawprint")
                                    .font(.custom("MilkywayDEMO", size: 20))
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color.theme.accent)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }

                            Button(action: {
                                selectedImage = nil
                                prediction = nil
                                confidence = nil
                                isLoading = false
                            }) {
                                Label("Clear", systemImage: "xmark.circle")
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .font(.custom("MilkywayDEMO", size: 20))
                                    .background(Color.red.opacity(0.8))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Spinner while predicting
                    if isLoading {
                        ProgressView("Detecting breed...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }

                    // Prediction Result
                    if let prediction = prediction, let confidence = confidence {
                        VStack(spacing: 6) {
                            Text("Prediction: \(prediction)")
                                .font(.custom("MilkywayDEMO", size: 20))
                            Text(String(format: "Confidence: %.2f%%", confidence * 100))
                                .font(.custom("MilkywayDEMO", size: 20))
                                .foregroundColor(.black)
                        }
                        .padding(.top)
                    } else if selectedImage != nil && !isLoading {
                        Text("❌ No cat breed could be detected.")
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.top)
                    }

                    Spacer()
                }
                .padding()
                .blur(radius: isMenuOpen ? 5 : 0)

                // Sidebar
                if isMenuOpen {
                    SidebarMenu(isMenuOpen: $isMenuOpen)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                }
            }
            .background(Color.theme.background)
            .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                self.prediction = nil
                self.confidence = nil
                self.isLoading = false
            }) {
                ImagePicker(selectedImage: $selectedImage, isCamera: isCamera)
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation { isMenuOpen.toggle() }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    }
                }
            }
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
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
