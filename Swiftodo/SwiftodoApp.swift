//
//  SwiftodoApp.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//

import SwiftUI

@main
struct SwiftodoApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var store = Store(
           initialState: AppState(),
           reducer: taskReducer
       )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(store) // 👈 Store injected once
        }
    }
}
