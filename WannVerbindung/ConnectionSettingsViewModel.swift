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
    internal enum StopType {
        case home
        case destination
    }

    @Published internal var homeStation: String {
        didSet {
            self.seachStop(ofType: .home)
        }
    }

    @Published internal var workStation: String {
        didSet {
            self.seachStop(ofType: .destination)
        }
    }

    @Published internal var outboundStart: Date = .distantPast
    @Published internal var outboundEnd: Date = .distantPast
    @Published internal var inboundStart: Date = .distantPast
    @Published internal var inboundEnd: Date = .distantPast

    @Published internal var isShowingAlert: Bool = false
    internal var alertMessage: String = ""

    internal let transportService: TransportService = TransportService()

    private var homeStationCode: Int?
    private var workStationCode: Int?

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

    internal func seachStop(ofType type: StopType) {
        let stopQuery: String

        // TODO: clear up naming (work / destination is inaccurate)
        switch type {
            case .home:
                stopQuery = self.homeStation
            case .destination:
                stopQuery = workStation
        }

        Task {
            do {
                let stop = try await transportService.getStops(forQuery: stopQuery).first!

                switch type {
                    case .home:
                        self.homeStationCode = Int(stop.id)
                        self.homeStation = stop.name
                    case .destination:
                        self.workStationCode = Int(stop.id)
                        self.workStation = stop.name
                }
            } catch let error {
                if let apiError = error as? ApiError {
                    self.alertMessage = apiError.localizedDescription
                } else {
                    self.alertMessage = error.localizedDescription
                }

                self.isShowingAlert = true
            }
        }
    }

    internal func searchConnections() {
        Task {
            do {
                guard
                    let homeStationCode = self.homeStationCode,
                    let workStationCode = self.workStationCode
                else {
                    self.alertMessage = "Destination or stop invalid"
                    self.isShowingAlert = true

                    return
                }

                let journey = try await transportService.getJourneys(
                    from: homeStationCode,
                    to: workStationCode
                )
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
