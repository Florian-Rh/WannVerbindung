//
//  SharedConfiguration.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 10.03.23.
//

import Foundation

public struct SharedConfiguration: Codable {
    public let origin: Stop
    public let destination: Stop

    public init(origin: Stop, destination: Stop) {
        self.origin = origin
        self.destination = destination
    }

    internal init(dictionary: [String: Any]) {
        guard
            let origin = dictionary["origin"] as? [String: Any],
            let originId = origin["id"] as? String,
            let originName = origin["name"] as? String,
            let destination = dictionary["destination"] as? [String: Any],
            let destinationId = destination["id"] as? String,
            let destionationName = destination["name"] as? String
        else {
            fatalError("invalid configuration received")
        }

        self.origin = .init(id: originId, name: originName)
        self.destination = .init(id: destinationId, name: destionationName)
    }

    internal func serialized() -> [String: Any] {
        [
            "origin": [
                "id": self.origin.id,
                "name": self.origin.name
            ],
            "destination": [
                "id": self.destination.id,
                "name": self.destination.name,
            ],
        ]
    }
}
