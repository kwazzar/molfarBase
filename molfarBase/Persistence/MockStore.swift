//
//  MockStore.swift
//  molfarBase
//
//  Created by kwazzar on 19.11.2026.
//

import Foundation

final class MockStore: PersistenceStore {
    func isEmpty() async throws -> Bool { false }
    func generateObjects() async throws { }
    func clearDatabase() async throws { }
    func fetchRows(offset: Int, limit: Int) async throws -> [RowItem] {
        (0..<10).map { RowItem(id: UUID(), title: "Mock \($0)", value: Int32($0)) }
    }
    
    func fetchParent(ofChild id: UUID) async throws -> ParentItem? {
        ParentItem(id: UUID(), title: "Mock parent", childrenCount: 5)
    }
    func fetchChildren(ofParent id: UUID) async throws -> [RowItem] {
        try await fetchRows(offset: 1, limit: 1)
    }
    
    func countRows() async throws -> Int {
        1000
    }
}
