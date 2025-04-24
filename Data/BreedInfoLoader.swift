//
//  BreedInfoLoader.swift
//  CATScan
//
//  Created by Chris on 4/23/25.
//

import Foundation

class BreedInfoLoader {
    static func loadBreedInfo() -> [BreedInfo] {
        guard let url = Bundle.main.url(forResource: "breeds", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let breeds = try? JSONDecoder().decode([BreedInfo].self, from: data) else {
            return []
        }
        return breeds
    }
}
