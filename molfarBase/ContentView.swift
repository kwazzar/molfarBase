//
//  ContentView.swift
//  molfarBase
//
//  Created by kwazzar on 16.11.2026.
//

import SwiftUI

struct ContentView: View {
    let vm: ListViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                        Text(vm.status)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    List(vm.rows) { row in
                        HStack {
                            Text(row.title)
                            Spacer()
                            Text("\(row.value)")
                                .foregroundStyle(.secondary)
                            Text(row.id.uuidString.prefix(8))
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("ModelB (\(vm.rows.count))")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button("Regenerate") {
                        Task {
                            await vm.regenerateData()
                        }
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
    let mockVM = ListViewModel(store: MockStore())
    ContentView(vm: mockVM)
}
