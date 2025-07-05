//
//  TaskFormView.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//


import SwiftUI
import Foundation

struct TaskFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context

    @EnvironmentObject var store: Store
    @StateObject private var viewModel = TaskViewModel()

    var taskToEdit: Task?

    // MARK: - Form Fields
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var dueDate: Date = Date()
    @State private var priority: Priority = .medium

    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                TextField("Title", text: $title)
                TextEditor(text: $notes)
                    .frame(height: 100)
            }

            Section(header: Text("Due Date")) {
                DatePicker("Due", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
            }

            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { level in
                        Text(level.rawValue.capitalized).tag(level)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Button(action: saveTask) {
                    Text(taskToEdit == nil ? "Add Task" : "Update Task")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle(taskToEdit == nil ? "New Task" : "Edit Task")
        .onAppear {
            if let task = taskToEdit {
                title = task.title
                notes = task.notes ?? ""
                dueDate = task.dueDate
                priority = task.priority
            }
        }
    }

    // MARK: - Save Logic

    func saveTask() {
        let newTask = Task(
            id: taskToEdit?.id ?? UUID(),
            title: title,
            notes: notes,
            dueDate: dueDate,
            priority: priority,
            isCompleted: taskToEdit?.isCompleted ?? false,
            createdAt: taskToEdit?.createdAt ?? Date()
        )

        if taskToEdit == nil {
            store.dispatch(.add(newTask))
        } else {
            store.dispatch(.update(newTask))
        }

        viewModel.save(task: newTask)
        presentationMode.wrappedValue.dismiss()
    }
}
