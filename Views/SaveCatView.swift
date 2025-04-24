import SwiftUI

struct SaveCatView: View {
    let image: UIImage
    let breed: BreedInfo
    @Binding var catName: String
    let onSave: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // ✅ Dark background

            VStack(spacing: 20) {
                Text("Name Your Cat")
                    .font(.custom("MilkywayDEMO", size: 40))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)

                Text("Breed: \(breed.name)")
                    .font(.custom("MilkywayDEMO", size: 22))
                    .foregroundColor(.green)

                TextField("Enter cat's name", text: $catName)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                HStack(spacing: 20) {
                    Button(action: {
                        onSave(catName)
                    }) {
                        Text("Save")
                            .font(.custom("MilkywayDEMO", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        onCancel()
                    }) {
                        Text("Cancel")
                            .font(.custom("MilkywayDEMO", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}
