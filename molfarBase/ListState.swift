//
//  ListState.swift
//  molfarBase
//
//  Created by kwazzar on 18.11.2026.
//

enum ListState {
    case idle
    case loading(String)
    case loaded([RowItem])
    case failed(String)
}
