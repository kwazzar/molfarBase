//
//  Route.swift
//  molfarBase
//
//  Created by kwazzar on 19.11.2026.
//

import Foundation

enum Route: Hashable {
    case parent(ofChild: UUID)
    case children(ofParent: UUID, title: String)
}
