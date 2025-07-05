//
//  ContentView.swift
//  Swiftodo
//
//  Created by Sarankumar Venkatachalam on 04/07/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
            HomeView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
