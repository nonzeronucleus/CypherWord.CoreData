import SwiftUI
import Dependencies

struct OverlayView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: some View  {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            build()
        }
    }
}
//    init() {
//        
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.7)
//                .edgesIgnoringSafeArea(.all)
//        
//            VStack {
//                // A progress spinner centered on the overlay.
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                    .scaleEffect(2.5)
//                
//                Button("Cancel") {
//                    model.cancel()
//                }
//            }
//        }
//    }
//}

