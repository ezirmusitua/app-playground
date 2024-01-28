//
//  app_playgroundApp.swift
//  app-playground
//
//  Created by 林介夫 on 2024/1/27.
//

import SwiftUI

@main
struct app_playgroundApp: App {
  @StateObject private var dataController = DataController()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .modelContainer(for: [PersonSD.self, AddressSD.self])
    }
  }
}
