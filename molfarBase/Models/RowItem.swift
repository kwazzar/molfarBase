//
//  RowItem.swift
//  molfarBase
//
//  Created by kwazzar on 16.11.2026.
//

import Foundation

struct RowItem: Identifiable, Sendable {
    let id: UUID
    let title: String
    let value: Int32
}
