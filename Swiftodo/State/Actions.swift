//
//  TaskAction.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//

import Foundation

enum TaskAction {
    case add(Task)
    case delete(UUID)
    case toggleComplete(UUID)
    case update(Task)
    case setFilter(TaskFilter)
    case loadTasks([Task])
}
