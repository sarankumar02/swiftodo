//
//  TaskModel.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//

import Foundation

struct Task: Identifiable, Equatable, Hashable, Codable{
    let id: UUID
    var title: String
    var notes: String?
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    var createdAt: Date
}

enum Priority: String, CaseIterable, Codable {
    case low, medium, high
}
