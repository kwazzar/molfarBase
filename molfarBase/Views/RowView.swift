//
//  RowView.swift
//  molfarBase
//
//  Created by kwazzar on 19.11.2026.
//

import SwiftUI

struct RowView: View {
    let row: RowItem

    var body: some View {
        HStack {
            Text(row.title)
            Spacer()
            Text("\(row.value)").foregroundStyle(.secondary)
            Text(row.id.uuidString.prefix(8))
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
        }
    }
}
