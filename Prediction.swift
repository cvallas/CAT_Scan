//
//  Prediction.swift
//  CATScan
//
//  Created by Olivia Tirso on 4/7/25.
//

import Foundation

struct Prediction: Identifiable, Decodable {
    let id = UUID()  // Unique ID for SwiftUI List
    let image_path: String
    let predicted_label: Int
    let predicted_breed: String
    let confidence_score: Double

    // Tell the decoder to ignore `id` because it’s generated
    private enum CodingKeys: String, CodingKey {
        case image_path, predicted_label, predicted_breed, confidence_score
    }
}
