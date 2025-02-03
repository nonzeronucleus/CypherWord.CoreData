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
        LevelListRootView(.init())
    }
}

struct FirstView: View {
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ContentView()
}
