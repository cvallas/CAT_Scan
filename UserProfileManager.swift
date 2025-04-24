import Foundation
import UIKit

class UserProfileManager: ObservableObject {
    static let shared = UserProfileManager()

    @Published var savedCats: [SavedCat] = []

    private let key = "savedCats"

    private init() {
        load()
    }

    func addCat(breed: BreedInfo, name: String, image: UIImage) {
        let newCat = SavedCat(breed: breed, name: name, image: image)
        savedCats.append(newCat)
        save()
    }

    func deleteCat(_ cat: SavedCat) {
        savedCats.removeAll { $0.id == cat.id }
        save() // ✅ Correct method
    }

    func renameCat(_ cat: SavedCat, to newName: String) {
        if let index = savedCats.firstIndex(where: { $0.id == cat.id }) {
            savedCats[index].name = newName // ✅ Works if `name` is a `var`
            save()
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(savedCats) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([SavedCat].self, from: data) {
            self.savedCats = decoded
        }
    }
}
