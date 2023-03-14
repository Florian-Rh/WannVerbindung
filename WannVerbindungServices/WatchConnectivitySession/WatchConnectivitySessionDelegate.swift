//
//  WatchConnectivitySessionDelegate.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 10.03.23.
//

import Combine
import Foundation
import WatchConnectivity

internal class WatchConnectivitySessionDelegate: NSObject, WCSessionDelegate {
    internal let sharedConfiguration: PassthroughSubject<SharedConfiguration?, Never>

    internal init(sharedConfiguration: PassthroughSubject<SharedConfiguration?, Never>) {
        self.sharedConfiguration = sharedConfiguration
    }

    // WCSessionDelegate

    internal func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}

    internal func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        self.sharedConfiguration
            .send(
                .init(dictionary: message)
            )
    }

    // iOS Protocol comformance
    #if os(iOS)
    internal func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }

    internal func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }

    internal func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif
}
