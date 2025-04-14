import CoreML
import Vision
import UIKit

class CatBreedClassifierHelper {
    private var model: VNCoreMLModel?

    init?() {
        do {
            let config = MLModelConfiguration()
            let coreMLModel = try MobileNet(configuration: config).model // ✅ Updated model name
            model = try VNCoreMLModel(for: coreMLModel)
        } catch {
            print("❌ Failed to load model: \(error)")
            return nil
        }
    }

    func predict(image: UIImage, completion: @escaping (String?, Double?) -> Void) {
        guard let model = model else {
            completion(nil, nil)
            return
        }

        guard let ciImage = CIImage(image: image) else {
            completion(nil, nil)
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNClassificationObservation],
               let topResult = results.first {
                print("✅ Prediction: \(topResult.identifier), Confidence: \(topResult.confidence)")
                completion(topResult.identifier, Double(topResult.confidence))
            } else {
                print("❌ No results found.")
                completion(nil, nil)
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("❌ Prediction error: \(error)")
                completion(nil, nil)
            }
        }
    }
}
