//
//  NextDepartureTimelineEntry.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 15.10.22.
//

import Foundation
import WidgetKit

public class NextDepartureTimelineEntry: TimelineEntry {
    public let direction: TravelDirection
    public let plannedDeparture: Date?
    public let startStationName: String
    public let destinationStationName: String
    public let delay: Int?
    public let isCancelled: Bool

    public init(
        direction: TravelDirection,
        plannedDeparture: Date?,
        startStationName: String,
        destinationStationName: String,
        delay: Int?,
        isCancelled: Bool
    ) {
        self.direction = direction
        self.plannedDeparture = plannedDeparture
        self.startStationName = startStationName
        self.destinationStationName = destinationStationName
        self.delay = delay
        self.isCancelled = isCancelled
    }

    // MARK: - TimelineEntry

    public let date: Date = Date() // we cannot plan future timeline entries, so we always display them immediatly
}
