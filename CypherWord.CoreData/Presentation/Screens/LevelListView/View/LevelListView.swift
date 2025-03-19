import SwiftUI
import Dependencies

struct LevelListView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @ObservedObject var viewModel: LevelListViewModel

//    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    init(_ viewModel: LevelListViewModel) {
        self.viewModel = viewModel
    }

//    let levels = Array(1...24) // Example levels (more than one page)
    let columns = [GridItem(.adaptive(minimum: 60, maximum: 80), spacing: 20)] // Grid layout
    @State private var currentPage = 1 // Current page number
    var totalPages = 2
    let levelsPerPage = 12 // Number of levels per page

    var body: some View {
        let visibleLevels = viewModel.displayableLevels

        VStack {
            TitleBarView(title: viewModel.title(), color: viewModel.primaryColor()) {
                viewModel.navigateToSettings()
            }
            .padding(0)

            // Level Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(visibleLevels, id: \.self) { level in
                        LevelCard(level: level, progress: level.percentComplete) // Random progress for demo
                            .onTapGesture {
                                viewModel.onSelectLevel(level: level)
                                // Navigate to the selected level here
                            }
                    }
                }
                .padding()
            }
            if let playableLevelListViewModel = viewModel as? PlayableLevelListViewModel {
                PackView(playableLevelListViewModel)
            }
            // Page Navigation
        }
//        .navigationTitle("Level Select")
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
        .tabItem {
            if settingsViewModel.settings.editMode {
                
                Image(systemName: viewModel.isLayout ? "books.vertical" : "square.grid.3x3")
                Text(viewModel.title())
            }
        }
        .tag(viewModel.tag)
    }

}


struct LevelCard: View {
    let level: LevelDefinition
    let progress: Double // Progress from 0 to 1
    let showingStars = false
    
    init(level: LevelDefinition, progress: Double = 1.0) {
        self.level = level
        self.progress = max(progress,0.0)
    }

    var body: some View {
        VStack(spacing: 8) {
//            Text("Level \(level)")
            if let number = level.number {
                Text("\(number)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            // Progress indicator (stars or bar)
            ProgressBar(value: progress)
                .frame(height: 8)

            //// Star rating (optional)
            if showingStars {
                HStack(spacing: 4) {
                    ForEach(0..<3) { star in
                        Image(systemName: progress >= Double(star + 1) / 3 ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                    }
                }
            }

            // Star rating (optional)
        }
        .padding()
        .frame(width: 80, height: 80) // Fixed size for the card
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        
    }
}

struct ProgressBar: View {
    let value: Double // Progress value (0 to 1)

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.white)

                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.yellow)
                    .animation(.easeInOut, value: value)
            }
            .cornerRadius(5)
        }
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

