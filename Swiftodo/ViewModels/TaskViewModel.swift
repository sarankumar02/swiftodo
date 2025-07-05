//
//  TaskViewModel.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    private let context = PersistenceController.shared.container.viewContext

    func save(task: Task) {
        print("💾 Saving task: \(task.title), ID: \(task.id.uuidString)")

           let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "id == %@", task.id.uuidString)

           do {
               let results = try context.fetch(fetchRequest)
               let entity = results.first ?? TaskEntity(context: context)

               print("🔍 Matched existing? \(results.first != nil)")

               entity.id = task.id
               entity.title = task.title
               entity.notes = task.notes
               entity.dueDate = task.dueDate
               entity.priority = task.priority.rawValue
               entity.isCompleted = task.isCompleted
               entity.createdAt = task.createdAt

               try context.save()
           } catch {
               print("❌ CoreData save failed: \(error)")
           }
    }

    func loadTasks() -> [Task] {
        let request = TaskEntity.fetchRequest()
        guard let entities = try? context.fetch(request) else { return [] }
        print("Entities length --\(entities.count)")
        print("Entities --\(entities)")
        return entities.map {
            print("uid -\(($0.id)) is completed \($0.isCompleted)")

            return Task(
                id: $0.id!,
                title: $0.title!,
                notes: $0.notes,
                dueDate: $0.dueDate!,
                priority: Priority(rawValue: $0.priority ?? "medium") ?? .medium,
                isCompleted: $0.isCompleted,
                createdAt: $0.createdAt!
            )
        }
    }

    func deleteTask(_ id: UUID) {
        let request = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let result = try? context.fetch(request).first {
            context.delete(result)
            try? context.save()
        }
    }
}
