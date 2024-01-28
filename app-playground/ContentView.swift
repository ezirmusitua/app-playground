import CoreData
import SwiftData
import SwiftUI

struct ContentView: View {
  
  var body: some View {
    TabView {
      UserDefaultsView()
        .tabItem {
          Label("UserDefaults", systemImage: "info.circle")
        }
      PropertyListView()
        .tabItem {
          Label("PropertyList", systemImage: "square.stack")
        }
      ArchiverView()
        .tabItem {
          Label("Archiver", systemImage: "sparkles.rectangle.stack.fill")
        }
      SQLiteView()
        .tabItem {
          Label("SQLite", systemImage: "rectangle.stack")
        }
      CoreDataView()
        .tabItem {
          Label("CoreData", systemImage: "square.stack.3d.up.fill")
        }
      SwiftDataView()
        .tabItem {
          Label("SwiftData", systemImage: "square.stack.3d.down.right.fill")
        }
      BookmarkDataView()
        .tabItem {
          Label("BookmarkData", systemImage: "info.circle")
        }
    }
    .padding()
  }
}

#Preview {
  ContentView().modelContainer(for: [PersonSD.self, AddressSD.self])
}
