//
//  Untitled.swift
//  CATScan
//
//  Created by Sherikins on 4/23/25.
//

import Foundation

class ScanHistoryManager {
    static let shared = ScanHistoryManager()

    private let key = "cat_scan_history"

    func saveScan(_ breed: BreedInfo) {
        var current = loadHistory()
        current.append(breed)
        if let data = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func loadHistory() -> [BreedInfo] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([BreedInfo].self, from: data) else {
            return []
        }
        return decoded
    }
}
