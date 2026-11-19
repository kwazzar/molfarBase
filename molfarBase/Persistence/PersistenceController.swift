//
//  PersistenceController.swift
//  molfarBase
//
//  Created by kwazzar on 16.11.2026.
//

import CoreData
import OSLog

final class PersistenceController: PersistenceStore {
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
    
    func countRows() async throws -> Int {
        let ctx = container.newBackgroundContext()
        return try await ctx.perform {
            try ctx.count(for: NSFetchRequest<NSNumber>(entityName: "ModelB"))
        }
    }
}

// MARK: - Fetch for UI
extension PersistenceController {
    func fetchRows(offset: Int, limit: Int) async throws -> [RowItem] {
        let ctx = container.newBackgroundContext()
        return try await ctx.perform {
            let req = ModelB.fetchRequest()
            req.sortDescriptors = [
                NSSortDescriptor(key: "title", ascending: true),
                NSSortDescriptor(key: "id", ascending: true)
            ]
            req.fetchOffset = offset
            req.fetchLimit = limit
            return try ctx.fetch(req).map {
                RowItem(id: $0.id, title: $0.title ?? "", value: $0.value)
            }
        }
    }

    func fetchParent(ofChild id: UUID) async throws -> ParentItem? {
        let ctx = container.newBackgroundContext()
        return try await ctx.perform {
            let req = ModelB.fetchRequest()
            req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            req.fetchLimit = 1
            guard let a = try ctx.fetch(req).first?.owner else { return nil }
            return ParentItem(id: a.id, title: a.title ?? "", childrenCount: a.items?.count ?? 0)
        }
    }

    func fetchChildren(ofParent id: UUID) async throws -> [RowItem] {
        let ctx = container.newBackgroundContext()
        return try await ctx.perform {
            let req = ModelB.fetchRequest()
            req.predicate = NSPredicate(format: "owner.id == %@", id as CVarArg)
            req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            return try ctx.fetch(req).map {
                RowItem(id: $0.id, title: $0.title ?? "", value: $0.value)
            }
        }
    }
}

// MARK: - Generation
extension PersistenceController {
    func generateObjects(countA: Int = 100, countB: Int = 100_000) async throws {
        let ctx = container.newBackgroundContext()
        
        try await ctx.perform {
            let parents: [ModelA] = (0..<countA).map { i in
                let a = ModelA(context: ctx)
                a.id = UUID()
                a.title = "A-\(i)"
                return a
            }
            
            for _ in 0..<countB {
                let b = ModelB(context: ctx)
                b.id = UUID()
                b.title = "B-\(Int.random(in: 0...999_999))"
                b.value = Int32.random(in: 0...1000)
                b.owner = parents.randomElement()
            }
            
            try ctx.save()
        }
        
        Self.logger.notice("Згенеровано \(countB) об'єктів")
    }
    
    func isEmpty() async throws -> Bool {
        let ctx = container.newBackgroundContext()
        return try await ctx.perform {
            let req = NSFetchRequest<NSNumber>(entityName: "ModelB")
            req.resultType = .countResultType
            let count = try ctx.count(for: req)
            return count == 0
        }
    }
    
    func clearDatabase() async throws {
        let ctx = container.newBackgroundContext()
        try await ctx.perform {
            let fetchA = NSFetchRequest<NSFetchRequestResult>(entityName: "ModelA")
            let fetchB = NSFetchRequest<NSFetchRequestResult>(entityName: "ModelB")
            
            let deleteA = NSBatchDeleteRequest(fetchRequest: fetchA)
            let deleteB = NSBatchDeleteRequest(fetchRequest: fetchB)
            
            try ctx.execute(deleteA)
            try ctx.execute(deleteB)
            try ctx.save()
        }
    }
}

extension PersistenceController {
    func generateObjects() async throws {
        try await generateObjects(countA: 100, countB: 100_000)
    }
}
