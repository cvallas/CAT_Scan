import SwiftUI
import PhotosUI

struct TopPrediction: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Double
}

struct HomeView: View {
    // MARK: - State Variables
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isCamera = false
    @State private var isMenuOpen = false

    @State private var topPredictions: [TopPrediction] = []
    @State private var prediction: String?
    @State private var confidence: Double?
    @State private var isLoading = false
    @State private var scanAttempted = false

    @State private var selectedBreedInfo: BreedInfo?
    @State private var allBreeds: [BreedInfo] = []

    @State private var showBreedSheet = false
    @State private var showSaveSheet = false
    @State private var catName: String = ""

    // MARK: - Classifier
    let classifier = CatBreedClassifierHelper()!

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        headerView
                        Text("CATscan")
                            .font(.custom("MilkywayDEMO", size: 80))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        imageDisplay
                        photoButtons

                        if selectedImage != nil {
                            detectClearButtons
                        }

                        if isLoading {
                            scanningView
                        }

                        predictionResultsView

                        Spacer()
                    }
                    .padding()
                    .refreshable {
                        resetScan()
                    }
                }
                .blur(radius: isMenuOpen ? 5 : 0)

                if isMenuOpen {
                    SidebarMenu(isMenuOpen: $isMenuOpen)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                }
            }
            .background(Color.theme.background)
            .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                if selectedImage == nil {
                    resetScan()
                }
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

    // MARK: - Subviews

    private var headerView: some View {
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
    }

    private var imageDisplay: some View {
        Group {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(10)
                    .shadow(color: isLoading ? .green.opacity(0.8) : .clear, radius: isLoading ? 20 : 0)
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
        }
    }

    private var photoButtons: some View {
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
    }

    private var detectClearButtons: some View {
        HStack {
            Button(action: detectBreed) {
                Label("Detect Breed", systemImage: "pawprint")
                    .font(.custom("MilkywayDEMO", size: 20))
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.theme.accent)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }

            Button(action: resetScan) {
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

    private var scanningView: some View {
        ScrollView {
            
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
    }

        private var predictionResultsView: some View {
            Group {
                if !topPredictions.isEmpty && !isLoading {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top Predictions:")
                            .font(.custom("MilkywayDEMO", size: 24))
                            .foregroundColor(.white)
                        
                        ForEach(topPredictions) { prediction in
                            HStack {
                                Text(prediction.label)
                                    .font(.custom("MilkywayDEMO", size: 18))
                                    .foregroundColor(.white)
                                Spacer()
                                Text(String(format: "%.1f%%", prediction.confidence * 100))
                                    .font(.custom("MilkywayDEMO", size: 18))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        if let _ = selectedBreedInfo {
                            VStack(spacing: 12) {
                                Button("📖 See Details") {
                                    showBreedSheet = true
                                }
                                .font(.custom("MilkywayDEMO", size: 18))
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                
                                Button("💾 Save This Cat") {
                                    showSaveSheet = true
                                }
                                .font(.custom("MilkywayDEMO", size: 18))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                            }
                            .padding(.top, 12)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding(.top)
                } else if prediction == "❌ No cat breed could be detected." && scanAttempted && !isLoading {
                    Text("❌ No cat breed could be detected.")
                        .foregroundColor(.red)
                        .font(.custom("MilkywayDEMO", size: 16))
                        .padding(.top)
                }
            }
        
    }

    // MARK: - Functions

    private func detectBreed() {
        guard let image = selectedImage else { return }
        isLoading = true
        scanAttempted = true

        classifier.predictTopK(from: image, topK: 3) { results in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                let confidenceThreshold: Double = 0.20
                let sortedPredictions = results.sorted { $0.confidence > $1.confidence }.prefix(3)
                topPredictions = sortedPredictions.map { TopPrediction(label: $0.label, confidence: $0.confidence) }

                if let topResult = sortedPredictions.first(where: { result in
                    let resultID = result.label.components(separatedBy: " ").first ?? ""
                    return result.confidence >= confidenceThreshold && allBreeds.contains(where: { $0.id == resultID })
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

    private func resetScan() {
        selectedImage = nil
        prediction = nil
        confidence = nil
        selectedBreedInfo = nil
        topPredictions = []
        isLoading = false
        scanAttempted = false
    }

    private func loadBreeds() {
        if let url = Bundle.main.url(forResource: "breeds", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([BreedInfo].self, from: data) {
            self.allBreeds = decoded
        }
    }
}


