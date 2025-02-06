//
//  ContentView.swift
//  CypherWord.CoreData
//
//  Created by Ian Plumb on 01/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State var selection:Tab = .level
    let viewModel:LevelListViewModelProtocol

    init () {
        let layoutRepository = LevelStorageCoreData()
        let fetchLayoutsUseCase = FetchLayoutssUseCase(repository: layoutRepository)
        let fetchPlayableLevelsUseCase = FetchPlayableLevelsUseCase(repository: layoutRepository)
        let addLayoutUseCase = AddLayoutUseCase(repository: layoutRepository)
        viewModel = LevelListViewModel(
            fetchLayoutsUseCase: fetchLayoutsUseCase,
            fetchPlayableLevelsUseCase:fetchPlayableLevelsUseCase,
            addLayoutUseCase: addLayoutUseCase
        )
        
//        viewModel = OldLevelListViewModel()
    }

    var body: some View {
        LevelListRootView(viewModel)
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
