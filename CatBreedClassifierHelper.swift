import Foundation
import CoreML
import Vision
import UIKit

class CatBreedClassifierHelper {
    private let model: VNCoreMLModel
    private let catLabels: [String]

    init?() {
        // Load MobileNet model
        guard let coreMLModel = try? MobileNet(configuration: MLModelConfiguration()).model,
              let visionModel = try? VNCoreMLModel(for: coreMLModel) else {
            return nil
        }

        self.model = visionModel

        // All supported domestic and big cats
        self.catLabels = [
            "tiger cat", "tabby", "Egyptian cat", "Persian cat", "Siamese cat",
            "cougar", "lynx", "leopard", "snow leopard", "jaguar", "lion", "cheetah", "tiger"
        ]
    }

    func predictTopK(from image: UIImage, topK: Int = 3, completion: @escaping ([PredictionResult]) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion([])
            return
        }

        let request = VNCoreMLRequest(model: model) { request, _ in
            guard let results = request.results as? [VNClassificationObservation] else {
                completion([])
                return
            }

            let filtered = results
                .filter { result in
                    self.catLabels.contains { result.identifier.lowercased().contains($0.lowercased()) }
                }
                .prefix(topK)
                .map { PredictionResult(label: $0.identifier, confidence: Double($0.confidence)) }

            completion(Array(filtered))
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }
}

struct PredictionResult {
    let label: String
    let confidence: Double
}
