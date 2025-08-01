//
//  StreamingAppTestApp.swift
//  StreamingAppTest
//
//  Created by jael ruvalcaba on 18/07/25.
//

import SwiftUI

@main
struct StreamingAppTestApp: App {
    @StateObject private var coordinator = Coordinator()
    @StateObject private var persistence = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let view = coordinator.currentView {
                    view
                        .environment(\.managedObjectContext, persistence.container.viewContext)
                        .environmentObject(coordinator)
                        .environmentObject(persistence)
                } else {
                    Text("Cargando...")
                        .environment(\.managedObjectContext, persistence.container.viewContext)
                }
            }
        }
    }
}
