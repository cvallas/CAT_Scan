import SwiftUI

struct ProfileView: View {
    @ObservedObject var userManager = UserProfileManager.shared

    @AppStorage("userName") private var userName: String = "User"
    @AppStorage("profileImageData") private var profileImageData: Data?

    @State private var profileImage: UIImage? = nil
    @State private var isShowingImagePicker = false

    @State private var showingRenameAlert = false
    @State private var catToRename: SavedCat?
    @State private var newCatName = ""

    @State private var selectedCatForDetails: SavedCat?
    @State private var showBreedInfoSheet = false

    @State private var isMenuOpen = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // === Top Bar with Sidebar Button (no side padding)
                HStack(alignment: .top) {
                    Button {
                        withAnimation { isMenuOpen.toggle() }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)

                    Spacer()
                }


                // === Scrollable Content Area
                ScrollView {
                    VStack(spacing: 20) {
                        // === Profile Image Button ===
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundColor(.gray)
                            }
                        }

                        // === Username Display + Edit ===
                        HStack(spacing: 10) {
                            Text(userName)
                                .font(.custom("MilkywayDEMO", size: 32))
                                .foregroundColor(.green)

                            Button {
                                showingRenameAlert = true
                                newCatName = userName
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 22))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                        Divider().background(Color.white)

                        Text("Saved Breeds")
                            .font(.custom("MilkywayDEMO", size: 30))
                            .foregroundColor(.white)

                        // === Saved Cats Section ===
                        ForEach(userManager.savedCats) { cat in
                            VStack(spacing: 8) {
                                Text("Name: \(cat.name)")
                                    .font(.custom("MilkywayDEMO", size: 20))
                                    .foregroundColor(.white)

                                Text("Breed: \(cat.breed.name)")
                                    .font(.custom("MilkywayDEMO", size: 18))
                                    .foregroundColor(.green)

                                if let image = cat.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 180)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }

                                HStack {
                                    Button(action: {
                                        catToRename = cat
                                        newCatName = cat.name
                                        showingRenameAlert = true
                                    }) {
                                        Text("Rename")
                                            .font(.custom("MilkywayDEMO", size: 18))
                                            .padding(8)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }

                                    Button(action: {
                                        userManager.deleteCat(cat)
                                    }) {
                                        Text("Delete")
                                            .font(.custom("MilkywayDEMO", size: 18))
                                            .padding(8)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }

                                Button(action: {
                                    selectedCatForDetails = cat
                                    showBreedInfoSheet = true
                                }) {
                                    Text("📖 See Details")
                                        .font(.custom("MilkywayDEMO", size: 18))
                                        .foregroundColor(.blue)
                                        .padding(.top, 4)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }

                        Spacer()
                    }
                    .padding()
                }
            }

            // === Sidebar Overlay ===
            if isMenuOpen {
                SidebarMenu(isMenuOpen: $isMenuOpen)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(item: $selectedCatForDetails) { cat in
            BreedInfoView(breed: cat.breed, image: cat.image, name: cat.name)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: Binding(
                get: { profileImage ?? UIImage(systemName: "person.circle") },
                set: { newImage in
                    profileImage = newImage
                    if let data = newImage?.jpegData(compressionQuality: 0.9) {
                        profileImageData = data
                    }
                }), isCamera: false)
        }
        .alert("Edit Name", isPresented: $showingRenameAlert, actions: {
            TextField("New Name", text: $newCatName)
            Button("Save") {
                if let cat = catToRename {
                    userManager.renameCat(cat, to: newCatName)
                } else {
                    userName = newCatName
                }
                newCatName = ""
                catToRename = nil
            }
            Button("Cancel", role: .cancel) {
                newCatName = ""
                catToRename = nil
            }
        })
        .onAppear {
            if let data = profileImageData, let uiImage = UIImage(data: data) {
                profileImage = uiImage
            }
        }
    }
}
