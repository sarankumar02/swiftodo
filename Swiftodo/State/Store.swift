//
//  Store.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//

import Foundation

final class Store: ObservableObject {
    @Published private(set) var state: AppState
    private let reducer: (inout AppState, TaskAction) -> Void

    init(initialState: AppState, reducer: @escaping (inout AppState, TaskAction) -> Void) {
        self.state = initialState
        self.reducer = reducer
    }

    func dispatch(_ action: TaskAction) {
        reducer(&state, action)
    }
}
