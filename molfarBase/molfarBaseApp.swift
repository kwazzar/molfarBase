//
//  molfarBaseApp.swift
//  molfarBase
//
//  Created by kwazzar on 16.11.2026.
//

import SwiftUI
import CoreData

@main
struct molfarBaseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
