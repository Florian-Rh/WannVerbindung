//
//  WannVerbindungApp.swift
//  WannVerbindung
//
//  Created by Florian Rhein on 14.10.22.
//

import SwiftUI
import WannVerbindungServices

@main
struct WannVerbindungApp: App {
    var body: some Scene {
        WindowGroup {
            ConnectionSettingsView()
        }
    }

    init() {}
}
