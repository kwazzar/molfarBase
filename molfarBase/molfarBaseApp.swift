//
//  molfarBaseApp.swift
//  molfarBase
//
//  Created by kwazzar on 16.11.2026.
//

import SwiftUI

@main
struct molfarBaseApp: App {
    
    @State private var vm = ListViewModel(store: PersistenceController.shared)
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
        }
    }
}
