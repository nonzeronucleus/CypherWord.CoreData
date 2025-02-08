import SwiftUI
import Dependencies

struct LevelListView : View {
    @EnvironmentObject var viewModel: LevelListViewModel
    
//    @ObservedObject var viewModel : LevelListViewModel
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var showThoughtsView = false
    var levelType: Level.LevelType
    
    init(levelType: Level.LevelType) {
        self.levelType = levelType
    }
    
    var primaryColor: Color {
        levelType == .layout ? .green : .blue
    }
    
    var secondaryColor: Color {
        levelType == .layout ? .teal : .cyan
    }
    
    var body: some View {
        VStack {
            Text(levelType == .layout ? "Layout" :"Level")
                .frame(maxWidth: .infinity)
                .padding(CGFloat(integerLiteral: 20))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .background(primaryColor)
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    let levels = levelType == .layout ? viewModel.layouts : viewModel.levels
                    ForEach(levels) { level in
                        CartoonButton(levelNumber:level.number, gradient:Gradient(colors: [primaryColor, secondaryColor])) {
                            viewModel.selectedLevelID = level.id
                        }
                    }
                }
            }

            if levelType == .layout {
                Button("Add") {
                    viewModel.addLayout()
                }
            }
            Button("Delete all") {
                viewModel.deleteAll(levelType: levelType)
            }
            Button("Import") {
//                viewModel.importLayouts()
            }
            Spacer()
        }
    }
}

#Preview {
    struct FakeLevelRepository: LevelRepositoryProtocol {
        func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], any Error>) -> Void) {
            completion(.success([
                Level(id: UUID(), number: 1, gridText: "Test 1", letterMap: "ABC"),
                Level(id: UUID(), number: 2, gridText: "Test 2", letterMap: "DEF"),
                Level(id: UUID(), number: 3, gridText: "Test 3", letterMap: "GHI")
            ]))
        }
        
        func deleteAll(levelType: Level.LevelType, completion: @escaping (Result<Void, any Error>) -> Void) {
            completion(.success(()))
        }
        
        func addLayout(completion: @escaping (Result<Void, Error>) -> Void) {
            completion(.success(()))
        }
        
        func save(completion: @escaping (Result<Void, Error>) -> Void) {
            completion(.success(()))
        }
    }
    
    let viewModel = LevelListViewModel()
    
    return LevelListView(levelType: .layout)
        .environmentObject(viewModel)
}



