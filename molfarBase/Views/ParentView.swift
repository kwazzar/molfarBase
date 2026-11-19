//
//  ParentView.swift
//  molfarBase
//
//  Created by kwazzar on 19.11.2026.
//

import SwiftUI

struct ParentView: View {
    let load: () async throws -> ParentItem?
    let goHome: () -> Void
    @State private var parent: ParentItem?
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if let parent {
                List {
                    NavigationLink(value: Route.children(ofParent: parent.id, title: parent.title)) {
                        HStack {
                            Text(parent.title)
                            Spacer()
                            Text("\(parent.childrenCount) items").foregroundStyle(.secondary)
                        }
                    }
                }
            } else if let errorMessage {
                Text(errorMessage).foregroundStyle(.secondary)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("ModelA")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { goHome() } label: {
                    Image(systemName: "house")
                }
            }
        }
        .task {
            do {
                parent = try await load()
                if parent == nil { errorMessage = "Parent not found" }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
