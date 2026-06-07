//
//  AppModel.swift
//  Homey
//

import Observation

@MainActor
@Observable
final class AppModel {
    var selectedTab: AppTab = .home
    var isAddTaskPresented = false
}

enum AppTab: Hashable {
    case home
    case statistics
    case profile
}
