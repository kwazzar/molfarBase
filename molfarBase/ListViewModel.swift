//
//  ListViewModel.swift
//  molfarBase
//
//  Created by kwazzar on 16.11.2026.
//

import Combine
import OSLog

@MainActor
@Observable
final class ListViewModel {
    private(set) var state: ListState = .idle
    private let store: PersistenceStore
    
    private(set) var total = 0
    private let pageSize = 200
    private var isLoadingMore = false
    
    static let logger = Logger(subsystem: "com.nazar.molfarBase", category: "ViewModel")
    
    init(store: PersistenceStore) {
        self.store = store
    }
    
    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }
    
    var rows: [RowItem] {
        if case .loaded(let items) = state { return items }
        return []
    }
    
    var status: String {
        switch state {
        case .loading(let message), .failed(let message): return message
        case .idle, .loaded: return ""
        }
    }
    
    func load() async {
        switch state {
        case .idle, .failed:
            await run(clear: false)
        case .loading, .loaded:
            return
        }
    }
    
    func regenerateData() async {
        guard !isLoading else {
            Self.logger.notice("Регенерацію пропущено — вже виконується завантаження")
            return
        }
        await run(clear: true)
    }
    
    private func run(clear: Bool) async {
        do {
            if clear {
                state = .loading("Clearing...")
                try await store.clearDatabase()
            }
            if try await store.isEmpty() {
                state = .loading("Generating 100 000 objects…")
                try await store.generateObjects()
            }
            state = .loading("Fetching…")
            total = try await store.countRows()
            let items = try await store.fetchRows(offset: 0, limit: pageSize)
            state = .loaded(items)
            Self.logger.notice("Завантажено \(items.count) об'єктів (clear: \(clear))")
        } catch {
            Self.logger.error("Помилка завантаження: \(error.localizedDescription)")
            state = .failed("Error: \(error.localizedDescription)")
        }
    }
    
    func loadMoreIfNeeded(current row: RowItem) async {
        guard !isLoadingMore,
              case .loaded(let current) = state,
              current.count < total,
              current.suffix(60).contains(where: { $0.id == row.id }) else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        let offset = current.count
        do {
            let next = try await store.fetchRows(offset: offset, limit: pageSize)
            guard case .loaded(let latest) = state, latest.count == offset else { return }
            state = .loaded(latest + next)
        } catch {
            Self.logger.error("Load more failed: \(error)")
        }
    }
}

//MARK: - fetch to view
extension ListViewModel {
    func fetchParent(ofChild id: UUID) async throws -> ParentItem? {
        try await store.fetchParent(ofChild: id)
    }
    
    func fetchChildren(ofParent id: UUID) async throws -> [RowItem] {
        try await store.fetchChildren(ofParent: id)
    }
}
