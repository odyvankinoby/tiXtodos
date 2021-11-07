//
//  tiXApp.swift
//  tixWatch WatchKit Extension
//
//  Created by Nicolas Ott on 07.11.21.
//

import SwiftUI

@main
struct tiXApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
