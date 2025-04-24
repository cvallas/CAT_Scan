//
//  SplashScreenView.swift
//  CATScan
//
//  Created by Sherikins on 4/24/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5

    var body: some View {
        if isActive {
            HomeView()
        } else {
            VStack(spacing: 20) {
                Text("CATscan")
                    .font(.custom("MilkywayDEMO", size: 80))
                    .foregroundColor(.green)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.scale = 1.0
                            self.opacity = 1.0
                        }
                    }

                ProgressView()
                    .scaleEffect(1.3)
                    .tint(.green)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
