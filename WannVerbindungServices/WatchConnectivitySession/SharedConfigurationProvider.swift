//
//  WatchConnectivitySession.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 15.10.22.
//

import Combine
import Foundation
import WatchConnectivity

public class SharedConfigurationProvider {
    public let sharedConfiguration: PassthroughSubject<SharedConfiguration?, Never> = .init()

    private let delegate: WatchConnectivitySessionDelegate
    private let session: WCSession
    private let sharedConfigurationSubscriber: AnyCancellable

    public init(session: WCSession = .default) {
        self.delegate = WatchConnectivitySessionDelegate(sharedConfiguration: self.sharedConfiguration)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()

        let userDefaultSuite = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")
        if let storedConfigurationDictionary = userDefaultSuite?.dictionary(forKey: "sharedConfiguration") {
            self.sharedConfiguration.send(.init(dictionary: storedConfigurationDictionary))
        }

        self.sharedConfigurationSubscriber = self.sharedConfiguration
            .sink { sharedConfiguration in
                userDefaultSuite?.set(sharedConfiguration?.serialized(), forKey: "sharedConfiguration")
            }
    }

    deinit {
        self.sharedConfigurationSubscriber.cancel()
    }

    public func updateConfiguration(_ configuration: SharedConfiguration) {
        self.session.sendMessage(configuration.serialized(), replyHandler: nil)
    }
}
