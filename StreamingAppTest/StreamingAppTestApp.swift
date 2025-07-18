//
//  StreamingAppTestApp.swift
//  StreamingAppTest
//
//  Created by jael ruvalcaba on 18/07/25.
//

import SwiftUI

@main
struct StreamingAppTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
