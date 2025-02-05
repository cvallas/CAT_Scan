//
//  CATScanApp.swift
//  CATScan
//
//  Created by Sherikins on 2/5/25.
//

import SwiftUI

@main
struct CATScanApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
