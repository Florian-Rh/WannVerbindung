//
//  Journey.swift
//  TransportRestService
//
//  Created by Florian Rhein on 14.10.22.
//

import Foundation

public struct Journey: Codable {
    public struct Leg: Codable {
        public struct Line: Codable {
            public let name: String
        }
        public struct Location: Codable {
            public let name: String
        }
        public let originName: Location
        public let destinationName: Location
        public let departure: Date
        public let plannedDeparture: Date
        public let departureDelay: Int
        public let arrival: Date
        public let plannedArrival: Date
        public let arrivalDelay: Int
        public let Line: Line
        public let cancelled: Bool
    }

    public let legs: [Leg]
}
