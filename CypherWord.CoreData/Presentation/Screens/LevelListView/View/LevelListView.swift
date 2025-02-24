import SwiftUI
import Dependencies


struct TitleBarView: View {
    var title: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        ZStack {
            // Background color extending to the top edge
            color
                .ignoresSafeArea(edges: .top)

            ZStack {
                HStack {
                    Spacer()
                    
                    // Centered Title
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    // Settings Button (Gear Icon)
                    Button(action: {
                        action()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 16) // Add some right padding
                }
            }
            .frame(height: 30) // Set a fixed height for the title bar
        }
        .frame(height: 60) // Total height of the title bar
        .padding(.bottom, 8)
    }
}




struct LevelListView : View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @ObservedObject var viewModel: LevelListViewModel

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    init(_ viewModel: LevelListViewModel) {
        self.viewModel = viewModel
    }
    
    func primaryColor(level:LevelDefinition? = nil) -> Color {
        if viewModel.levelType == .layout {
            return .orange
        }
        else {
            if let level = level {
                if level.numCorrectLetters == 26 {
                    return .green
                }
            }
        }
        return .blue
    }
    
    
    func secondaryColor(level:LevelDefinition? = nil) -> Color {
        if viewModel.levelType == .layout {
            return .red
        }
        else {
            if let level = level {
                if level.numCorrectLetters == 26 {
                    return .mint
                }
            }
        }
        return .cyan
    }
    
    var body: some View {
        VStack {
            TitleBarView(title: viewModel.levelType.rawValue, color: primaryColor()) {
                viewModel.navigateToSettings()
            }
            
//            if viewModel.levelType == .playable {
//                HStack {
//                    Toggle("Show Completed", isOn: $viewModel.showCompleted)
//                         .toggleStyle(SwitchToggleStyle()) // Default iOS switch style
//                         .padding()
//                         .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6))) // Light gray background
//                         .shadow(radius: 3)
//                         .padding()
//                 }
//                 .frame(maxWidth: .infinity) // Center vertically & horizontally
//                 .background(Color(.systemBackground)) // Match system theme
//            }

            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    let levels = viewModel.displayableLevels
                    ForEach(levels) { level in
                        if let number = level.number {
                            let gradient = Gradient(colors: [primaryColor(level: level), secondaryColor(level: level)])
                            ZStack {
                                LevelButtonView(number: number,gradient: gradient) {
                                    viewModel.onSelectLevel(level: level)
                                }
                                if level.levelType == .playable && level.percentComplete < 1.0 {
                                    PercentageCircleView(percentage: level.percentComplete)
                                }
                            }
                        }
                        else {
                            fatalError("No Number for Level \(level.id)")
                        }
                    }
                }
            }
            
            Spacer()
            
            if settingsViewModel.settings.editMode {
                if viewModel.levelType == .layout {
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
            Image(systemName: viewModel.levelType == .layout ? "books.vertical" : "square.grid.3x3")
            Text(viewModel.levelType.rawValue)
        }
        .tag(viewModel.levelType)
        
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
        let viewModel = LevelListViewModel(
            levelType: .layout,
            navigationViewModel: NavigationViewModel(settingsViewModel: SettingsViewModel(parentId: nil)),
            settingsViewModel:SettingsViewModel(parentId: nil))
        
        return LevelListView(viewModel)
    }
}

#Preview("Playable") {
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
        let viewModel = LevelListViewModel(
            levelType: .layout,
            navigationViewModel: NavigationViewModel(settingsViewModel: SettingsViewModel(parentId: nil)),
            settingsViewModel:SettingsViewModel(parentId: nil))

        return LevelListView(viewModel)
    }
}


