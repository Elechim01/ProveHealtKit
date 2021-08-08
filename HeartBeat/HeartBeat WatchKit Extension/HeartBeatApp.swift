//
//  HeartBeatApp.swift
//  HeartBeat WatchKit Extension
//
//  Created by Michele Manniello on 08/08/21.
//

import SwiftUI

@main
struct HeartBeatApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
