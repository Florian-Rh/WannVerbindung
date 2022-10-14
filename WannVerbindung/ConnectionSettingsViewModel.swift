//
//  ConnectionSettingsViewModel.swift
//  WannVerbindung
//
//  Created by Florian Rhein on 14.10.22.
//

import Foundation

@MainActor internal class ConnectionSettingsViewModel: ObservableObject {
    @Published internal var homeStation: String = ""
    @Published internal var workStation: String = ""

    @Published internal var outboundStart: Date = .distantPast
    @Published internal var outboundEnd: Date = .distantPast
    @Published internal var inboundStart: Date = .distantPast
    @Published internal var inboundEnd: Date = .distantPast


    internal func saveConfiguration() {

    }

}
