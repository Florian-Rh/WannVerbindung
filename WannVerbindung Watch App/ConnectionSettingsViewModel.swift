//
//  ConnectionSettingsViewModel.swift
//  WannVerbindung Watch App
//
//  Created by Florian Rhein on 15.10.22.
//

import Foundation
import WidgetKit
import WannVerbindungServices

@MainActor internal class ConnectionSettingsViewModel: ObservableObject {
    @Published internal var configuration: SharedConfiguration?

    private let sharedConnectionProvider: SharedConfigurationProvider = .init()

    internal init() {

        self.sharedConnectionProvider
            .sharedConfiguration
            .assign(to: &self.$configuration)
    }
}
