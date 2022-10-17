//
//  Journey.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 14.10.22.
//

import Foundation

public struct JourneySearchResult: Codable {
    public let earlierRef: String
    public let laterRef: String
    public let journeys: [Journey]
}

public struct Journey: Codable {
    public struct Leg: Codable {
        public struct Line: Codable {
            public let name: String
        }
        public struct Location: Codable {
            public let name: String
        }
        public let origin: Location
        public let destination: Location
        public let departure: Date
        public let plannedDeparture: Date
        public let departureDelay: Int?
        public let arrival: Date
        public let plannedArrival: Date
        public let arrivalDelay: Int?
        public let line: Line
        public let cancelled: Bool?
    }

    public let legs: [Leg]
}
