//
//  ChoreManagementAppApp.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import Dependencies
import SwiftUI

@main
struct Homey: App {
    init() {
        prepareDependencies {
            $0.homeyStore = InMemoryStore(seed: DemoData.demo)
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
