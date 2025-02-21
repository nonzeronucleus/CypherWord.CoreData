import SwiftUI


struct SettingsView: View {
    @State private var viewModel: SettingsViewModel

    init(_ viewModel: SettingsViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Form {
            Toggle("Edit mode", isOn: $viewModel.settings.editMode)
            Toggle("Show completed levels", isOn: $viewModel.settings.showCompletedLevels)
        }
        .navigationTitle("Settings")
    }
}

//struct SettingsView: View {
//    @State var viewModel:SettingsViewModel
//    
////    @State private var notificationsEnabled = true
////    @State private var darkModeEnabled = false
////    @State private var soundEnabled = true
//    
//    init(_ viewModel:SettingsViewModel) {
//        self.viewModel = viewModel
//    }
//
//    var body: some View {
//        VStack {
//            List {
//                // Account Section
//                // Preferences Section
//                Section(header: Text("Preferences")) {
//                    Toggle(isOn: $viewModel.showCompletedLevels) {
//                        Label("Show completed levels", systemImage: "app.badge.checkmark")
//                    }
//                    Toggle(isOn: $viewModel.editMode) {
//                        Label("Edit Mode", systemImage: "pencil")
//                    }
////                    Toggle(isOn: $darkModeEnabled) {
////                        Label("Dark Mode", systemImage: "moon.fill")
////                    }
////                    Toggle(isOn: $soundEnabled) {
////                        Label("Sound Effects", systemImage: "speaker.wave.2.fill")
////                    }
//                }
//
//                // Support Section
//                Section(header: Text("Support")) {
//                    NavigationLink(destination: Text("Help & FAQ")) {
//                        Label("Help & FAQ", systemImage: "questionmark.circle")
//                    }
//                    NavigationLink(destination: Text("Contact Support")) {
//                        Label("Contact Support", systemImage: "envelope.fill")
//                    }
//                }
//            }
//            .navigationTitle("Settings")
//            .navigationBarTitleDisplayMode(.large)
//        }
//    }
//}
//
//#Preview {
//    
//    SettingsView(SettingsViewModel())
//}
