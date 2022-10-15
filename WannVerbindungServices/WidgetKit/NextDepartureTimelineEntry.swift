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
    public let plannedDeparture: Date
    public let delay: Int
    public let isCancelled: Bool
    public let dummy: String

    public init(direction: TravelDirection, plannedDeparture: Date, delay: Int, isCancelled: Bool, dummy: String) {
        self.direction = direction
        self.plannedDeparture = plannedDeparture
        self.delay = delay
        self.isCancelled = isCancelled
        self.dummy = dummy
    }

    // MARK: - TimelineEntry

    public let date: Date = Date() // we cannot plan future timeline entries, so we always display them immediatly
}
