//
//  Persistence.swift
//  molfarBase
//
//  Created by kwazzar on 16.11.2026.
//

import CoreData
import OSLog

final class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    static let logger = Logger(subsystem: "com.nazar.molfarBase", category: "CoreData")
    
    init() {
        container = NSPersistentContainer(name: "molfarBase")
        container.loadPersistentStores { _, error in
            if let error {
                Self.logger.fault("Помилка завантаження сховища: \(error.localizedDescription)")
                fatalError("Store error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        Self.logger.info("PersistentContainer успішно ініціалізовано")
    }
}

// MARK: - Fetch for UI
extension PersistenceController {
    func fetchRows() async throws -> [RowItem] {
        let ctx = container.newBackgroundContext()
        return try await ctx.perform {
            let req = ModelB.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            return try ctx.fetch(req).map {
                RowItem(id: $0.id ?? UUID(), title: $0.title ?? "", value: $0.value)
            }
        }
    }
}
