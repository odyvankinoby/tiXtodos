//
//  tiXApp.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//

import SwiftUI

@main
struct tiXApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
