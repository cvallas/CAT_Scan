//
//  ContentView.swift
//  CATScan
//
//  Created by Sherikins on 4/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showBreedInfo = false
    @State private var selectedBreed: BreedInfo? = nil

    let breedInfoList = BreedInfoLoader.loadBreedInfo()

    func formatBreedName(_ modelLabel: String) -> String {
        switch modelLabel {
        case "tabby, tabby cat": return "Tabby Cat"
        case "tiger cat": return "Tiger Cat"
        case "Persian cat": return "Persian Cat"
        case "Siamese cat, Siamese": return "Siamese Cat"
        case "Egyptian cat": return "Egyptian Cat"
        default: return modelLabel
        }
    }

    func simulatePrediction(breedLabel: String) {
        let formatted = formatBreedName(breedLabel)
        if let match = breedInfoList.first(where: { $0.name == formatted }) {
            selectedBreed = match
            showBreedInfo = true
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Simulate Classifier").font(.title)

            Button("Simulate Siamese") {
                simulatePrediction(breedLabel: "Siamese cat, Siamese")
            }

            Button("Simulate Tabby") {
                simulatePrediction(breedLabel: "tabby, tabby cat")
            }
        }
        .sheet(isPresented: $showBreedInfo) {
            if let breed = selectedBreed {
                BreedInfoView(breed: breed)
            }
        }
    }
}
