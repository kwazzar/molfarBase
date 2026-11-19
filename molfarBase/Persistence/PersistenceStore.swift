//
//  PersistenceStore.swift
//  molfarBase
//
//  Created by kwazzar on 19.11.2026.
//

import Foundation

protocol PersistenceStore {
    func isEmpty() async throws -> Bool
    func generateObjects() async throws
    func fetchRows() async throws -> [RowItem]
    func clearDatabase() async throws
    
    func fetchParent(ofChild id: UUID) async throws -> ParentItem?
    func fetchChildren(ofParent id: UUID) async throws -> [RowItem]
}
