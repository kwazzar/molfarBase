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
                switch vm.state {
                case .idle, .loading:
                    VStack(spacing: 16) {
                        ProgressView()
                        Text(vm.status).foregroundStyle(.secondary)
                    }
                case .loaded:
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
                case .failed:
                    Text(vm.status)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding()
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
