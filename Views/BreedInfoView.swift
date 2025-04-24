import SwiftUI

struct BreedInfoView: View {
    let breed: BreedInfo
    var image: UIImage? = nil
    var name: String? = nil // ✅ Add name
    var onSave: (() -> Void)? = nil


    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let catImage = image {
                    Image(uiImage: catImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 10)
                        .padding(.top)
                }
                
                if let name = name {
                    Text("\(name)")
                        .font(.custom("MilkywayDEMO", size: 28))
                        .foregroundColor(.white)
                }


                Text(breed.name)
                    .font(.custom("MilkywayDEMO", size: 36))
                    .foregroundColor(.white)
                    .padding(.top, image == nil ? 40 : 10)

                Group {
                    infoRow(title: "Origin", text: breed.origin)
                    infoRow(title: "Temperament", text: breed.temperament)
                    infoRow(title: "Description", text: breed.description)
                    funFactsSection
                }

                if let onSave = onSave {
                    Button(action: onSave) {
                        HStack {
                            Image(systemName: "tray.and.arrow.down.fill")
                            Text("Save This Cat")
                        }
                        .font(.custom("MilkywayDEMO", size: 20))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    .padding(.top, 10)
                }

                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .font(.custom("MilkywayDEMO", size: 20))
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.theme.accent)
                    .cornerRadius(12)
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    private func infoRow(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(title):")
                .font(.custom("MilkywayDEMO", size: 24))
                .foregroundColor(.green)
            Text(text)
                .font(.body)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var funFactsSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Fun Facts:")
                .font(.custom("MilkywayDEMO", size: 24))
                .foregroundColor(.green)
            ForEach(breed.fun_facts, id: \.self) { fact in
                Text("• \(fact)")
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
