import Foundation

struct BreedInfo: Identifiable, Codable {
    var id: String // This should now match the ImageNet-style ID (e.g., "n02123159")
    let name: String
    let origin: String
    let description: String
    let temperament: String
    let fun_facts: [String]
}
