//
//  BlooplyApp.swift
//  Blooply
//
//  Created by Miguel Ferreira on 12/01/2024.
//

import SwiftUI
import SwiftData

@main
struct BlooplyApp: App {
    @State private var convosManager = ConvosManager()

    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Convo.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(convosManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
