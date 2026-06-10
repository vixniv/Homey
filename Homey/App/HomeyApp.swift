//
//  HomeyApp.swift
//  Homey
//

import SwiftUI

@main
struct Homey: App {
    init() {
        NotificationManager.shared.requestPermission()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
