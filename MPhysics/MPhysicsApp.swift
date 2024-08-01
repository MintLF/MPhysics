//
//  MPhysicsApp.swift
//  MPhysics
//
//  Created by Mint on 2024/7/26.
//

import SwiftUI

@main
struct MPhysicsApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MPhysicsDocument()) { file in
            ContentView(document: file.$document)
        }
        Settings {
            SettingsView()
        }
    }
}
