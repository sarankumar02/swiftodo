//
//  TaskRow.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//


import SwiftUI
import Foundation

struct TaskRow: View {
    var task: Task
    var onToggle: (Task) -> Void
    var onDelete: (Task) -> Void
    var onShowDetail: () -> Void
    @EnvironmentObject var store: Store

    var body: some View {
        HStack {
//            Button(action: {
//                onToggle(task)
//            }) {
//                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
//                    .foregroundColor(task.isCompleted ? .green : .gray)
//            }

            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted, color: .gray)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                    .font(.body)
                Text(task.dueDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(task.priority.rawValue.capitalized)
                .font(.caption2)
                .padding(5)
                .background(priorityColor())
                .foregroundColor(.white)
                .cornerRadius(5)
            
            // 👉 Tap here to navigate
            Button(action: {
                           onShowDetail()
                       }) {
                           Image(systemName: "chevron.right")
                               .foregroundColor(.gray)
            }

        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete(task)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func priorityColor() -> Color {
        switch task.priority {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
}
