import SwiftUI

struct LevelSelectView: View {
    let levels = Array(1...24) // Example levels (more than one page)
    let columns = [GridItem(.adaptive(minimum: 60, maximum: 80), spacing: 20)] // Grid layout
    @State private var currentPage = 1 // Current page number
    let levelsPerPage = 12 // Number of levels per page

    var body: some View {
        VStack {
            // Level Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(visibleLevels, id: \.self) { level in
                        LevelCard(level: level, progress: Double.random(in: 0...1)) // Random progress for demo
                            .onTapGesture {
                                print("Selected Level \(level)")
                                // Navigate to the selected level here
                            }
                    }
                }
                .padding()
            }

            // Page Navigation
            HStack {
                // Left Arrow
                Button(action: {
                    if currentPage > 1 {
                        currentPage -= 1
                    }
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(currentPage > 1 ? .blue : .gray)
                        .padding()
                }
                .disabled(currentPage <= 1)

                // Page Number
                Text("Page \(currentPage)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)

                // Right Arrow
                Button(action: {
                    if currentPage < totalPages {
                        currentPage += 1
                    }
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(currentPage < totalPages ? .blue : .gray)
                        .padding()
                }
                .disabled(currentPage >= totalPages)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Level Select")
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
    }

    // Calculate visible levels for the current page
    private var visibleLevels: [Int] {
        let startIndex = (currentPage - 1) * levelsPerPage
        let endIndex = min(startIndex + levelsPerPage, levels.count)
        return Array(levels[startIndex..<endIndex])
    }

    // Calculate total number of pages
    private var totalPages: Int {
        Int(ceil(Double(levels.count) / Double(levelsPerPage)))
    }
}


struct LevelCard: View {
    let level: Int
    let progress: Double // Progress from 0 to 1
    let showingStars = false

    var body: some View {
        VStack(spacing: 8) {
//            Text("Level \(level)")
            Text("\(level)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)

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

struct ContentView2: View {
    var body: some View {
//        NavigationView {
            LevelSelectView()
//        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
