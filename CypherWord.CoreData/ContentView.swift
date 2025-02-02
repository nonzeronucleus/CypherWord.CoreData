//
//  ContentView.swift
//  CypherWord.CoreData
//
//  Created by Ian Plumb on 01/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State var selection:Tab = .level
    
    var body: some View {
        LevelListRootView()
//        TabsView(/*selectedLevel: $selectedLevel, */selection: $selection)
//             .transition(.move(edge: .leading)) // Slide in from the left
    }
}

struct FirstView: View {
    
    var body: some View {
        Text("Hello, World!")
    }
}


//struct ContentView: View {
//
//    @State private var showThoughtsView = false
//    var body: some View {
//        NavigationStack {
//
//                    Form {
//
//                        Section("Add Data") {
//                            Button("Add") {
//                                showThoughtsView = true
//                            }
//                            .buttonStyle(.borderedProminent)
//                        }
//                    }
//                    .scrollContentBackground(.hidden)
//                    .navigationDestination(isPresented: $showThoughtsView) {
//                        FirstView()
//                    }
//                }
//
//        }
//    }

#Preview {
    ContentView()
}
