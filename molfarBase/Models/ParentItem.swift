//
//  ParentItem.swift
//  molfarBase
//
//  Created by kwazzar on 19.11.2026.
//

import Foundation

struct ParentItem: Sendable {
    let id: UUID
    let title: String
    let childrenCount: Int
}
