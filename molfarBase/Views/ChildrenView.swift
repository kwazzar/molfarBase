//
//  ChildrenView.swift
//  molfarBase
//
//  Created by kwazzar on 19.11.2026.
//

import SwiftUI

struct ChildrenView: View {
    let title: String
    let load: () async throws -> [RowItem]
    let goHome: () -> Void
    @State private var rows: [RowItem]?
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if let rows {
                List(rows) { row in
                    NavigationLink(value: Route.parent(ofChild: row.id)) {
                        RowView(row: row)
                    }
                }
            } else if let errorMessage {
                Text(errorMessage).foregroundStyle(.secondary)
            } else {
                ProgressView()
            }
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { goHome() } label: {
                    Image(systemName: "house")
                }
            }
        }
        .task {
            do {
                rows = try await load()
            } catch { errorMessage = error.localizedDescription }
        }
    }
}
