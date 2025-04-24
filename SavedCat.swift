import Foundation
import UIKit

struct SavedCat: Identifiable, Codable {
    let id: UUID
    var breed: BreedInfo
    var name: String // ✅ Changed from `let` to `var`
    var imageData: Data

    init(id: UUID = UUID(), breed: BreedInfo, name: String, image: UIImage) {
        self.id = id
        self.breed = breed
        self.name = name
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
    }

    var image: UIImage? {
        UIImage(data: imageData)
    }
}
