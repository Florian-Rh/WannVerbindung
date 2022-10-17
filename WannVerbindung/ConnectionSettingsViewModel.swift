//
//  ConnectionSettingsViewModel.swift
//  WannVerbindung
//
//  Created by Florian Rhein on 14.10.22.
//

import Foundation
import WannVerbindungServices
import WidgetKit

@MainActor internal class ConnectionSettingsViewModel: ObservableObject {
    @Published internal var homeStation: String
    @Published internal var workStation: String

    @Published internal var outboundStart: Date = .distantPast
    @Published internal var outboundEnd: Date = .distantPast
    @Published internal var inboundStart: Date = .distantPast
    @Published internal var inboundEnd: Date = .distantPast

    @Published internal var isShowingAlert: Bool = false
    internal var alertMessage: String = ""

    internal let transportService: TransportService = TransportService()

    // TODO: computed properties for now, the station codes should be set using a response from `getStops`
    private var homeStationCode: Int {
        .init(self.homeStation)!
    }

    private var workStationCode: Int {
        .init(self.workStation)!
    }

    internal init() {
        let userDefautsSuite = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")
        self.homeStation = userDefautsSuite?.string(forKey: "homeStationCode") ?? ""
        self.workStation = userDefautsSuite?.string(forKey: "workStationCode") ?? ""
    }

    internal func saveConfiguration() {
        let userDefaultSuite = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")
        userDefaultSuite?.set(homeStationCode, forKey: "homeStationCode")
        userDefaultSuite?.set(workStationCode, forKey: "workStationCode")
        userDefaultSuite?.set(outboundStart, forKey: "outboundStart")
        userDefaultSuite?.set(outboundEnd, forKey: "outboundEnd")
        userDefaultSuite?.set(inboundStart, forKey: "inboundStart")
        userDefaultSuite?.set(inboundEnd, forKey: "inboundEnd")
        WidgetCenter.shared.reloadTimelines(ofKind: "NextDepartureIPhoneWidget")

        // TODO: add some kind of success notification
    }

    internal func searchConnections() {
        let homeStationCode = Int(homeStation)!
        let workStationCode = Int(workStation)!
        Task {
            do {
                let journey = try await transportService.getJourneys(from: homeStationCode, to: workStationCode)
            } catch let error {
                if let apiError = error as? ApiError {
                    self.alertMessage = apiError.localizedDescription
                } else {
                    self.alertMessage = error.localizedDescription
                }

                self.isShowingAlert = true
            }

            // TODO: trigger navigation to NextConnectionsView (TBA)
        }
    }
}
