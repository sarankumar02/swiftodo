//
//  TaskDetailView.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//


import SwiftUI
import Foundation

struct TaskDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store
    @StateObject private var viewModel = TaskViewModel()

    let task: Task

    @State private var showEdit = false
    @State private var showDeleteConfirm = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(task.title)
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: toggleComplete) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                        .imageScale(.large)
                }
            }

            if let notes = task.notes, !notes.isEmpty {
                Text(notes)
                    .font(.body)
            }

            VStack(alignment: .leading, spacing: 6) {
                Label("Due: \(task.dueDate.formatted(date: .abbreviated, time: .shortened))", systemImage: "calendar")
                Label("Priority: \(task.priority.rawValue.capitalized)", systemImage: "flag")
                Label("Created: \(task.createdAt.formatted(date: .abbreviated, time: .shortened))", systemImage: "clock")
                Label("Status: \(task.isCompleted ? "Completed" : "Pending")", systemImage: "checkmark.seal")
            }
            .font(.caption)
            .foregroundColor(.secondary)

            Spacer()

            HStack {
                Button(role: .destructive) {
                    showDeleteConfirm = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)

                Spacer()

                Button {
                    showEdit = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .navigationTitle("Task Detail")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Are you sure?", isPresented: $showDeleteConfirm) {
            Button("Delete Task", role: .destructive, action: deleteTask)
        }
        .sheet(isPresented: $showEdit) {
            NavigationView {
                TaskFormView(store: _store, taskToEdit: task)
            }
        }
    }

    // MARK: - Actions

    private func toggleComplete() {
        var updated = task
        updated.isCompleted.toggle()
        store.dispatch(.toggleComplete(updated.id))
        viewModel.save(task: updated)
        presentationMode.wrappedValue.dismiss()
    }

    private func deleteTask() {
        store.dispatch(.delete(task.id))
        viewModel.deleteTask(task.id)
        presentationMode.wrappedValue.dismiss()
    }
}
