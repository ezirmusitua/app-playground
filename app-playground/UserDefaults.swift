import Foundation
import SwiftUI

struct UserSettings {
  var username: String
  var notificationsEnabled: Bool
}

class UserDefaultsManager {
  static let shared = UserDefaultsManager()
  private let userDefaults = UserDefaults.standard
  private let keyUsername = "Username"
  private let keyNotificationsEnabled = "NotificationsEnabled"
  
  func saveUserSettings(_ settings: UserSettings) {
    userDefaults.set(settings.username, forKey: keyUsername)
    userDefaults.set(settings.notificationsEnabled, forKey: keyNotificationsEnabled)
    userDefaults.synchronize()
  }
  
  func loadUserSettings() -> UserSettings? {
    guard let username = userDefaults.string(forKey: keyUsername) else { return nil }
    let notificationsEnabled = userDefaults.bool(forKey: keyNotificationsEnabled)
    return UserSettings(username: username, notificationsEnabled: notificationsEnabled)
  }
}

struct UserDefaultsView : View {
  @State var settings: UserSettings = UserSettings(username: "", notificationsEnabled: false)
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      TextField("USERNAME", text: $settings.username).textFieldStyle(RoundedBorderTextFieldStyle())
      Toggle(isOn: $settings.notificationsEnabled, label: {
        Label("NOTIFICATION ENABLED", systemImage: "info.circle")
      })
      HStack {
        Spacer()
        Button("UPDATE") {
          updateUserSettings()
        }
      }
    }.padding().onAppear() {
      if let settings = UserDefaultsManager.shared.loadUserSettings() {
        self.settings = settings
      } else {
        print("No user settings found.")
      }
    }
  }
  
  private func updateUserSettings() {
    UserDefaultsManager.shared.saveUserSettings(settings)
  }
}

#Preview {
  UserDefaultsView()
}
