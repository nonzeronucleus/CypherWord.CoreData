import SwiftUI
import Foundation
import Dependencies

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                Toggle(isOn: $settingsViewModel.settings.showCompletedLevels) {
                    Label("Show completed levels", systemImage: "app.badge.checkmark")
                }
                Toggle(isOn: $settingsViewModel.settings.editMode) {
                    Label("Edit Mode", systemImage: "pencil")
                }
            }
            Section(header: Text("Support")) {
                NavigationLink(destination: Text("Help & FAQ")) {
                    Label("Help & FAQ", systemImage: "questionmark.circle")
                }
                NavigationLink(destination: Text("Contact Support")) {
                    Label("Contact Support", systemImage: "envelope.fill")
                }
            }

        }
        .navigationTitle("Settings")
    }
}


#Preview {
    @Dependency(\.uuid) var uuid

    let id = uuid()
    
    SettingsView()
        .environmentObject(SettingsViewModel(parentId: id))

}
