import SwiftUI
import Foundation

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var store: Store
    @StateObject var viewModel = TaskViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                if !todayTasks.isEmpty {
                    Section(header: Text("Today")) {
                        ForEach(todayTasks) { task in
                            TaskRow(task: task, onToggle: toggleComplete, onDelete: deleteTask) {
                                path.append(task) // 👈 push to TaskDetailView
                            }
                        }
                    }
                }

                if !upcomingTasks.isEmpty {
                    Section(header: Text("Upcoming")) {
                        ForEach(upcomingTasks) { task in
                            TaskRow(task: task, onToggle: toggleComplete, onDelete: deleteTask) {
                                path.append(task)
                            }
                        }
                    }
                }

                if !completedTasks.isEmpty {
                    Section(header: Text("Completed")) {
                        ForEach(completedTasks) { task in
                            TaskRow(task: task, onToggle: toggleComplete, onDelete: deleteTask) {
                                path.append(task)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("SwiftToDo+")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        path.append("add") // 👈 we’ll handle this in destination
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                loadTasksFromDB()
            }
            .navigationDestination(for: Task.self) { task in
                TaskDetailView(task: task)
            }
            .navigationDestination(for: String.self) { value in
                if value == "add" {
                    TaskFormView()
                }
            }
        }
    }

    // MARK: - Computed Sections

    var todayTasks: [Task] {
        store.state.tasks.filter {
            Calendar.current.isDateInToday($0.dueDate) && !$0.isCompleted
        }
    }

    var upcomingTasks: [Task] {
        store.state.tasks.filter {
            $0.dueDate > Date() &&
            !$0.isCompleted &&
            !Calendar.current.isDateInToday($0.dueDate)
        }
    }

    var completedTasks: [Task] {
        store.state.tasks.filter { $0.isCompleted }
    }

    // MARK: - Actions

    func toggleComplete(_ task: Task) {
        var updated = task
        updated.isCompleted.toggle()
        store.dispatch(.update(updated))
        viewModel.save(task: updated)
    }

    func deleteTask(_ task: Task) {
        store.dispatch(.delete(task.id))
        viewModel.deleteTask(task.id)
    }

    func loadTasksFromDB() {
        let tasks = viewModel.loadTasks()
        store.dispatch(.loadTasks(tasks))
    }
}
