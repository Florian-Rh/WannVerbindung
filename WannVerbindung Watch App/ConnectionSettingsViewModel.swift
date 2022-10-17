//
//  ConnectionSettingsViewModel.swift
//  WannVerbindung Watch App
//
//  Created by Florian Rhein on 15.10.22.
//

import Foundation
import WidgetKit

@MainActor internal class ConnectionSettingsViewModel: ObservableObject {
    @Published internal var homeStation: String = ""
    @Published internal var workStation: String = ""

    @Published internal var outboundStart: Date = .distantPast
    @Published internal var outboundEnd: Date = .distantPast
    @Published internal var inboundStart: Date = .distantPast
    @Published internal var inboundEnd: Date = .distantPast


    internal func saveConfiguration() {
        let userDefaultSuite = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")
        userDefaultSuite?.set(homeStation, forKey: "homeStation")
        userDefaultSuite?.set(workStation, forKey: "workStation")
        userDefaultSuite?.set(outboundStart, forKey: "outboundStart")
        userDefaultSuite?.set(outboundEnd, forKey: "outboundEnd")
        userDefaultSuite?.set(inboundStart, forKey: "inboundStart")
        userDefaultSuite?.set(inboundEnd, forKey: "inboundEnd")
        WidgetCenter.shared.reloadTimelines(ofKind: "NextDepartureWatchWidget")

        // TODO: add some kind of success notification
    }
}
