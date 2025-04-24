import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isCamera = false
    @State private var isMenuOpen = false

    @State private var prediction: String?
    @State private var confidence: Double?
    @State private var isLoading = false
    @State private var scanAttempted = false

    @State private var selectedBreedInfo: BreedInfo?
    @State private var allBreeds: [BreedInfo] = []

    @State private var showBreedSheet = false
    @State private var showSaveSheet = false
    @State private var catName: String = ""

    let classifier = CatBreedClassifierHelper()!

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {

                    // === HAMBURGER ICON ===
                    HStack {
                        Button {
                            withAnimation { isMenuOpen.toggle() }
                        } label: {
                            Image(systemName: "line.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.horizontal)

                    // === CATSCAN TITLE ===
                    Text("CATscan")
                        .font(.custom("MilkywayDEMO", size: 80))
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    // === IMAGE DISPLAY WITH GLOW ===
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(10)
                            .shadow(color: isLoading ? .green.opacity(0.8) : .clear,
                                    radius: isLoading ? 20 : 0, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isLoading ? Color.green.opacity(0.5) : Color.clear, lineWidth: 3)
                                    .blur(radius: isLoading ? 2 : 0)
                            )
                            .padding()
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

                    // === PHOTO BUTTONS ===
                    HStack {
                        Button {
                            isCamera = false
                            isShowingImagePicker = true
                        } label: {
                            Label("Upload Photo", systemImage: "photo")
                                .font(.custom("MilkywayDEMO", size: 20))
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.theme.accent)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }

                        Button {
                            isCamera = true
                            isShowingImagePicker = true
                        } label: {
                            Label("Take Photo", systemImage: "camera")
                                .font(.custom("MilkywayDEMO", size: 20))
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.theme.accent)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // === DETECT / CLEAR BUTTONS ===
                    if selectedImage != nil {
                        HStack {
                            Button {
                                isLoading = true
                                scanAttempted = true

                                if let image = selectedImage {
                                    classifier.predictTopK(from: image, topK: 3) { results in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                            let confidenceThreshold: Double = 0.35
                                            if let topResult = results.first(where: { result in
                                                let resultID = result.label.components(separatedBy: " ").first ?? ""
                                                return result.confidence >= confidenceThreshold &&
                                                       allBreeds.contains(where: { $0.id == resultID })
                                            }) {
                                                let resultID = topResult.label.components(separatedBy: " ").first ?? ""
                                                prediction = topResult.label
                                                confidence = topResult.confidence
                                                selectedBreedInfo = allBreeds.first(where: { $0.id == resultID })
                                            } else {
                                                prediction = "❌ No cat breed could be detected."
                                                confidence = nil
                                                selectedBreedInfo = nil
                                            }
                                            isLoading = false
                                        }
                                    }
                                }
                            } label: {
                                Label("Detect Breed", systemImage: "pawprint")
                                    .font(.custom("MilkywayDEMO", size: 20))
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color.theme.accent)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }

                            Button {
                                selectedImage = nil
                                prediction = nil
                                confidence = nil
                                selectedBreedInfo = nil
                                isLoading = false
                                scanAttempted = false
                            } label: {
                                Label("Clear", systemImage: "xmark.circle")
                                    .font(.custom("MilkywayDEMO", size: 20))
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color.red.opacity(0.8))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // === SCANNING ANIMATION ===
                    if isLoading {
                        VStack(spacing: 16) {
                            Image(systemName: "pawprint.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                                .rotationEffect(Angle(degrees: 360))
                                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isLoading)

                            Text("Scanning...")
                                .font(.custom("MilkywayDEMO", size: 24))
                                .foregroundColor(.white)
                                .opacity(0.9)
                        }
                    }

                    // === RESULTS ===
                    if let prediction = prediction, let confidence = confidence, !isLoading {
                        VStack(spacing: 8) {
                            Text("Prediction: \(prediction)")
                                .font(.custom("MilkywayDEMO", size: 20))
                                .foregroundColor(.white)

                            Text(String(format: "Confidence: %.2f%%", confidence * 100))
                                .font(.custom("MilkywayDEMO", size: 20))
                                .foregroundColor(.white)

                            if selectedBreedInfo != nil {
                                Button("📖 See Details") {
                                    showBreedSheet = true
                                }
                                .padding(.top, 6)
                                .font(.custom("MilkywayDEMO", size: 18))
                                .foregroundColor(.blue)

                                Button("💾 Save This Cat") {
                                    showSaveSheet = true
                                }
                                .font(.custom("MilkywayDEMO", size: 18))
                                .foregroundColor(.green)
                            }
                        }
                        .padding(.top)
                    } else if prediction == "❌ No cat breed could be detected." && scanAttempted && !isLoading {
                        Text("❌ No cat breed could be detected.")
                            .foregroundColor(.red)
                            .font(.custom("MilkywayDEMO", size: 16))
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
            .background(Color.theme.background)
            .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                prediction = nil
                confidence = nil
                selectedBreedInfo = nil
                isLoading = false
                scanAttempted = false
            }) {
                ImagePicker(selectedImage: $selectedImage, isCamera: isCamera)
            }
            .sheet(isPresented: $showBreedSheet) {
                if let breed = selectedBreedInfo {
                    BreedInfoView(breed: breed, image: selectedImage)
                }
            }
            .sheet(isPresented: $showSaveSheet) {
                if let image = selectedImage, let breed = selectedBreedInfo {
                    SaveCatView(
                        image: image,
                        breed: breed,
                        catName: $catName,
                        onSave: { name in
                            UserProfileManager.shared.addCat(breed: breed, name: name, image: image)
                            showSaveSheet = false
                            catName = ""
                        },
                        onCancel: {
                            showSaveSheet = false
                            catName = ""
                        }
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: loadBreeds)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 100 {
                            withAnimation { isMenuOpen = false }
                        }
                    }
            )
        }
    }

    private func loadBreeds() {
        if let url = Bundle.main.url(forResource: "breeds", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([BreedInfo].self, from: data) {
            self.allBreeds = decoded
        }
    }
}
