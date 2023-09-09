//
//  NextDepartureTimelineProvider.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 09.09.23.
//

import WidgetKit
import SwiftUI
import Intents

public struct NextDepartureTimelineProvider<Intent>: IntentTimelineProvider where Intent: INIntent {
    public typealias ConfigurationIntent = Intent
    public typealias Entry = NextDepartureTimelineEntry

    public init() {}

    public func placeholder(in context: Context) -> NextDepartureTimelineEntry {
        .init(
            direction: .outbound,
            plannedDeparture: nil,
            startStationName: "origin",
            destinationStationName: "destination",
            delay: nil,
            isCancelled: false
        )
    }

    public func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (NextDepartureTimelineEntry) -> ()) {
        completion(
            .init(
                direction: .outbound,
                plannedDeparture: nil,
                startStationName: "origin",
                destinationStationName: "destination",
                delay: nil,
                isCancelled: false
            )
        )
    }

    public func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userDefaultsSuite = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")!
        let homestation = userDefaultsSuite.integer(forKey: "homeStationCode")
        let workstation = userDefaultsSuite.integer(forKey: "workStationCode")
        let timelineReloadpolicy = TimelineReloadPolicy.after(Calendar.current.date(byAdding: .minute, value: 1, to: Date())!)
        Task {
            let timeline: Timeline<NextDepartureTimelineEntry>
            do {
                // TODO: Inject TransportService instead of initializing a fresh one
                let journeySearchResult = try await TransportService().getJourneys(from: homestation, to: workstation)
                // TODO: currently only journey with one leg (no transfer) are supported
                // A more fitting data model should be introduced
                let nextJourneyLeg = journeySearchResult.journeys.first!.legs.first!

                // TODO: currently only one timeline entry is created and refreshed after one minute.
                // To save resources and to make the widget more reliable, more timeline entries for future
                // connections should be added
                timeline = Timeline(
                    entries: [
                        NextDepartureTimelineEntry(
                            direction: .outbound,
                            plannedDeparture: nextJourneyLeg.departure,
                            startStationName: nextJourneyLeg.origin.name,
                            destinationStationName: nextJourneyLeg.destination.name,
                            delay: nextJourneyLeg.departureDelay,
                            isCancelled: nextJourneyLeg.cancelled ?? false
                        )
                    ],
                    policy: timelineReloadpolicy
                )
            } catch {
                timeline = Timeline(
                    entries: [
                        // TODO: distinguish better between error requesting connection and an actually cancelled connection
                        NextDepartureTimelineEntry(
                            direction: .outbound,
                            plannedDeparture: nil,
                            startStationName: "\(homestation)",
                            destinationStationName: "\(workstation)",
                            delay: nil,
                            isCancelled: true
                        )
                    ],
                    policy: timelineReloadpolicy
                )
            }

            completion(timeline)
        }
    }

    public func recommendations() -> [IntentRecommendation<ConfigurationIntent>] {
        []
    }
}
