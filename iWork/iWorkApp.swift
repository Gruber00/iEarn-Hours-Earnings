//
//  iWorkApp.swift
//  iWork
//
//  Created by Felix on 26.06.26.
//

import SwiftData
import SwiftUI

@main
struct iWorkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [WorkEntry.self, SettingsModel.self])
    }
}
