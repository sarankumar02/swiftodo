//
//  TaskFilter.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//


import Foundation

enum TaskFilter: Equatable {
    case all
    case completed
    case pending
    case priority(Priority)
    case dateRange(Date, Date)
    
    // Optional: Add more filters like category, overdue etc.

    func matches(_ task: Task) -> Bool {
        switch self {
        case .all:
            return true
        case .completed:
            return task.isCompleted
        case .pending:
            return !task.isCompleted
        case .priority(let level):
            return task.priority == level
        case .dateRange(let start, let end):
            return task.dueDate >= start && task.dueDate <= end
        }
    }
}
