//
//  ContentView.swift
//  molfarBase
//
//  Created by kwazzar on 16.11.2026.
//

import SwiftUI

struct ContentView: View {
    let vm: ListViewModel
    @State private var path: [Route] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch vm.state {
                case .idle, .loading:
                    VStack(spacing: 16) {
                        ProgressView()
                        Text(vm.status).foregroundStyle(.secondary)
                    }
                case .loaded:
                    List(vm.rows) { row in
                        NavigationLink(value: Route.parent(ofChild: row.id)) {
                            RowView(row: row)
                        }
                    }
                case .failed:
                    Text(vm.status)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding()
                }
            }
            .navigationTitle("ModelB (\(vm.rows.count))")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .parent(let childID):
                    ParentView(load: { try await vm.fetchParent(ofChild: childID) },
                               goHome: { path.removeAll() }
                    )
                case .children(let parentID, let title):
                    ChildrenView(title: title,
                                 load: { try await vm.fetchChildren(ofParent: parentID) },
                                 goHome: { path.removeAll() }
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button("Regenerate") {
                        Task { await vm.regenerateData() }
                    }
                    .buttonStyle(.glass)
                    .disabled(vm.isLoading)
                }
            }
        }
        .task {
            await vm.load()
        }
    }
}

#Preview {
    ContentView(vm: ListViewModel(store: MockStore()))
}
