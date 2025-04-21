//
//  FontStyle.swift
//  CATScan
//
//  Created by Olivia Tirso on 4/19/25.
//

import SwiftUI

struct MilkywayFont: ViewModifier {
    var size: CGFloat

    func body(content: Content) -> some View {
        content.font(.custom("MilkywayDEMO", size: size))
    }
}

extension View {
    func milkywayFont(size: CGFloat) -> some View {
        self.modifier(MilkywayFont(size: size))
    }
}
