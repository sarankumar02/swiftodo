//
//  Reducers.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//

import Foundation

func taskReducer(state: inout AppState, action: TaskAction) {
    switch action {
    case .add(let task):
        print("adding task --\(task)")
        state.tasks.append(task)
    case .delete(let id):
        state.tasks.removeAll { $0.id == id }
    case .toggleComplete(let id):
        print("toggled id---\(id)")
        if let index = state.tasks.firstIndex(where: { $0.id.uuidString == id.uuidString }) {
                var task = state.tasks[index]
                let oldStatus = task.isCompleted
                task.isCompleted.toggle()
                state.tasks[index] = task

                print("🟢 Task toggled: \(task.title)")
                print("🔄 Status: \(oldStatus) → \(task.isCompleted)")
                print("🧠 Updated in reducer at index \(index)")
            } else {
                print("❌ Task with id \(id) not found in reducer")
            }
    case .update(let task):
        if let index = state.tasks.firstIndex(where: { $0.id == task.id }) {
            state.tasks[index] = task
        }
    case .loadTasks(let tasks):
        state.tasks = tasks
    case .setFilter(let filter):
        state.filter = filter
    }
}
