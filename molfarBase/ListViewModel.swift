//
//  ListViewModel.swift
//  molfarBase
//
//  Created by kwazzar on 16.11.2026.
//

import Combine
import OSLog

@MainActor
@Observable
final class ListViewModel {
    var rows: [RowItem] = []
    var isLoading = false
    var status = ""
    
    private let store: PersistenceStore
    
    init(store: PersistenceStore) {
        self.store = store
    }
    
    private let logger = Logger(subsystem: "com.nazar.molfarBase", category: "ViewModel")
    
    func load() async {
        guard rows.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            if try await store.isEmpty() {
                status = "Generating 100 000 objects…"
                try await store.generateObjects()
            }
            status = "Fetching…"
            rows = try await store.fetchRows()
        } catch {
            logger.error("Load failed: \(error)")
            status = "Error: \(error.localizedDescription)"
        }
    }
    
    func regenerateData() async {
        do {
            try await store.clearDatabase()
            rows = []
        } catch {
            logger.error("Clear failed: \(error)")
            status = "Error: \(error.localizedDescription)"
            return
        }
        await load()
    }
}
