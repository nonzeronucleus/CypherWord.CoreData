import SwiftUI
import Dependencies

struct LabelButton: View {
    var level: LevelDefinition
    var viewModel: LevelListViewModel
    
    var body: some View {
        if let number = level.number {
            let gradient = Gradient(colors: [viewModel.primaryColor(level: level), viewModel.secondaryColor(level: level)])
            ZStack {
                LevelButtonView(number: number,gradient: gradient) {
                    viewModel.onSelectLevel(level: level)
                }
                if level.levelType == .playable && level.percentComplete < 1.0 {
                    PercentageCircleView(percentage: level.percentComplete)
                }
            }
            .accessibilityIdentifier("LevelButton_\(number)")
        }
        else {
            fatalError("No Number for Level \(level.id)")
        }
    }
}


struct LevelListView : View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @ObservedObject var viewModel: LevelListViewModel

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    init(_ viewModel: LevelListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            TitleBarView(title: viewModel.title(), color: viewModel.primaryColor()) {
                viewModel.navigateToSettings()
            }
            .padding(0)

            ZStack {
                        
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        let levels = viewModel.displayableLevels
                        ForEach(levels) { level in
                            LabelButton(level: level, viewModel: viewModel)
                        }
                    }
                    .padding(20)
                }
//                    }
//                }
            }
            .padding(0)
            
            Spacer()
            
            if settingsViewModel.settings.editMode {
                if let viewModel = viewModel as? LayoutListViewModel {
                    Button("Add") {
                        viewModel.addLayout()
                    }
                }
                Button("Delete all") {
                    viewModel.deleteAll()
                }
                Button("Export") {
                    viewModel.exportAll()
                }
                Spacer()
            }
        }
        .tabItem {
            Image(systemName: viewModel.isLayout ? "books.vertical" : "square.grid.3x3")
            Text(viewModel.title())
        }
        .tag(viewModel.tag)
    }
}

#Preview("Layout") {
    let testLayouts = [
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil)
    ]
    
    let testPlayableLevels = [
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 3, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 5, attemptedLetters: nil)
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
        let settingsViewModel = SettingsViewModel(parentId: nil)
        let viewModel = LayoutListViewModel(
            navigationViewModel: NavigationViewModel(settingsViewModel: SettingsViewModel(parentId: nil)),
            settingsViewModel:SettingsViewModel(parentId: nil))
        
        return LevelListView(viewModel)
            .environmentObject(settingsViewModel)
    }
}

#Preview("Playable - show completed") {
    let testLayouts = [
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil)
    ]
    
    let testPlayableLevels = [
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil, numCorrectLetters: 20),
        LevelDefinition(id: UUID(), number: 3, attemptedLetters: nil, numCorrectLetters: 26),
        LevelDefinition(id: UUID(), number: 4, attemptedLetters: nil)
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
        let settingsViewModel = SettingsViewModel(parentId: nil)
        settingsViewModel.settings.showCompletedLevels = true

        let viewModel = PlayableLevelListViewModel(
            navigationViewModel: NavigationViewModel(settingsViewModel: SettingsViewModel(parentId: nil)),
            settingsViewModel:SettingsViewModel(parentId: nil))

        return LevelListView(viewModel)
            .environmentObject(settingsViewModel)
    }
}


#Preview("Playable - hide completed") {
    let testLayouts = [
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil)
    ]
    
    let testPlayableLevels = [
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil, numCorrectLetters: 20),
        LevelDefinition(id: UUID(), number: 3, attemptedLetters: nil, numCorrectLetters: 26),
        LevelDefinition(id: UUID(), number: 4, attemptedLetters: nil)
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
        let settingsViewModel = SettingsViewModel(parentId: nil)
        settingsViewModel.settings.showCompletedLevels = false

        let viewModel = PlayableLevelListViewModel(
            navigationViewModel: NavigationViewModel(settingsViewModel: SettingsViewModel(parentId: nil)),
            settingsViewModel:SettingsViewModel(parentId: nil))

        return LevelListView(viewModel)
            .environmentObject(settingsViewModel)
    }
}
